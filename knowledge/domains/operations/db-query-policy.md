# DB Query Policy

## Scope
Production-safe DB investigation policy.

## Current State
- Direct DB automation is incomplete.
- Use human-in-the-loop execution for production SQL.

## Rules
1. Read-only by default.
2. In production, scripts output SQL suggestions only; user executes manually.
3. Every query must include purpose, expected shape, and risk level.
4. Avoid lock-heavy patterns.

## Query Response Format
- SQL:
- Reason:
- Expected Result Shape:
- Risk Level (`low`/`medium`/`high`):

## Safety Checklist
- Include explicit time window filters.
- Include tenant/client/user scoping where possible.
- Limit rows for exploratory checks.

## Linked Scripts
- `../../scripts/db/db_checks.sh`
