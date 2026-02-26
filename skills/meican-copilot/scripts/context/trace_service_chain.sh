#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/Users/zhanghang/go/src/go.planetmeican.com"
SERVICE=""
METHOD=""
MAX_LINES=200

usage() {
  cat <<USAGE
Usage:
  trace_service_chain.sh --service <service-path> --method <method-name> [--repo-root <path>] [--max-lines <n>]

Examples:
  trace_service_chain.sh --service planet/ops --method VerifyDineInOrder
  trace_service_chain.sh --service nation-client/id-card --method GetIdCardDetails

Notes:
  - read-only helper, prints file anchors and candidate chain points.
  - service path is relative to repo root, e.g. planet/ops.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo-root)
      REPO_ROOT="$2"
      shift 2
      ;;
    --service)
      SERVICE="$2"
      shift 2
      ;;
    --method)
      METHOD="$2"
      shift 2
      ;;
    --max-lines)
      MAX_LINES="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$SERVICE" || -z "$METHOD" ]]; then
  echo "--service and --method are required" >&2
  usage
  exit 2
fi

TARGET_DIR="$REPO_ROOT/$SERVICE"
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "service dir not found: $TARGET_DIR" >&2
  exit 3
fi

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) is required" >&2
  exit 4
fi

echo "=== Trace Inputs ==="
echo "repo_root: $REPO_ROOT"
echo "service:   $SERVICE"
echo "method:    $METHOD"
echo

echo "=== Entrypoint Candidates ==="
rg -n "${METHOD}" "$TARGET_DIR/internal/net" "$TARGET_DIR/internal/handler" -S \
  --glob '!vendor/**' --glob '*.go' 2>/dev/null | head -n "$MAX_LINES" || true
echo

echo "=== Service/Domain Candidates ==="
rg -n "${METHOD}|service\.|domain_|\.Emit\(|\.GetClient\(|rpc\.New\(" "$TARGET_DIR/internal" -S \
  --glob '!vendor/**' --glob '*.go' | head -n "$MAX_LINES" || true
echo

echo "=== RPC Config Anchors ==="
rg -n "\[rpc\.|address\s*=\s*\"" "$TARGET_DIR/config" -S \
  --glob '*.toml' | head -n "$MAX_LINES" || true
echo

echo "=== Proto Anchors (if any) ==="
rg -n "${METHOD}" "$TARGET_DIR" -S --glob '*.proto' --glob '!vendor/**' | head -n "$MAX_LINES" || true
