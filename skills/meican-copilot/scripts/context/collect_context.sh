#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: collect_context.sh --env <sandbox|production|prod> --service <name> [--id <value>] [--from <ISO>] [--to <ISO>]
Prints a normalized context header for incident/debug tasks.
USAGE
}

env=""
service=""
id=""
from=""
to=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) env="$2"; shift 2 ;;
    --service) service="$2"; shift 2 ;;
    --id) id="$2"; shift 2 ;;
    --from) from="$2"; shift 2 ;;
    --to) to="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$env" || -z "$service" ]]; then
  usage
  exit 2
fi

cat <<OUT
env=$env
service=$service
id=${id:-N/A}
from=${from:-N/A}
to=${to:-N/A}
OUT
