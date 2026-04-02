# 从 `internal/domain` 推断服务拓扑

## 用途
很多公司 Go 服务的拓扑关系，不需要先看文档图，也不需要先跑 trace。

一个更快的方法是：
- 先看 `internal/domain` 目录名
- 再看 `boot.go` 或 domain 初始化
- 再看单个 `domain/<name>/*.go` 里到底连的是哪个 service / proto / rpc client

这个页面把这套方法固定下来。

## 核心规则

### 规则 1：`internal/domain/<name>` 往往就是远端服务或依赖域
在很多项目里，`internal/domain` 不是“内部业务模块”，而是：
- 一个远端 gRPC client
- 一个跨服务依赖
- 一个外部域的封装 client

如果目录名是：
- `member`
- `client`
- `id_card`
- `idmapping`
- `ops`
- `checkout`

那它通常真的对应：
- `member` 服务
- `client` 服务
- `id-card` 服务
- `idmapping` 服务
- `ops` 服务
- `checkout` 服务

### 规则 2：先看 `boot.go`
`boot.go` 经常会暴露“这个服务启动时挂了哪些外部依赖”。

### 规则 3：再看 domain 实现里 `rpc.New(\"...\")`
如果文件里出现：

```go
rpc.New("member", ...)
rpc.New("client", ...)
grpc.New("ops", ...)
```

那几乎就是直接的下游拓扑锚点。

### 规则 4：再看导入的 proto
如果 domain 文件直接 import：
- `api-center/protobufs/client-internal/member/...`
- `nation-client/client-proto/...`
- `planet/ops/v1`

那就能继续确认：
- 调的是哪个仓的 proto
- 是新 proto 还是旧 proto
- 调的是 internal service 还是 admin service

## 已确认的代表性例子

### `planet/ops`
代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/boot.go`

`boot.go` 明确初始化了：
- `avatar`
- `checkout`
- `client`
- `clientv2`
- `distro`
- `id_card`
- `idmapping`
- `meican_staff`
- `member`
- `order20`
- `user`
- `user_order_system`

这已经能直接读出：
- `ops` 是业务编排层
- 下游横跨 `member / client / clientv2 / id-card / idmapping / order20`

进一步看实现：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/member/member.go`
  - `rpc.New("member", ...)`
  - proto 来自 `api-center/protobufs/client-internal/member/v1/...`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/client/client.go`
  - `rpc.New("client", ...)`
  - 仍使用 `nation-client/client-proto/...`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/id_card/id_card.go`
  - `rpc.New("id_card", ...)`
  - proto 来自 `api-center/protobufs/nation-client/id-card/v2`

结论：
- `ops` 的 topology 可以先从 `internal/domain` 直接读出，再用 trace 验证

### `planet/planet`
代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/domain/boot.go`

已确认直接初始化：
- `area`
- `casbin`
- `client`
- `member`
- `user`
- `id_card_adapter`
- `ops`
- `workflow`

结论：
- `planet` 是大聚合器
- `internal/domain` 目录名能直接暴露它编排的外围服务边界

### `developer/dapi-be`
代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/domain/boot.go`

已确认直接初始化：
- `benefits`
- `checkout`
- `client`
- `id_card`
- `id_code`
- `idmapping`
- `kiwi_notify`
- `meal_point`
- `member`
- `merchant`
- `ops`
- `payment_gateway`
- `photocut`
- `profiles`
- `sso`
- `subsidy`
- `user`
- `user_order_system`

再看：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/domain/ops/ops.go`
  - `grpc.New("ops", ...)`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/domain/member/member.go`
  - `grpc.New("member", ...)`
  - proto 来自 `api-center/protobufs/client-internal/member/v1/...`

结论：
- `dapi-be` 是 gateway/adapter，但 domain 目录同样能直接暴露其下游拓扑

### `nation-client/id-card`
目录锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card/internal/domain`

已确认 domain 目录有：
- `fan`
- `id_card_adapter`
- `idmapping`
- `meican_id_code`
- `member`
- `opslog`
- `face_api`

再看：
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card/internal/domain/member/member.go`
  - 直接调用 `client-internal/member` 的 proto/service

结论：
- 即使没有集中 `boot.go`，domain 目录名和实现文件也足以读出主要上下游

### `client-internal/member`
目录锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/client-internal/member/internal/domain`

已确认 domain 文件有：
- `client.go`
- `dwz.go`
- `notify.go`
- `ops.go`
- `idmapping.go`
- `user.go`

再看：
- `/Users/zhanghang/go/src/go.planetmeican.com/client-internal/member/internal/domain/ops.go`
  - 直接依赖 `planet/ops/v1`
- `/Users/zhanghang/go/src/go.planetmeican.com/client-internal/member/internal/domain/idmapping.go`
  - 直接依赖 `planet/idmapping-proto`

结论：
- 这个服务不是孤立内部服务，它也向上/向侧边依赖 `ops`、`idmapping`

### `planet/operator`
目录锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/operator/internal/domain`

已确认 domain 目录有：
- `idmapping`
- `meican-staff`
- `member`
- `user`

再看：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/operator/internal/domain/member/member.go`
  - 直接调用 `client-internal/member`

结论：
- `operator` 的核心拓扑可以直接从 domain 目录读出来

## 什么时候这套方法最有用

适合：
- 你刚打开一个不熟的 Go 服务
- 想快速知道它调了谁
- 想知道该先看哪个 proto 仓
- 还没跑 trace，但需要先画出可能的调用边界

## 什么时候不能只靠这套方法

不够的情况：
- 老式单体（如部分 `kiwi/*`）
- 数据平台仓（如 `bi/transformer`, `redshift-management`）
- 前端 / BFF / GraphQL 仓

这些要改用：
- `main.go`
- router / handler / config
- operation / schema / generated hook

## 推荐工作流
1. 先看 `internal/domain` 目录名
2. 再看 `boot.go`
3. 再看单个 domain 文件里的：
   - `rpc.New("...")`
   - proto import
   - `InternalServiceClient` / `AdminServiceClient`
4. 画出初版拓扑
5. 再用 log / trace 验证真实链路

## 相关文档
- `project-map.md`
- `project-cards.md`
- `owned-project-patterns.md`
- `../development/repo-family-patterns.md`
- `../operations/verify-dine-in-order-debug.md`
