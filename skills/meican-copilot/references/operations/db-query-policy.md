# DB Query Policy

## Scope
Production-safe DB investigation policy.

## Rules
1. Read-only by default.
2. In production, script outputs SQL suggestions; user executes manually.
3. Every query must include purpose, expected shape, and risk level.

## Query Response Format
- SQL:
- Reason:
- Expected Result Shape:
- Risk Level (`low`/`medium`/`high`):

## Linked Scripts
- `../../scripts/db/db_checks.sh`
