# Scripts Contract

## Scope
Scripts under this folder are execution helpers for meican-copilot workflows.

## Safety Rules
1. Read-only by default.
2. Production DB mode prints SQL suggestions; does not execute mutating SQL.
3. Explicitly pass environment and time range.

## Common Parameters
- `--env sandbox|production|prod`
- `--from <ISO-8601>`
- `--to <ISO-8601>`
- `--service <service-name>`
- `--id <request_id|user_id|order_id>`

## Script Index
- `context/collect_context.sh`: normalize debug context header.
- `context/trace_service_chain.sh`: locate call-chain anchors by `service + method`.
- `log/search_logs.sh`: real LogClick API query wrapper.
- `trace/trace_lookup.sh`: trace lookup template.
- `db/db_checks.sh`: production-safe SQL suggestion wrapper.
- `infra/argocd_context.sh`: locate ArgoCD app manifests by env/app.
- `infra/terraform_context.sh`: locate Terraform app folders by env/app.
- `infra/argocd_bump.sh`: wrapper for ArgoCD rollout image tag bump via local bump script.

## log/search_logs.sh Modes
- `--mode list-apps`: list ClickHouse apps.
- `--mode list-fields --from --to`: list available fields.
- `--mode ck` / `--mode ck-stream`: query ClickHouse logs.
- `--mode list-tree`: list S3 domain tree.
- `--mode s3`: query S3 logs.

Auth support:
- `--cookie '<cookie header value>'`
- or `--cookie-file <path>`

Base URL:
- default: `https://logclick-nw.planetmeican.com/api`
- override: `--base-url <url>`

Examples:
```bash
# ClickHouse query
./scripts/log/search_logs.sh \
  --mode ck --env sandbox \
  --from 2026-02-24T10:00:00+08:00 --to 2026-02-24T10:30:00+08:00 \
  --keyword "authorization verify err" --filter level=ERROR --limit 200 \
  --cookie-file /path/to/cookie.txt

# S3 query
./scripts/log/search_logs.sh \
  --mode s3 --env prod \
  --from 2026-02-24T10:00:00+08:00 --to 2026-02-24T10:30:00+08:00 \
  --domain app-nation-client --namespace app-nation-client --name client \
  --filter request_id=abc123 --cookie-file /path/to/cookie.txt
```

ArgoCD bump (meican2):
```bash
./scripts/infra/argocd_bump.sh --env meican2 --server planet --version v0.88.2
```

Trace service chain:
```bash
./scripts/context/trace_service_chain.sh \
  --service planet/ops \
  --method VerifyDineInOrder
```
