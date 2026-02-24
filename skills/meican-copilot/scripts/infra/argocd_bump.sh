#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: argocd_bump.sh --env <meican2|meican1|sandbox> --server <name> --version <tag>

Examples:
  argocd_bump.sh --env meican2 --server planet --version v0.88.2
  argocd_bump.sh --env meican1 --server client --version v0.79.2
  argocd_bump.sh --env sandbox --server id-card-adapter --version v0.3.5

Notes:
- This wrapper runs /Users/zhanghang/repo/config/scripts/bump.sh in the target ArgoCD repo.
- bump.sh will create branch feat/<server> inside that ArgoCD repo and commit rollout.yaml change.
- If multiple servers share the same name across groups, bump.sh may ask for interactive selection.
USAGE
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 2
  fi
}

ENV_NAME=""
SERVER_NAME=""
VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --env) ENV_NAME="$2"; shift 2 ;;
    --server) SERVER_NAME="$2"; shift 2 ;;
    --version) VERSION="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown arg: $1" >&2; usage; exit 2 ;;
  esac
done

if [[ -z "$ENV_NAME" || -z "$SERVER_NAME" || -z "$VERSION" ]]; then
  usage
  exit 2
fi

case "$ENV_NAME" in
  meican2)
    ARGOCD_REPO="/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod"
    ;;
  meican1)
    ARGOCD_REPO="/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production"
    ;;
  sandbox)
    ARGOCD_REPO="/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox"
    ;;
  *)
    echo "invalid --env: $ENV_NAME (use meican2|meican1|sandbox)" >&2
    exit 2
    ;;
esac

BUMP_SCRIPT="/Users/zhanghang/repo/config/scripts/bump.sh"

need_cmd git
need_cmd bash

if [[ ! -d "$ARGOCD_REPO/.git" ]]; then
  echo "argocd repo not found or not a git repo: $ARGOCD_REPO" >&2
  exit 2
fi

if [[ ! -x "$BUMP_SCRIPT" ]]; then
  echo "bump script not found or not executable: $BUMP_SCRIPT" >&2
  exit 2
fi

echo "[argocd_bump] env=$ENV_NAME repo=$ARGOCD_REPO server=$SERVER_NAME version=$VERSION"
(
  cd "$ARGOCD_REPO"
  "$BUMP_SCRIPT" "$SERVER_NAME" "$VERSION"
)
