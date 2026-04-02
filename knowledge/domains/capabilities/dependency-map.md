# Dependency Map

## Cross-service Calls
- `dapi-be` -> `nation-client/client` (selected internal grpc calls).
- `planet` -> internal permission/role dependencies.
- `planet/ops` verify flow -> `member` + `id-card` + `idmapping` (+ conditional `id-card-adapter`).
- multiple services -> infra dependencies (redis/rds/pulsar/aws APIs).

## Chain A: `planet` Permission Query
### Entry
- proto route in `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto/v1/planet_service.proto`
- method: `ListPermissions`

### Runtime Path
1. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/cmd/main.go`
2. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpcgateway/register.go`
3. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpc/register.go`
4. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpc/providerv1/planet.go`
5. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/service/permission.go`

## Chain B: `dapi-be` Subscription v4
### Runtime Path
1. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/cmd/main.go`
2. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/service/proto/proto.go`
3. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/register.go`
4. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpc/register.go`
5. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpc/provider/subscription/v4.go`
6. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/service/subscription/subscription_v4.go`

## Chain C: Dine-in Verify (`planet/ops`)
### Trigger
- gRPC `InternalService.VerifyDineInOrder`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/net/grpc/provider/internal.go:21`

### Call Sequence
1. `provider` -> `service.DineIn.UnionVerify`
2. `PrepareIdentity` -> `idmapping.GetCombineID` + `member.MustGetClientMember`
3. card path -> `id-card.GetIDCardDetails` / `id-card.GetElectricCardIdentity`
4. verify stage -> `member.IsAllowOrder`
5. conditional adapter card source -> `id-card-adapter.ListIdentities`

### Key Anchors
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/service/dinein.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/member/member.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/idmapping/idmapping.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/id_card/id_card.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card/internal/application/card/impl_card/adapter_card/adapter_card.go`

## Maintenance Rule
Each new chain entry must include:
1. trigger path
2. call sequence
3. dependency boundary
4. failure hotspots

## Chain D: Planet Ops Frontend -> SFTools (Iframe SDK)
### Trigger
- DAPI 页面进入内部工具或开发团队相关功能时触发。
- 入口锚点：
  - `/Users/zhanghang/meican/planet-ops-frontend/src/components/DAPI/v3.tsx`
  - `/Users/zhanghang/meican/planet-ops-frontend/src/components/DAPI/DevelopmentTeamDetail/v3.tsx`

### Call Sequence
1. `planet-ops-frontend` 渲染 `SFTools` wrapper 组件：
   - `/Users/zhanghang/meican/planet-ops-frontend/src_v3/components/common/sf-tools/index.js`
2. wrapper 初始化 `@fe/planet-sf-tools`：
   - 传入 `platform/env/token`
   - 调用 `render(targetRoute)`
3. SDK 加载 `web-sdk-raven` 的 `sftools` 页面实现：
   - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/main.js`
   - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/router.js`
4. `sftools` 页面通过 `postMessage` 与父页面同步路由/close 事件。
5. `sftools` 调用 planet backend API：
   - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/const/api.js` (`/v1/planet/*`, `/v1/developer-team/*` 等)

### Dependency Boundary
- Host 页面：`planet-ops-frontend`
- Embedded 页面实现：`web-sdk-raven` (仅 sftools 范围)
- Backend：planet 相关 API

### Failure Hotspots
1. token/header 未正确注入导致鉴权失败。
2. `targetRoute.page` 与 routeMap 不一致导致落不到目标工具页。
3. host 与 iframe 通信异常（`postMessage` 事件未收到或 close 事件未处理）。
4. 环境代理前缀不一致（如 `/napi`、`/api/sftools`）导致接口 404/403。
