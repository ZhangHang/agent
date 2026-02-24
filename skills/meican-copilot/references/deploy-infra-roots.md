# Deploy and Infra Roots

## ArgoCD Repositories
- `sandbox` EKS deploy:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
- `production` (`meican1`) EKS deploy:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
- `prod` (`meican2`) EKS deploy:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`

Notes from repo docs:
- `argocd-prod` maps to new account `meican2` and `eks-fan2`.
- `argocd-production` is production ArgoCD for legacy production account (`meican1`).
- `argocd-sandbox` is sandbox ArgoCD config root.

## Terraform Repositories
- Terraform base root:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd`
- Environment roots:
  - `sandbox` -> `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - `production` (`meican1`) -> `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - `prod` (`meican2`) -> `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## Investigation Use Pattern
1. Determine target environment.
2. Check ArgoCD repo for app/deploy state and manifests.
3. Check Terraform repo for infra dependencies and resource definitions.
4. Correlate with service repo code/config.
