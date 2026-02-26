# Environments

## Canonical Names
- `sandbox`
- `production` (`meican1`)
- `prod` (`meican2`)

## Deploy Roots
- ArgoCD:
  - sandbox: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - production (`meican1`): `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - prod (`meican2`): `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- Terraform:
  - sandbox: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - production: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - prod: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## Connectivity Notes
- `production` and `prod` may require tunnel for selected DBs.
- `argocd-production` is legacy production account root (`meican1`).
- `argocd-prod` maps to new production account root (`meican2` / `eks-fan2`).

## Investigation Rules
1. Always state environment first in findings.
2. Do not mix evidence from different environments in one conclusion.
