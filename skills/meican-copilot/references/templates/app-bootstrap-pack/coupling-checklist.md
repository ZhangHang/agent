# Coupling Checklist

1. Terraform `ecr.tf` repo name matches rollout image repo.
2. Terraform `route53.tf` host matches ingress host.
3. `rollout.yaml` container ports match `service.yaml` target ports.
4. If `service-account.yaml` exists:
- IAM role ARN exists in terraform.
- namespace/serviceaccount name in IAM trust policy matches runtime.
5. `webapp.yaml` group/project matches rollout annotations/env.
6. Istio service names in `istio-virtual-service.yaml` match services in `service.yaml`.
7. Environment mapping is correct:
- `sandbox` -> `argocd-sandbox` + `terraform-sandbox`
- `production` -> `argocd-production` + `terraform-production`
- `prod` -> `argocd-prod` + `terraform-prod`
