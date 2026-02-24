#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: trace_lookup.sh --env <sandbox|production|prod> --trace-id <id>
Template wrapper for trace lookup.
USAGE
}

env=""
trace_id=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) env="$2"; shift 2 ;;
    --trace-id) trace_id="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$env" || -z "$trace_id" ]]; then
  usage
  exit 2
fi

echo "[template] env=$env trace_id=$trace_id"
echo "TODO: plug in tracing query command."
