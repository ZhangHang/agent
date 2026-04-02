# Common Failure Patterns

## dapi-be Gateway-First Failures
Typical middleware order before business logic:
1. response type
2. rate
3. authorization/sign
4. endpoint permission

Typical signals and first checks:
1. `429` / rate-limit
- `internal/net/grpcgateway/middleware/rate/rate.go`
- validate method type match, developer identity extraction, limiter key, env quota config.
2. `401` / sign verification
- `internal/net/grpcgateway/middleware/authorization/*`
- validate sign version, timestamp skew, nonce replay, signed payload bytes.
3. `403` / endpoint permission
- `internal/net/grpcgateway/middleware/endpoint/endpoint.go`
- validate endpoint mapping and developer/team permission grant.
4. `404` / route not matched
- validate proto HTTP annotation and runtime mapping metadata.

## Business Chain Anchors
- `planet` permission query chain:
  - proto route -> gateway register -> grpc register -> provider -> service.
- `dapi-be` subscription chain:
  - gateway metadata resolution -> middleware gates -> provider -> service.
- `planet/ops` verify dine-in chain:
  - `VerifyDineInOrder` -> identity prep -> `member`/`idmapping`/`id-card` (conditional `id-card-adapter`).

## Recovery Pattern
1. Identify failing gate or chain node.
2. Validate metadata/headers/config first.
3. Rerun with minimal reproducible payload.
4. Only then inspect deeper business service logic.

## Evidence Collection Order
1. Fix environment and absolute time window.
2. Capture request path + response code + response message.
3. Capture relevant headers (redact secrets).
4. Confirm fail point in middleware/registration/business layer.
5. Correlate with logs and traces.

## SFTools Iframe Integration Failures
场景：`planet-ops-frontend` 中通过 `@fe/planet-sf-tools` 打开的内部工具页面异常。

First checks:
1. Host 初始化参数
- 检查 `platform/env/token` 是否按预期传入：
  - `/Users/zhanghang/meican/planet-ops-frontend/src_v3/components/common/sf-tools/index.js`
2. targetRoute 可达性
- 检查 `targetRoute.page` 是否存在于 sftools routeMap：
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/router.js`
3. postMessage 握手
- 检查 iframe 是否发送 `loaded`，以及路由/close 事件是否回传：
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/main.js`
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/components/common/navigation/index.jsx`
4. API 前缀与权限
- 检查 sftools API 前缀（`/napi`、dev 下 `/api/sftools`）与网关规则是否匹配：
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/main.js`
- 检查权限 API 与业务 API 是否返回预期：
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/const/api.js`

Recovery pattern:
1. 先用最小 targetRoute（例如首页）验证渲染与握手。
2. 再验证权限接口（`listPermissions`）和一个具体工具接口。
3. 最后定位是 host 参数问题、iframe 路由问题还是 backend 权限/网关问题。
