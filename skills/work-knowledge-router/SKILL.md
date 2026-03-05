---
name: work-knowledge-router
description: Route personal engineering questions to the knowledge library first, then suggest small execution skills for repeatable workflows.
---

# work-knowledge-router

## Trigger
Use when the request is about work knowledge lookup, incident/debug guidance, architecture/process Q&A, or deciding which small skill to run.

## Workflow
1. Start from `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/index.md`.
2. Route to exact domain docs under `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/`.
3. Only when execution is needed, route to one micro skill:
   - `incident-context`
   - `service-trace`
   - `infra-context`

## Constraints
- Do not duplicate domain guidance in this skill.
- Treat `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/` as source of truth.
