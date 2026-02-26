# App Bootstrap Checklist

1. Scaffold with app CLI.
2. Define configs for `dev/sandbox/prod/autotest`.
3. Add proto contracts and generation flow.
4. Implement provider/service/domain layers.
5. Add `make test` + testdata bootstrap.
6. Configure CI test services.
7. Add ArgoCD manifests.
8. Add Terraform baseline resources.
9. Add observability baseline (dashboard/alerts).
10. Add runbook links to references.

## Coupling Checklist
1. ECR repo and rollout image path match.
2. Route53 host and ingress host match.
3. Service account role annotation matches Terraform IAM role.
4. Rollout/service/ingress port names match.

## Sequence (recommended)
1. App code scaffold.
2. Terraform minimal infra.
3. Optional infra (IAM/DB/Redis/SQS).
4. Argo manifests.
5. Coupling validation.
6. Argo app create and rollout.

## Template Pack
- Reusable infra/app bootstrap assets:
  - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/references/templates/app-bootstrap-pack`
