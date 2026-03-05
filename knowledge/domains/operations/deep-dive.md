# Operations Deep Dive

## Scope
Comprehensive incident workflow from signal to validated conclusion.

## Preconditions
- Ticket ID (optional for quick trace/debug).
- Environment.
- Time range.
- At least one business identifier.

## Procedure
1. Normalize symptom and expected behavior.
2. Map traffic path and involved services.
3. Search logs by identifiers/time window.
4. Trace cross-service span path.
5. Check deploy/runtime context for target env.
6. Validate database state with read-only policy.
7. Confirm code path and middleware gates.
8. Conclude with evidence and confidence level.

## Real Anchors
- `dapi-be` gateway-first triage in `common-failure-patterns.md`.
- `logclick` query path in `log-query-playbook.md`.

## Failure Modes
- Evidence mismatch across envs: split data by env and rerun.
- Single-source conclusion risk: require at least two independent evidence sources.

## Validation Checklist
- Facts vs inference separated.
- At least logs/traces/config anchors attached.
- Risk and blast radius documented.

## Linked Scripts
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/collect_context.sh`
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/trace_service_chain.sh`
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/log/search_logs.sh` (inactive)
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/trace/trace_lookup.sh` (inactive)
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/db/db_checks.sh` (inactive)

## Change History
- 2026-02-24: initialized from existing work-modes and legacy incident playbooks.
- 2026-03-05: migrated to `knowledge/` source-of-truth and marked inactive scripts.
