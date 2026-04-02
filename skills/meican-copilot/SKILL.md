---
name: meican-copilot
description: Thin router for personal Meican work knowledge. Route to knowledge docs first and micro skills second.
---

# meican-copilot (Thin Router)

## Role
This is a routing skill, not a large knowledge base.

## Route Order
1. Start from `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/index.md`.
2. Read exact target docs in `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/`.
3. Only when repeatable execution is needed, use one micro skill:
   - `incident-context`
   - `logclick-debug`
   - `debug-case-writer`
   - `knowledge-maintainer`
   - `service-trace`
   - `infra-context`

## Micro Skill Routing
- Use domain docs first for:
  - project lookup and code entry
  - platform / env / ArgoCD / Terraform relationships
  - logging / tracing / metric entry decisions
  - standards and templates
- Use `logclick-debug` when the task involves:
  - `logclick` SQL log queries
  - gRPC request/reply debugging from logs
  - extracting `x-otel-trace-id`
  - using `--json` with `jq`
  - matching log payloads against proto definitions
- Use `debug-case-writer` when the task is to turn one real debug round into a reusable markdown case with commands, evidence, facts, inference, and code anchors.
- Use `knowledge-maintainer` when the task is to update shared knowledge after real work, including domain docs, thin skills, and changelog entries.

## Constraints
- Do not duplicate domain guidance here.
- Keep facts and inference separated.
- Keep `knowledge/` as source of truth.
