# Infra Deep Dive

## Scope
Detailed deployment and infra coupling model for app delivery.

## Preconditions
- Target app and target environment known.
- Relevant app repo and meican-cd repos accessible.

## Procedure
1. Verify app CI build/test path and environment tags.
2. Verify ArgoCD manifests for runtime topology.
3. Verify Terraform resources for dependent infra.
4. Verify network policies (sidecar/serviceentry/auth policy).
5. Verify observability resources (dashboard/alerts/service-monitor).

## Real Anchors
- ArgoCD:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- Terraform:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## Failure Modes
- Image/host/role mismatch between CI and Argo/Terraform.
- Environment-specific host suffix mismatch (`eks-fan` vs `eks-fan2`).

## Validation Checklist
- CI artifacts align with deploy manifests.
- Terraform state/key/environment align.
- Network policies reflect actual dependencies.

## Linked Scripts
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/argocd_context.sh`
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/terraform_context.sh`

## Change History
- 2026-02-24: initialized from consolidated infra playbooks.
