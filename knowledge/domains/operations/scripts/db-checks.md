# db_checks.sh Contract

## Purpose
生产环境仅输出 SQL 建议；非生产目前为模板占位。

## Status
inactive

## Activation Criteria
1. non-prod readonly query command integrated.
2. output contract stabilized and documented.

## Required Args
- `--env <sandbox|production|prod>`
- `--sql-file <path>`

## Safety Constraints
- production: never execute SQL
- non-production: currently template-only

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/db/db_checks.sh \
  --env prod --sql-file /tmp/check.sql
```

## Expected Output Shape
- production/prod: safe-mode notice + SQL content
- sandbox: template output + TODO notice
