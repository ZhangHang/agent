# Operations Overview

## Scope
Incident handling, evidence collection, and high-frequency troubleshooting workflows.

## Entry Points
- Detailed flow: `deep-dive.md`
- Standard incident template: `incident-workflow.md`
- Log query: `log-query-playbook.md`
- Tracing: `tracing-playbook.md`
- DB checks: `db-query-policy.md`
- Known failures: `common-failure-patterns.md`

## Script Registry
### Active
- `scripts/collect-context.md`
- `scripts/trace-service-chain.md`

### Inactive (Parked)
- `scripts/search-logs.md`
- `scripts/trace-lookup.md`
- `scripts/db-checks.md`

Activation criteria for inactive scripts:
1. real usage >= 3 times in recent 30 days, and
2. output shape is stable enough for repeatable automation.
