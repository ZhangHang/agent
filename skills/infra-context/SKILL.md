---
name: infra-context
description: Locate ArgoCD and Terraform context by environment and app using lightweight context scripts.
---

# infra-context

## Trigger
Use when user needs deployment or infra root/app path discovery for a target environment.

## Workflow
1. Read contracts:
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/infra/scripts/argocd-context.md`
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/infra/scripts/terraform-context.md`
2. Run one or both scripts:
   - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_context.sh --env <sandbox|production|prod> --app <app_name>`
   - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/terraform_context.sh --env <sandbox|production|prod> --app <app_name>`
3. Return root path + candidate directories + environment caveats.

## When Not To Use
- Do not use for rollout tag updates; `argocd_bump.sh` is optional and not in default workflow.
