#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: db_checks.sh --env <sandbox|production|prod> --sql-file <path>
For production, this script prints SQL suggestion only and does not execute.
USAGE
}

env=""
sql_file=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) env="$2"; shift 2 ;;
    --sql-file) sql_file="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$env" || -z "$sql_file" ]]; then
  usage
  exit 2
fi

if [[ ! -f "$sql_file" ]]; then
  echo "sql file not found: $sql_file" >&2
  exit 2
fi

if [[ "$env" == "production" || "$env" == "prod" ]]; then
  echo "[safe-mode] production env detected. SQL execution disabled."
  echo "SQL suggestion from: $sql_file"
  cat "$sql_file"
  exit 0
fi

echo "[template] non-production env=$env"
echo "TODO: plug in readonly DB query command."
