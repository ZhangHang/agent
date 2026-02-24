# Terraform Playbook

## Scope
How app-level Terraform is structured and validated.

## Baseline Modules
- `env.tf`
- `context.tf`
- `locals.tf`
- `ecr.tf`
- `route53.tf` (if exposed service)

## Optional Modules
- IAM: `iam.tf`
- DB/cache resources and alarms
- SQS/resources by app-specific needs

## Safety Rules
1. Avoid blind `destroy/apply` in production contexts.
2. Verify state backend bucket/key by environment.
3. Validate provider credentials scope before run.
