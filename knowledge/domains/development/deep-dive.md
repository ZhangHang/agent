# Development Deep Dive

## Scope
Detailed implementation practices for Go microservices and grpc-gateway projects.

## Preconditions
- Confirm service type: gRPC only / gRPC + gateway / HTTP + internal gRPC.
- Confirm target proto repository strategy.

## Procedure
1. Bootstrap service skeleton via app CLI (`/Users/zhanghang/go/bin/app new`).
2. Define config layout (`dev/sandbox/prod/autotest`).
3. Define API contract in proto with compatibility checks.
4. Implement provider/service/domain layering.
5. Register gRPC and (if needed) gateway handlers.
6. Add tests and CI service dependencies.
7. Add deployment manifests and infra impacts.

## Real Anchors
- Common structure:
  - `cmd/`
  - `config/{sandbox,dev,prod,autotest}`
  - `internal/domain`
  - `internal/net`
  - `internal/service`
- Required dependencies:
  - `go.planetmeican.com/easygo/gf/v2`
  - `github.com/gogf/gf/v2`
  - `github.com/samber/lo`

## Failure Modes
- Contract drift (proto vs implementation): regenerate and verify registry links.
- Missing gateway registration: verify `Register*HandlerFromEndpoint` paths.
- Business logic leaking into transport layer: move logic down to service/domain.

## Validation Checklist
- API contract verified.
- Interceptors/authorization impact checked.
- Provider/service/domain boundaries respected.
- CI test dependencies consistent with runtime dependencies.
- Deploy target repos identified (ArgoCD/Terraform).

## Linked Scripts
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/collect_context.sh`
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/trace_service_chain.sh`

## Client Tool Integration (Planet + Ops + SFTools)
- Planet contract (`ListPermissions.data.client_tools`):
  - `client_id = 0`: 全客户可见。
  - `client_id > 0`: 仅对应客户可见。
  - 空 `client_ids` 配置在后端转换为一条 `client_id = 0` 记录。
- Config (`client_tools.<PERMISSION>`):
  - `name`
  - `client_ids` (optional)
  - `sftools_entry` / `iframe_url` (至少一个；都为空则忽略)
- Ops integration:
  - `src/app.js` 保留并透传 `clientTools`。
  - `src/routes/index.js` 注入 `clientTools` 给 `src_v3/App.js`。
  - `client-next` 设置页按 `(tool.clientId === 0 || tool.clientId === currentClientId)` 过滤展示。
  - `sftools_entry` 走 `SFTools targetRoute.page`，`iframe_url` 走纯 iframe 页面，不注入参数。
- SFTools page contract:
  - `page = client-tool-opentime`
  - `params.clientId` 必传，`params.title` 可选。
  - 页面流程：先选 mealplan，再展示 `openTimeType` + 周视图时间可视化（只读）。
- Rollout checklist:
  - 配置权限：`PERMISSION_DEV_INTERNAL_USER`
  - 首批客户：`client_id = 8`
  - 验证入口仅出现在 `client-next` 设置页
- Rollback switch:
  - 删除或注释对应 `client_tools.<PERMISSION>` 配置即可下线入口。
  - 如需更严格回滚，可同时移除用户权限授权。

## Change History
- 2026-02-24: initialized from backend standards and gateway playbooks.
- 2026-02-26: expanded backend delivery flow and easygo/gf test details.
- 2026-03-05: added client tool integration contract and rollout notes for Planet + Ops + SFTools.
