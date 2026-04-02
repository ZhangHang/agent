# 典型 Go 服务模式

## 用途
这个页面总结当前公司代码里最值得拿来“找感觉”的三类典型 Go 服务：

- `nation-client/client`
- `developer/dapi-be`
- `planet/planet`

目标不是替代具体项目卡片，而是回答：
- 常见项目怎么启动
- `domain / service / net` 怎么分工
- 看到一个新仓时，应该先去哪层
- 哪些服务是单一职责，哪些服务是聚合网关

## 共同模式

这三个项目都符合一条很稳定的骨架：

1. `cmd/main.go`
   - 用 `nerds/app` v1 启动应用
   - 再用 `easygo/gf/v2/boot` 组合数据库、Pulsar、SQS、gRPC、gateway、jobs 等能力
2. `internal/domain/*`
   - 封装外部依赖和跨服务访问
   - `boot.go` 里统一做 `Init/Setup`
3. `internal/service/*`
   - 承担业务编排、筛选、转换、聚合
   - `boot.go` 或 `service.go` 里做 service 级初始化
4. `internal/net/*`
   - 暴露对外接口
   - 典型形态是 `grpc`, `grpcgateway`, 有些项目再带 `http`

经验规则：
- 先看 `cmd/main.go`，判断这个项目是纯 gRPC、gRPC+gateway，还是还挂 HTTP。
- 再看 `internal/domain/boot.go`，确认它依赖哪些外部域。
- 再看 `internal/net/*`，判断暴露面。
- 最后看具体 `service/*`，理解业务逻辑。

## `nation-client/client`

### 项目气质
- 更像“领域核心服务”
- 聚焦 `client / plan / member`
- 自己承担很多筛选、限制、legacy/fan 分支逻辑

### 启动模式
- `cmd/main.go` 使用 `nerds/app` v1
- `boot.Configure(...)` 里挂：
  - Redis cacher
  - SQS
  - Pulsar
  - gRPC auth/JWT
  - `domain.Boot()`
  - `service.Boot()`
- 对外主要是 gRPC server + jobs server

### 结构特征
- `internal/domain/*`
  - `area`
  - `baseinfo`
  - `idmapping`
  - `member`
- `internal/service/*`
  - `fan.go`
  - `legacy_client.go`
  - `plan_member.go`
  - `plan_open_time.go`
  - `plan_restriction.go`
  - `search.go`
- `internal/net/grpc/*`
  - 对外接口面比较收敛

### 什么时候先看它
- mealplan / client member / dinner-in 筛选
- legacy/fan 路径
- 餐计划开放时间、限制、运营态问题

## `developer/dapi-be`

### 项目气质
- 更像“复杂网关 / 聚合入口”
- 对外承担签名、鉴权、限流、endpoint 路由
- 对内再分发到大量业务域

### 启动模式
- `cmd/main.go` 使用 `nerds/app` v1
- `boot.Configure(...)` 里挂：
  - SQS
  - Pulsar
  - Redis cacher
  - gRPC auth/JWT
  - `domain.Boot()`
  - gateway middleware boot
- 对外同时有：
  - gRPC server
  - gRPC gateway server
  - jobs server

### 结构特征
- `internal/domain/*` 很多，覆盖：
  - `client`
  - `member`
  - `ops`
  - `id_card`
  - `idmapping`
  - `merchant`
  - `subsidy`
  - `profiles`
  - `payment_gateway`
  - ...
- `internal/service/*` 更接近“按产品能力分组”：
  - `developer_v2`
  - `dinein`
  - `group_delivery`
  - `meican_pay_*`
  - `user_management`
  - `setting`
  - ...
- `internal/net/*`
  - `grpc`
  - `grpcgateway`

### 什么时候先看它
- 开放平台 / DAPI 问题
- 先怀疑签名、限流、鉴权、网关转发，而不是底层业务没实现
- 问题落在“为什么外部请求没打到下游”时

## `planet/planet`

### 项目气质
- 更像“内部管理端大聚合服务”
- 对外能力面最宽
- 同时挂了多种对外协议

### 启动模式
- `cmd/main.go` 使用 `nerds/app` v1
- `boot.Configure(...)` 里挂：
  - database
  - Pulsar
  - SQS
  - S3
  - gRPC JWT
  - `domain.Init()`
  - `service.Init()`
- 对外同时有：
  - gRPC gateway
  - HTTP server
  - gRPC server
  - jobs server

### 结构特征
- `internal/domain/*` 极多，说明它是强聚合服务
  - `client`
  - `member`
  - `ops`
  - `project`
  - `operator`
  - `order20`
  - `workflow`
  - `regulation`
  - `id_card_adapter`
  - ...
- `internal/net/*`
  - `grpc/providerv1/*` 非常丰富
  - `grpcgateway/*`
  - `http/apiv1/*`
- `internal/service/*`
  - 相比 domain 更薄，常承担权限、菜单、工具类编排

### 什么时候先看它
- `planet` 管理端或 `/v1/planet/*` 相关问题
- SFTools / backend tool APIs
- 不确定是哪个内部域提供能力，但确定入口挂在 `planet`

## 如何快速判断一个新项目属于哪种模式

### 领域核心服务
特征：
- `domain/*` 数量适中
- `service/*` 里有较重的业务筛选和规则实现
- 对外接口面较少

优先参考：
- `nation-client/client`

### 复杂网关 / 代理型服务
特征：
- `domain/*` 很多
- `service/*` 往往按产品入口组织
- `net/grpcgateway` 很重要
- README 或接口说明里经常强调签名、权限、rate limit

优先参考：
- `developer/dapi-be`

### 内部大聚合服务
特征：
- `domain/*` 非常多
- 同时有 `grpc + grpcgateway + http`
- 对外能力面大，路径多，历史包袱也多

优先参考：
- `planet/planet`

## 排查顺序建议

### 先看启动和协议面
1. `cmd/main.go`
2. `internal/net/*`

### 再看依赖边界
1. `internal/domain/boot.go`
2. 各个 `domain/*` 初始化点

### 最后看业务逻辑
1. 目标 `service/*`
2. 如果有 legacy/fan/plan/member 等典型词，优先找这些高语义文件

## 相关文档
- `../architecture/project-map.md`
- `../architecture/project-cards.md`
- `grpc-gateway-standard.md`
- `app-planning.md`
