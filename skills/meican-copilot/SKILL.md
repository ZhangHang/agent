---
name: meican-copilot
description: Digital work copilot for engineering work in sandbox, production(meican1), and prod(meican2). Focus on evidence-first debugging, delivery safety, and continuously maintained work knowledge.
---

# meican-copilot Workflow

## Scope
This skill is the long-term work-mode knowledge base and execution copilot.

## Hard Constraints
1. Use standard Markdown knowledge base only.
2. Do not rely on Obsidian-specific skills or syntax.
3. Keep conclusions evidence-based with concrete anchors.

## Mode Selection
- `debug`: incident/ticket investigation.
- `trace`: business call-chain tracing across provider/service/domain/downstream services.
- `answer`: platform/process Q&A.
- `advice`: architecture and implementation tradeoff guidance.
- `review`: risk-oriented change review.

If ambiguous: choose `debug` when failure signal exists, otherwise `advice`.

## Input Contract
Require:
- ticket id
- env (`sandbox` / `production` / `prod`)
- identifiers (`request_id`, `order_id`, `user_id`, etc.)
- absolute time window
- symptom and expected behavior

Lightweight trace mode (no ticket):
- service/repo
- method name
- expected downstream services

## Routing Order
1. Read `references/INDEX.md`.
2. Read domain `overview.md`.
3. Read corresponding `deep-dive` and topic playbooks.
4. Use scripts under `scripts/` for repeatable checks.
5. For chain tracing, run `scripts/context/trace_service_chain.sh` first.

## Reference Tree
- `references/architecture/*`
- `references/development/*`
- `references/operations/*`
- `references/infra/*`
- `references/capabilities/*`
- `references/principles/*`
- `references/templates/*`
- `references/legacy/*` (detailed historical source during migration)

## Infra Shortcut
- For ArgoCD image tag bump, use:
  - `scripts/infra/argocd_bump.sh`

## Project Inventory
- Full repository list and path/function mapping:
  - `references/architecture/project-inventory.md`

## Debug Execution Standard
1. Normalize problem statement and define hypotheses.
2. Confirm runtime path (EKS/legacy) and gateway path.
3. Query logs and traces.
4. Validate deploy/infra state (ArgoCD/Terraform).
5. Validate DB state with safe policy.
6. Confirm code path and middleware gates.
7. Produce evidence-backed conclusion with risk and validation plan.

## Trace Execution Standard
1. Locate entrypoint (`provider`/`handler`) by method name.
2. Expand into `service` and `domain` calls.
3. Confirm downstream RPC names via config and rpc client keys.
4. Distinguish facts and inferences in the chain output.
5. Return ordered chain with file anchors.

## Mode Output Emphasis
- `debug`: root cause, evidence chain, fix and validation.
- `trace`: ordered call chain and downstream boundaries.
- `answer`: direct answer first, then constraints and quick verification.
- `advice`: recommended option, tradeoffs, rollout and fallback.
- `review`: findings by severity, residual risk, missing validations.

## Service Interface Classes
- `admin service`: management-side APIs; metadata must carry operator/admin identity.
- `biz service`: to-C/BFF-facing APIs; metadata must carry end-user identity.
- `internal service`: service-to-service APIs for backend integration.
- During debug, always verify metadata requirement before concluding business failure.

## Git Conventions (Current Team Rule)
- Branch naming: keep `chore/*` for routine maintenance branches.
- Commit prefix: use `fix:` for CI tag/automation requirements in current campaign.

## Database Safety
- Non-production: read-only checks allowed.
- Production: provide SQL suggestions only; user executes manually.

## Output Contract
Return sections:
- Summary
- Scope and assumptions
- Findings
- Evidence anchors (files/config/logs/traces/db)
- Recommendation
- Risk and blast radius
- Validation plan
- Follow-up actions

## Guardrails
- Do not conclude root cause from one source.
- Separate facts and inference.
- Use one timezone with absolute timestamps.
- Keep legacy migration map updated when moving content out of `references/legacy/`.
