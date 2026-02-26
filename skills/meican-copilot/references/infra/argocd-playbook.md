# ArgoCD Playbook

## Scope
How to inspect and update app runtime manifests across environments.

## Environment Mapping
- `sandbox`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
- `production` (`meican1`): `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
- `prod` (`meican2`): `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`

## Local Bump Automation
- Wrapper script:
  - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_bump.sh`
- Underlying local utility:
  - `/Users/zhanghang/repo/config/scripts/bump.sh`
- Environment mapping in wrapper:
  - `meican2` -> `argocd-prod`
  - `meican1` -> `argocd-production`
  - `sandbox` -> `argocd-sandbox`

Example:
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_bump.sh \
  --env meican2 --server planet --version v0.88.2
```

## Core Files (minimal)
- `webapp.yaml`
- `rollout.yaml`
- `service.yaml`
- `istio-virtual-service.yaml`
- `istio-destination-rule.yaml`

## Optional Files (common)
- `ingress-kong1.yaml` / `ingress-kong2.yaml`
- `hpa.yaml` / `cron-hpa.yaml`
- `service-monitor.yaml`, `pagerduty.yaml`
- `service-account.yaml`
- `sidecar.yaml`, `serviceentry.yaml`
- `tiered-application.yaml`

## Checklist
1. Confirm namespace and app labels.
2. Confirm image path/tag.
3. Confirm service ports and ingress backend alignment.
4. Confirm canary routing and health probes.
5. Confirm env-specific domain suffix and account-dependent endpoints.
