# Log Query Playbook (Detailed)

## Scope
Frontend and API usage for LogClick-based log investigation.

## Preconditions
- Access to `logclick-fe` and target environment session.
- Absolute time range and primary identifiers.

## Step-by-step Procedure
1. Confirm request path rewrite model.
2. Choose data source family (ClickHouse or S3 logs).
3. Build query payload with correct schema.
4. Execute query and inspect response shape.
5. Correlate with service traces and app logs.

## Real Examples
- Frontend API wrapper:
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe/src/services/logclick-api.ts`
- Rewrite config:
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe/next.config.ts`
- ClickHouse endpoints:
  - `GET /v1/ck/apps`
  - `GET /v1/ck/fields`
  - `POST /v1/ck/search`
- S3 endpoints:
  - `GET /v1/s3/tree`
  - `POST /v2/s3/search`

## Failure Modes + Recovery
- No data because of wrong time range field:
  - ClickHouse uses `query.range`, S3 uses `query.timeRange`.
- Session/auth redirect loops:
  - verify cookie/session middleware and `/api/me` result.
- Timeout or truncated results:
  - check UI timeout and query limit settings.

## Validation Checklist
- Request path/rewrite confirmed.
- Query schema confirmed.
- Response error shape parsed (`RpcStatus.message`/`message`).
- At least one correlated trace/log anchor captured.

## Linked Scripts
- `../../scripts/log/search_logs.sh`
- `../../scripts/trace/trace_lookup.sh`

## Change History
- 2026-02-24: migrated from legacy `logclick-fe-api-playbook.md`.

## Script Usage
Primary helper script:
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/log/search_logs.sh`

Example: list apps
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/log/search_logs.sh   --mode list-apps --env sandbox --cookie-file /path/to/cookie.txt
```

Example: ClickHouse search
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/log/search_logs.sh   --mode ck --env sandbox   --from 2026-02-24T10:00:00+08:00 --to 2026-02-24T11:00:00+08:00   --keyword "authorization verify err" --filter level=ERROR --limit 200   --cookie-file /path/to/cookie.txt
```

Example: S3 search
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/log/search_logs.sh   --mode s3 --env prod   --from 2026-02-24T10:00:00+08:00 --to 2026-02-24T11:00:00+08:00   --domain app-nation-client --namespace app-nation-client --name client   --filter request_id=abc123 --cookie-file /path/to/cookie.txt
```

## Notes
- The script calls the same endpoints used by `logclick-fe`:
  - `/v1/ck/apps`, `/v1/ck/fields`, `/v1/ck/search`, `/v1/ck/stream-search`
  - `/v1/s3/tree`, `/v2/s3/search`
- Default base URL is `https://logclick-nw.planetmeican.com/api`; override with `--base-url` when needed.

