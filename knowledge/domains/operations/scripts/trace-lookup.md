# trace_lookup.sh Contract

## Purpose
trace-id 查询占位脚本模板。

## Status
inactive

## Activation Criteria
1. tracing backend query command finalized.
2. script removes TODO template behavior.

## Required Args
- `--env <sandbox|production|prod>`
- `--trace-id <id>`

## Safety Constraints
- no mutation
- currently template-only

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/trace/trace_lookup.sh \
  --env production --trace-id abc123
```

## Expected Output Shape
Current: template echo + TODO notice.
Target after activation: structured trace lookup result.
