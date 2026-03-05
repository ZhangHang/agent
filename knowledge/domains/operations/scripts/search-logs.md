# search_logs.sh Contract

## Purpose
封装 LogClick API 查询（ck/s3/list），用于日志检索。

## Status
inactive

## Activation Criteria
1. recent 30 days 内真实使用次数 >= 3。
2. 环境路由策略固定后再恢复为默认路径。

## Required Args
- `--mode <ck|ck-stream|s3|list-apps|list-fields|list-tree>`
- `--env <sandbox|production|prod>`
- query modes require `--from --to`

## Safety Constraints
- read-only HTTP query wrapper
- requires explicit auth cookie

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/log/search_logs.sh \
  --mode ck --env sandbox \
  --from 2026-03-05T09:00:00+08:00 --to 2026-03-05T10:00:00+08:00 \
  --filter level=ERROR --cookie-file /path/to/cookie.txt
```

## Expected Output Shape
JSON output from LogClick API (`jq` pretty-printed).
