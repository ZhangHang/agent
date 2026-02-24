# ArgoCD Playbook

## Scope
How to inspect and update app runtime manifests across environments.

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
