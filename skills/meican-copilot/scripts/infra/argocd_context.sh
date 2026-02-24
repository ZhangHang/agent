#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: argocd_context.sh --env <sandbox|production|prod> --app <app_name>
Prints ArgoCD root path and app directory candidates.
USAGE
}

env=""
app=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) env="$2"; shift 2 ;;
    --app) app="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$env" || -z "$app" ]]; then
  usage
  exit 2
fi

case "$env" in
  sandbox) root="/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox" ;;
  production) root="/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production" ;;
  prod) root="/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod" ;;
  *) echo "invalid env: $env" >&2; exit 2 ;;
esac

echo "argocd_root=$root"
find "$root" -maxdepth 3 -type d -name "$app" | sed 's/^/candidate=/' || true
