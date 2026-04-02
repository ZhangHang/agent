# Proto Family Map

## 用途
这个页面回答：

- method / message / service 应该先去哪个 proto 仓找
- `api-center/protobufs` 和各业务自带 proto 仓怎么分工
- 什么时候默认走新 proto，什么时候回旧/独立 proto 仓

## 默认规则

### 默认先查 `api-center/protobufs`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`

这是当前新的共享 proto 主仓，README 也明确写了它的目标是：
- 统一管理 protobuf
- 做跨 proto 引用、lint、统一编译
- 作为更稳定的协作与契约管理入口

适用规则：
- 只要 method / service / message 能在这里找到，就优先把它当 source of truth
- 特别是：
  - `client-internal/member`
  - `planet/ops/v1`
  - `nation-client/id-card/v2`
  这些已经迁入 `api-center/protobufs` 的路径

## 仍然高频的重要独立 proto 仓

### `nation-client/client-proto`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`

适用场景：
- `client` 历史链路
- `ops` 里仍然直接 import 的旧 client proto
- 你在代码里看到 `nation-client/client-proto/v1/...` 时

已确认事实：
- README 自带 `client` 的 prod / sandbox grpc 地址说明
- 说明它不只是历史遗留目录，而是仍有现实运行语义

### `planet/planet-proto`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto`

适用场景：
- `/v1/planet/*`
- `planet` 对外/对端契约
- grpc-gateway / swagger / doc 联动的旧/独立 planet 契约

已确认事实：
- README 明确包含 header 约定、编译方式、文档输出、客户端构建产物

### `planet/project-proto`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/project-proto`

适用场景：
- `project` 域 method / message
- 当问题落在项目、组织、场地、project 相关契约时

### `planet/idmapping-proto`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping-proto`

适用场景：
- `idmapping` 的 ID / LegacyID / Snowflake 映射相关契约
- 当业务仓直接 import `planet/idmapping-proto` 时

### `nation-client/meal-group-proto`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/meal-group-proto`

适用场景：
- `meal-group` 领域方法与消息

### `developer/proto`
路径：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`

适用场景：
- `developer/dapi-be` 及其周边开放接口、报表、merchant、payment 等契约

已确认事实：
- README 直接给出 `dapi-be` grpc 地址
- 顶层目录已经按业务域拆出：
  - `client`
  - `dev`
  - `dine_in`
  - `meal_point`
  - `merchant`
  - `report`
  - `meican_pay*`

## 读取顺序

### 场景 1：先有 method 名
顺序：
1. `api-center/protobufs`
2. 对应业务独立 proto 仓
3. 再回业务代码看 import 路径是否仍引用旧 proto

### 场景 2：先有业务仓代码
顺序：
1. 看代码里 import 了哪个 proto 路径
2. 以代码 import 为准
3. 如果 import 还在旧 proto 仓，不要强行切到 `api-center/protobufs`

### 场景 3：画服务拓扑
顺序：
1. 先看 `internal/domain/*`
2. 再看 domain 实现 import 了哪个 proto 仓
3. 用 proto 仓确认 method / request / response

## 典型例子

### `planet/ops`
已确认：
- `internal/domain/member/member.go`
  - import `api-center/protobufs/client-internal/member/v1/...`
- `internal/domain/id_card/id_card.go`
  - import `api-center/protobufs/nation-client/id-card/v2`
- `internal/domain/client/client.go`
  - 仍 import `nation-client/client-proto/v1/...`

结论：
- 同一个服务里，可能同时跨新 proto 和旧 proto
- 不要假设所有依赖都已经迁到统一 proto 主仓

### `developer/dapi-be`
已确认：
- `internal/domain/ops/ops.go`
  - import `api-center/protobufs/planet/ops/v1`
- `internal/domain/member/member.go`
  - import `api-center/protobufs/client-internal/member/v1/...`

结论：
- `dapi-be` 这类 gateway 很可能优先对接新的共享 proto

## 常见误区
- 误区：所有 proto 都已经迁到 `api-center/protobufs`
  - 更合理：默认先查它，但仍以代码 import 为准
- 误区：看到旧 proto 仓就认为已经废弃
  - 更合理：很多业务链仍直接引用旧 proto
- 误区：先从 README 猜 service，再找代码
  - 更合理：代码 import + domain 目录往往更快

## 相关文档
- `proto-strategy.md`
- `typical-go-service-patterns.md`
- `repo-family-patterns.md`
- `../architecture/topology-from-domain-dirs.md`
- `../architecture/project-cards.md`
