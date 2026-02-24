# Infra Deep Dive

## Scope
Detailed deployment and infra coupling model for app delivery.

## Preconditions
- Target app and target environment known.
- Relevant app repo and meican-cd repos accessible.

## Step-by-step Procedure
1. Verify app CI build/test path and environment tags.
2. Verify ArgoCD manifests for runtime topology.
3. Verify Terraform resources for dependent infra.
4. Verify network policies (sidecar/serviceentry/auth policy).
5. Verify observability resources (dashboard/alerts/service-monitor).

## Real Examples
- ArgoCD:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- Terraform:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## Failure Modes + Recovery
- Image/host/role mismatch between CI and Argo/Terraform:
  - run coupling checklist from templates.
- Environment-specific host suffix mismatch (`eks-fan` vs `eks-fan2`):
  - verify env manifest set before rollout.

## Validation Checklist
- CI artifacts align with deploy manifests.
- Terraform state/key/environment align.
- Network policies reflect actual dependencies.

## Linked Scripts
- `../../scripts/infra/argocd_context.sh`
- `../../scripts/infra/terraform_context.sh`

## Change History
- 2026-02-24: initialized from consolidated infra playbooks.
