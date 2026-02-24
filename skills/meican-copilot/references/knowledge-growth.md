# Knowledge Growth

## Purpose
Keep this skill as a long-lived "digital work me" by continuously ingesting work docs.

## What to Add Over Time
- System runbooks and troubleshooting playbooks
- Service ownership map and escalation paths
- Common incident patterns and known fixes
- Environment-specific operational commands
- API and schema references for key business domains
- Postmortems and decision records

## How to Add New Knowledge
1. Add new file under `references/` with a focused topic.
2. Keep each file small and specific.
3. Add a short "When to use" sentence at top.
4. Update `SKILL.md` references list only when the topic is broadly reusable.

## Deep Learning Protocol For New Repositories
When user provides a new project path:
1. Record path under the right reference file (code/deploy/infra/proto).
2. Inspect at least:
- top-level layout
- `README.md`
- build/test/deploy files (`Makefile`, CI config, `docker/`, `argo*`, `config/`)
- dependency and interface files (`go.mod`, proto refs, gateway config)
3. Extract:
- project purpose
- runtime model
- integration points
- common failure/debug entry points
4. Store these findings in reference docs before using them in advice.

## File Pattern
Use:
- `references/<topic>.md`
- Start with:
  - `Purpose`
  - `When to use`
  - `Key commands or checks`
  - `Known pitfalls`

## Quality Bar
- Prefer concrete commands and examples.
- Separate facts vs assumptions.
- Include environment scope (`sandbox`/`meican1`/`meican2`) in notes.
