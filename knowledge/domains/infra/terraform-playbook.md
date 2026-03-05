# Terraform Playbook

## Scope
How app-level Terraform is structured, coupled with Argo runtime manifests, and validated per environment.

## Environment Mapping
- `sandbox`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
- `production` (`meican1`): `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
- `prod` (`meican2`): `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## Baseline Modules (minimal required)
- `env.tf`
- `context.tf`
- `locals.tf`
- `ecr.tf`
- `route53.tf` (if exposed service)

## Optional Modules (common)
- IAM: `iam.tf`
- DB/cache resources and alarms: `pg.tf`, `redis_non_cluster.tf`, `pg_alarms.tf`, `redis_alarms.tf`
- SQS/resources by app-specific needs

## Real Examples
- Lean baseline (`app-constraint`):
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox/planet/app-constraint/sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod/planet/app-constraint/production`
- Complex baseline (`dapi-be`):
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox/developer/dapi-be/sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod/developer/dapi-be/production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production/developer/dapi-be/production`

## Safety Rules
1. Avoid blind `destroy/apply` in production contexts.
2. Verify state backend bucket/key by environment.
3. Validate provider credentials scope before run.
4. Keep app-level terraform and Argo manifest image/host/role consistent.

## Coupling Checks (Terraform <-> ArgoCD)
1. ECR repo name matches rollout image path.
2. Route53 host matches ingress host.
3. IAM role ARN matches `service-account.yaml` annotation.
4. Exposed container ports align with service and ingress backend names.

## Recommended Creation Sequence
1. Scaffold app code repo and runtime ports/config.
2. Create Terraform minimal set (`env/context/locals/ecr/route53`).
3. Add optional Terraform resources only when required (IAM/DB/Redis/SQS/alarms).
4. Validate coupling items before Argo rollout.
