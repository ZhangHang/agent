---
name: logclick-debug
description: Use logclick query run for SQL-first log debugging, especially gRPC request/reply inspection with trace-id pivots and jq.
---

# logclick-debug

## Trigger
Use when the task is to inspect logs with `logclick query run`, especially for:
- gRPC request/reply debugging
- extracting `x-otel-trace-id` for human follow-up in tracing tools
- using `--json` with `jq`
- matching log `req` / `reply` payloads to proto definitions

## Workflow
1. Read `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/operations/log-query-playbook.md`.
2. If the task is about `planet.ops.v1.InternalService/VerifyDineInOrder`, read `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/operations/verify-dine-in-order-debug.md`.
3. If the task is about `dapi-be` signature verification failures, read `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/operations/dapi-be-signature-debug.md`.
4. If the task needs service-boundary understanding, read:
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/architecture/topology-from-domain-dirs.md`
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/development/proto-family-map.md`
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/development/code-distillation-method.md`
5. Use `logclick query run` as the main entrypoint.
6. Prefer SQL-first queries.
7. Prefer `--json` when the next step is field extraction, payload comparison, or trace-id extraction.
8. For gRPC debugging, prefer these fields first:
   - `time`
   - `app`
   - `x-otel-trace-id`
   - `method`
   - `req`
   - `reply`
9. If the task is card-based dine-in verification, start from the `ops` entry with the card code, then pivot by `x-otel-trace-id` into `id-card`, `member`, `idmapping`, and `client`.
10. For `dapi-be` signature failures, prefer:
   - round 1: fetch `dapi-be` logs with `raw` into a local JSON file
   - round 2: use local `jq` / `rg` to find `developer-id`, `DeveloperRn`, signature errors, and one concrete failed sample
   - do not rely on SQL `WHERE raw ...` filters first
11. Prefer a 1-2 round query plan instead of many tiny queries:
   - round 1: fetch the entry logs and collect `x-otel-trace-id`
   - round 2: fetch the full cross-app trace with `raw`
   - save JSON locally and analyze from the local file with `jq`, instead of re-querying the same trace repeatedly
12. Before guessing downstream services, check whether the relevant Go service exposes them directly under `internal/domain/*`.
13. If the request path clearly crosses frontend/BFF/SDK repos, also consult:
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/development/frontend-bff-sdk-patterns.md`

## Minimal Defaults
- Start with a short time window, then widen it if needed.
- Keep `LIMIT` in the SQL body. Put `SINCE` and `UNTIL` at the end.
- Treat `x-otel-trace-id` as the handoff field for human trace follow-up.
- Proto lookup order:
  1. `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`
  2. `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`
  3. then the repo-specific proto family such as `planet-proto`, `project-proto`, `developer/proto`, `idmapping-proto`
- For deeper analysis, prefer:
  - `logclick query run --json ... > /tmp/<case>.json`
  - `jq` against the saved file
  - only re-query when the local file is missing a field or the time window was wrong

## Output Style
When using this skill:
1. Start with one recommended query.
2. Then provide one or two directly copyable commands.
3. Then suggest the next step:
   - inspect trace id
   - search proto
   - widen/narrow time range
   - pin to one method
