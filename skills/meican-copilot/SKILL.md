---
name: meican-copilot
description: Digital work copilot for day-to-day engineering in sandbox, production(meican1), and prod(meican2). Use for incident debugging, ticket investigation, technical Q&A, architecture advice, implementation risk review, and ongoing work-document knowledge accumulation. Enforce evidence-first conclusions and production-safe database practices.
---

# Work Copilot Workflow

## Scope
This skill has two pillars:
- Skill-focused workflows (`debug`, `answer`, `advice`, `review`)
- General work knowledge accumulation from docs added over time

## Mode Selection
Select one mode first:
- `debug`: investigate incident or user ticket with logs/traces/db/code.
- `answer`: answer "how/why/what" questions based on known platform context.
- `advice`: give architecture/implementation recommendations with tradeoffs.
- `review`: evaluate a proposed change for risk, compatibility, and rollout safety.

If request is ambiguous, choose `debug` when there is a concrete failure signal; otherwise choose `advice`.

## Input Contract
Require:
- ticket id
- env (`sandbox` / `production` / `prod`)
- user identifiers (user_id/email/phone/order_id/request_id)
- time window
- symptom and expected behavior

Ask for missing critical fields before deep investigation.

## Environment Model
- `sandbox`: AWS account for testing/developing
- `production` (`meican1`): AWS account with existing production services
- `prod` (`meican2`): AWS account with new production services
- `production`/`prod` may use tunnel access for some databases

Read these references before execution:
- `references/environments.md`
- `references/platform-architecture.md`
- `references/database-policy.md`
- `references/ticket-template.md`
- `references/work-modes.md`
- `references/knowledge-growth.md`
- `references/codebase-roots.md`
- `references/deploy-infra-roots.md`
- `references/backend-project-standards.md`
- `references/proto-strategy.md`
- `references/grpc-gateway-playbook.md`
- `references/engineering-delivery-playbook.md`
- `references/business-chains.md`
- `references/logclick-fe-api-playbook.md`
- `references/dapi-be-gateway-failure-playbook.md`
- `references/app-bootstrap-terraform-argocd-playbook.md`

## Deep-Dive Rule
- Do not answer repository-specific questions from memory only.
- Before conclusions, inspect target repository files directly (layout, config, CI, deployment, key runtime code path).
- For infra/deploy questions, inspect ArgoCD/Terraform roots first, then service repo.
- Always include three concrete anchors in analysis:
  - file-structure anchor (`cmd`, `internal/net`, `internal/service`, `internal/domain`)
  - business-logic anchor (provider -> service -> domain call chain)
  - contract anchor (proto/http annotations, gateway registration, interceptors)

## Execution Steps
Follow `references/work-modes.md` for mode-specific steps.

For `debug` mode:
1. Normalize problem statement and define 2-3 hypotheses.
2. Determine traffic path: external (`nginx/openresty` -> `kong` -> HTTP/gRPC service) or legacy (`route53` -> `openresty` -> ECS/Lambda).
3. Search logs by identifiers and time window.
4. Find traces and map cross-service path.
5. Verify runtime/deploy state via EKS and ArgoCD context (if data is available).
6. Check database state and recent mutations.
7. Verify behavior in code paths (Go microservices + Java `fan` when relevant).
8. Conclude with confidence and explicit evidence.

## Database Mode
- For non-production or when direct DB access is available: execute read-only checks.
- For production when direct execution is restricted: provide:
  - SQL statement(s)
  - reason for each query
  - expected shape of result
  - risk level (`low`/`medium`/`high`)
- Then wait for user to run queries and return output before concluding DB findings.

## Output Contract
Return sections:
- Summary
- Scope and assumptions
- Findings
- Evidence (logs/traces/db/code/config)
- Recommendation
- Risk and blast radius
- Validation plan
- Follow-up actions

## Guardrails
- Do not claim root cause without at least two evidence sources.
- Mark uncertain conclusions explicitly.
- Use absolute timestamps and one timezone.
- Prefer read-only DB queries by default.
- If APIs/CLI are missing, produce a manual checklist and continue with available evidence.
- Separate facts from inference explicitly.
