# argocd_bump.sh Contract

## Purpose
调用外部 bump 脚本更新 ArgoCD rollout image tag。

## Status
optional

## Default Routing
non-default (not part of primary workflow)

## Required Args
- `--env <meican2|meican1|sandbox>`
- `--server <name>`
- `--version <tag>`

## Safety Constraints
- mutates ArgoCD repo (branch + commit)
- may require interactive selection in ambiguous server names

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_bump.sh \
  --env meican2 --server planet --version v0.88.2
```

## Expected Output Shape
- execution header with env/repo/server/version
- delegated output from `/Users/zhanghang/repo/config/scripts/bump.sh`
