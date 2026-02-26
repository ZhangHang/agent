# Architecture Deep Dive

## Scope
Detailed model of platform runtime, environment mapping, and investigation pathing.

## Preconditions
- Know target environment (`sandbox`, `production`, `prod`).
- Know request type (internal gRPC vs external HTTP).

## Step-by-step Procedure
1. Identify runtime path (EKS / ECS / Lambda).
2. Identify ingress and gateway components involved.
3. Map service dependency edges (internal gRPC and external egress).
4. Validate deployment source in ArgoCD and infra source in Terraform.
5. Confirm observability hooks (log/tracing/metrics).

## Codebase Roots and Discovery
- Primary roots:
  - `/Users/zhanghang/go/src/go.planetmeican.com`
  - `/Users/zhanghang/meican`
- If input contains `go.planetmiecan.com`, treat it as likely typo and confirm `go.planetmeican.com`.

Quick discovery commands:
```bash
ls -la /Users/zhanghang/go/src/go.planetmeican.com
ls -la /Users/zhanghang/meican
rg --files /Users/zhanghang/go/src/go.planetmeican.com | head -n 50
rg --files /Users/zhanghang/meican | head -n 50
```

## Real Examples
- ArgoCD roots:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- Terraform roots:
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`
- Base-image root:
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/base-images`

## Failure Modes + Recovery
- Mixed-environment evidence:
  - Recover by splitting evidence collection per environment.
- Wrong route assumption (EKS vs legacy):
  - Recover by checking actual ingress and hostname path first.

## Validation Checklist
- Environment explicitly stated.
- Runtime path explicitly stated.
- ArgoCD + Terraform source paths confirmed.
- Evidence includes at least logs/traces/config anchors.

## Linked Scripts
- `../../scripts/context/collect_context.sh`

## Change History
- 2026-02-24: initial deep-dive from consolidated platform docs.
- 2026-02-26: merged legacy `codebase-roots.md`, `platform-architecture.md`, and `deploy-infra-roots.md` details.
