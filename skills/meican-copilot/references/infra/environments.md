# Environments

## Canonical Names
- `sandbox`
- `production` (`meican1`)
- `prod` (`meican2`)

## Deploy Roots
- ArgoCD:
  - sandbox: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - production: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - prod: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- Terraform:
  - sandbox: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - production: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - prod: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## Connectivity Notes
- `production` and `prod` may require tunnel for selected DBs.
