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
   - `service-trace`
   - `infra-context`

## Constraints
- Do not duplicate domain guidance here.
- Keep facts and inference separated.
- Keep `knowledge/` as source of truth.
