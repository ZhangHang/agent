# collect_context.sh Contract

## Purpose
规范 incident/debug 输入上下文，输出统一 header，便于后续证据收集。

## Status
active

## Required Args
- `--env <sandbox|production|prod>`
- `--service <name>`

## Safety Constraints
- read-only
- no external mutation

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/collect_context.sh \
  --env production --service planet/ops --id abc123 \
  --from 2026-03-05T09:00:00+08:00 --to 2026-03-05T10:00:00+08:00
```

## Expected Output Shape
- `env=<value>`
- `service=<value>`
- `id=<value|N/A>`
- `from=<value|N/A>`
- `to=<value|N/A>`
