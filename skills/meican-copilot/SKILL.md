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

## Routing Order
1. Read `references/INDEX.md`.
2. Read domain `overview.md`.
3. Read corresponding `deep-dive` and topic playbooks.
4. Use scripts under `scripts/` for repeatable checks.

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

## Debug Execution Standard
1. Normalize problem statement and define hypotheses.
2. Confirm runtime path (EKS/legacy) and gateway path.
3. Query logs and traces.
4. Validate deploy/infra state (ArgoCD/Terraform).
5. Validate DB state with safe policy.
6. Confirm code path and middleware gates.
7. Produce evidence-backed conclusion with risk and validation plan.

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
