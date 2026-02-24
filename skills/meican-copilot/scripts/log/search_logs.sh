#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  search_logs.sh --mode <ck|ck-stream|s3|list-apps|list-fields|list-tree> --env <sandbox|production|prod> [options]

Core options:
  --base-url <url>          API base url. Default: https://logclick-nw.planetmeican.com/api
  --cookie <cookie-string>  Cookie header content for authenticated requests
  --cookie-file <path>      Read Cookie header content from file
  --timeout <seconds>       Request timeout (default: 60)
  --dry-run                 Print curl command and payload only

Time and query options (for ck/ck-stream/s3):
  --from <ISO-8601>         Query start time (e.g. 2026-02-24T10:00:00+08:00)
  --to <ISO-8601>           Query end time
  --limit <int>             Result limit (default: 3000)
  --sort-order <Desc|Asc>   Sort order (default: Desc)
  --keyword <text>          Phrase keyword on raw_log (isEmbed=true)
  --filter <field=value>    Exact filter, repeatable

Mode-specific options:
  --mode ck|ck-stream
    --app <app-name>        Optional app exact filter shortcut

  --mode s3
    --domain <name>         Required
    --namespace <name>      Required
    --name <name>           Required

  --mode list-fields
    --from <ISO-8601> --to <ISO-8601>

Examples:
  search_logs.sh --mode ck --env sandbox \
    --from 2026-02-24T10:00:00+08:00 --to 2026-02-24T11:00:00+08:00 \
    --keyword "authorization verify err" --filter level=ERROR --limit 200

  search_logs.sh --mode s3 --env prod \
    --from 2026-02-24T10:00:00+08:00 --to 2026-02-24T11:00:00+08:00 \
    --domain app-nation-client --namespace app-nation-client --name client \
    --filter request_id=abc123
USAGE
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 2
  fi
}

json_value() {
  local v="$1"
  if [[ "$v" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    jq -cn --argjson n "$v" '{numberValue:$n}'
  else
    jq -cn --arg s "$v" '{stringValue:$s}'
  fi
}

append_is_filter() {
  local field="$1"
  local value="$2"
  local value_json
  value_json="$(json_value "$value")"
  FILTERS_JSON="$(jq -cn --argjson filters "$FILTERS_JSON" --arg f "$field" --argjson v "$value_json" '$filters + [{is:{field:$f,value:$v}}]')"
}

append_phrase_filter() {
  local keyword="$1"
  FILTERS_JSON="$(jq -cn --argjson filters "$FILTERS_JSON" --arg kw "$keyword" '$filters + [{phrase:{field:"raw_log",keyword:$kw,isEmbed:true}}]')"
}

MODE=""
ENV_NAME=""
BASE_URL="https://logclick-nw.planetmeican.com/api"
COOKIE=""
COOKIE_FILE=""
TIMEOUT=60
DRY_RUN=0

FROM=""
TO=""
LIMIT=3000
SORT_ORDER="Desc"
KEYWORD=""
APP_NAME=""
DOMAIN=""
NAMESPACE=""
NAME=""

FILTERS_JSON='[]'

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode) MODE="$2"; shift 2 ;;
    --env) ENV_NAME="$2"; shift 2 ;;
    --base-url) BASE_URL="$2"; shift 2 ;;
    --cookie) COOKIE="$2"; shift 2 ;;
    --cookie-file) COOKIE_FILE="$2"; shift 2 ;;
    --timeout) TIMEOUT="$2"; shift 2 ;;
    --dry-run) DRY_RUN=1; shift 1 ;;

    --from) FROM="$2"; shift 2 ;;
    --to) TO="$2"; shift 2 ;;
    --limit) LIMIT="$2"; shift 2 ;;
    --sort-order) SORT_ORDER="$2"; shift 2 ;;
    --keyword) KEYWORD="$2"; shift 2 ;;
    --filter)
      KV="$2"
      shift 2
      if [[ "$KV" != *=* ]]; then
        echo "invalid --filter format, expected field=value, got: $KV" >&2
        exit 2
      fi
      FKEY="${KV%%=*}"
      FVAL="${KV#*=}"
      append_is_filter "$FKEY" "$FVAL"
      ;;
    --app) APP_NAME="$2"; shift 2 ;;
    --domain) DOMAIN="$2"; shift 2 ;;
    --namespace) NAMESPACE="$2"; shift 2 ;;
    --name) NAME="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

need_cmd curl
need_cmd jq

if [[ -z "$MODE" || -z "$ENV_NAME" ]]; then
  usage
  exit 2
fi

if [[ -n "$COOKIE_FILE" ]]; then
  if [[ ! -f "$COOKIE_FILE" ]]; then
    echo "cookie file not found: $COOKIE_FILE" >&2
    exit 2
  fi
  COOKIE="$(cat "$COOKIE_FILE")"
fi

if [[ "$SORT_ORDER" != "Desc" && "$SORT_ORDER" != "Asc" ]]; then
  echo "--sort-order must be Desc or Asc" >&2
  exit 2
fi

