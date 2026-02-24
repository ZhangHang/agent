# Database Policy

## Current State
- Direct DB automation is not fully available yet.
- Workflow currently supports human-in-the-loop DB verification.

## Operating Rules
- Default to read-only SQL.
- Never propose write SQL unless explicitly requested.
- For production contexts, provide query advice for user execution.

## Production SQL Response Format
When user must run SQL manually, respond with:

1. Query
```sql
-- SQL here
```
2. Reason
- Why this query is needed.
3. Expected Result Shape
- Which columns/rows matter for conclusion.
4. Risk
- `low` / `medium` / `high`.

## Safety Checklist
- Include explicit time window filters.
- Include tenant/client/user scoping where possible.
- Limit rows for exploratory checks.
- Avoid lock-heavy patterns.
