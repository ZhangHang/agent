# ArgoCD Playbook

## Scope
How to inspect and update app runtime manifests across environments.

## Local Bump Automation
- Wrapper script:
  - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_bump.sh`
- Underlying local utility:
  - `/Users/zhanghang/repo/config/scripts/bump.sh`
- Environment mapping in wrapper:
  - `meican2` -> `argocd-prod`
  - `meican1` -> `argocd-production`
  - `sandbox` -> `argocd-sandbox`
- Current daily usage is primarily `meican2`; wrapper already reserves `meican1` and `sandbox`.

Example:
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_bump.sh \
  --env meican2 --server planet --version v0.88.2
```

## Core Files (typical)
- `webapp.yaml`
- `rollout.yaml`
- `service.yaml`
- `istio-virtual-service.yaml`
- `istio-destination-rule.yaml`
- optional: ingress/hpa/service-account/service-monitor/pagerduty

## Checklist
1. Confirm namespace and app labels.
2. Confirm image path/tag.
3. Confirm service ports and ingress backend alignment.
4. Confirm canary routing and health probes.
5. Confirm env-specific domain suffix.