if [[ -n "$KEYWORD" ]]; then
  append_phrase_filter "$KEYWORD"
fi

if [[ -n "$APP_NAME" ]]; then
  append_is_filter "app" "$APP_NAME"
fi

BASE_URL="${BASE_URL%/}"

build_ck_payload() {
  jq -cn \
    --arg left "$FROM" \
    --arg right "$TO" \
    --arg order "$SORT_ORDER" \
    --argjson limit "$LIMIT" \
    --argjson filters "$FILTERS_JSON" \
    '{
      sort:{field:"timestamp",order:$order},
      aggregation:{field:"timestamp"},
      query:{range:{left:$left,right:$right},filters:$filters,limit:$limit}
    }'
}

build_s3_payload() {
  jq -cn \
    --arg left "$FROM" \
    --arg right "$TO" \
    --arg order "$SORT_ORDER" \
    --arg domain "$DOMAIN" \
    --arg namespace "$NAMESPACE" \
    --arg name "$NAME" \
    --argjson limit "$LIMIT" \
    --argjson filters "$FILTERS_JSON" \
    '{
      sort:{field:"timestamp",order:$order},
      aggregation:{field:"timestamp"},
      query:{timeRange:{left:$left,right:$right},filters:$filters,domain:$domain,namespace:$namespace,name:$name,limit:$limit}
    }'
}

require_time_window() {
  if [[ -z "$FROM" || -z "$TO" ]]; then
    echo "--from and --to are required for mode $MODE" >&2
    exit 2
  fi
}

run_get() {
  local url="$1"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ -n "$COOKIE" ]]; then
      echo "curl --fail --show-error --silent --max-time $TIMEOUT -H 'Cookie: <redacted>' '$url'"
    else
      echo "curl --fail --show-error --silent --max-time $TIMEOUT '$url'"
    fi
    return 0
  fi

  if [[ -n "$COOKIE" ]]; then
    curl --fail --show-error --silent --max-time "$TIMEOUT" -H "Cookie: $COOKIE" "$url"
  else
    curl --fail --show-error --silent --max-time "$TIMEOUT" "$url"
  fi
}

run_post() {
  local url="$1"
  local body="$2"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    if [[ -n "$COOKIE" ]]; then
      echo "curl --fail --show-error --silent --max-time $TIMEOUT -H 'Content-Type: application/json' -H 'Cookie: <redacted>' -X POST '$url' -d '<payload>'"
    else
      echo "curl --fail --show-error --silent --max-time $TIMEOUT -H 'Content-Type: application/json' -X POST '$url' -d '<payload>'"
    fi
    echo "$body" | jq .
    return 0
  fi

  if [[ -n "$COOKIE" ]]; then
    curl --fail --show-error --silent --max-time "$TIMEOUT" \
      -H "Content-Type: application/json" \
      -H "Cookie: $COOKIE" \
      -X POST "$url" -d "$body"
  else
    curl --fail --show-error --silent --max-time "$TIMEOUT" \
      -H "Content-Type: application/json" \
      -X POST "$url" -d "$body"
  fi
}

case "$MODE" in
  list-apps)
    if [[ "$DRY_RUN" -eq 1 ]]; then
      run_get "$BASE_URL/v1/ck/apps"
    else
      run_get "$BASE_URL/v1/ck/apps" | jq .
    fi
    ;;
  list-fields)
    require_time_window
    fields_url="$BASE_URL/v1/ck/fields?range.left=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))' "$FROM")&range.right=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))' "$TO")"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      run_get "$fields_url"
    else
      run_get "$fields_url" | jq .
    fi
    ;;
  list-tree)
    if [[ "$DRY_RUN" -eq 1 ]]; then
      run_get "$BASE_URL/v1/s3/tree"
    else
      run_get "$BASE_URL/v1/s3/tree" | jq .
    fi
    ;;
  ck|ck-stream)
    require_time_window
    payload="$(build_ck_payload)"
    if [[ "$MODE" == "ck" ]]; then
      if [[ "$DRY_RUN" -eq 1 ]]; then
        run_post "$BASE_URL/v1/ck/search" "$payload"
      else
        run_post "$BASE_URL/v1/ck/search" "$payload" | jq .
      fi
    else
      if [[ "$DRY_RUN" -eq 1 ]]; then
        run_post "$BASE_URL/v1/ck/stream-search" "$payload"
      else
        run_post "$BASE_URL/v1/ck/stream-search" "$payload" | jq .
      fi
    fi
    ;;
  s3)
    require_time_window
    if [[ -z "$DOMAIN" || -z "$NAMESPACE" || -z "$NAME" ]]; then
      echo "--domain --namespace --name are required for mode s3" >&2
      exit 2
    fi
    payload="$(build_s3_payload)"
    if [[ "$DRY_RUN" -eq 1 ]]; then
      run_post "$BASE_URL/v2/s3/search" "$payload"
    else
      run_post "$BASE_URL/v2/s3/search" "$payload" | jq .
    fi
    ;;
  *)
    echo "unsupported mode: $MODE" >&2
    usage
    exit 2
    ;;
esac
