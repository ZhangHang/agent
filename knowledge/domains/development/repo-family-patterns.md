# Repo Family Patterns

## 用途
这个页面回答：

- 不同项目族的服务形态有什么差别
- 进入代码时该带什么心智
- 为什么同样是 Go 服务，`planet/nation-client`、`meican-pay`、`kiwi`、`bi` 读法会不一样

## 1. `planet/*` / `nation-client/*` / `developer/*`

### 默认心智
这是当前公司里更“现代”的 Go 服务主干。

常见特征：
- `cmd/main.go`
- `nerds/app` v1
- `easygo/gf/v2/boot`
- `internal/domain/*`
- `internal/service/*`
- `internal/net/grpc/*` / `grpcgateway/*` / `http/*`

典型仓：
- `planet/planet`
- `planet/ops`
- `nation-client/client`
- `nation-client/id-card`
- `developer/dapi-be`

进入顺序：
1. `cmd/main.go`
2. `internal/net/*`
3. `internal/service/*`
4. `internal/domain/*`
5. proto / rollout / framework

适合的问题：
- gRPC 方法从哪进
- 下游调了谁
- 业务筛选逻辑在哪
- 配置、trace、watch 是怎么接的

## 2. `meican-pay/*`

### 默认心智
这是支付域后端，整体还是 Go 服务，但比普通业务服务更重基础设施。

常见特征：
- 仍常用 `nerds/app` v1
- 同时挂 `grpc`、`http`、`consumer`
- 更重 DB、MQ、OTel、事务消息、支付状态机

典型仓：
- `meican-pay/payment`
- `meican-pay/subsidy`
- `meican-pay/checkout`

差异：
- `payment` 更接近典型 v1 grpc 服务
- `subsidy` 带较多历史混合形态（jobs + telemetry + nerds/app）
- `checkout` 是重型服务，`http + grpc + consumer` 全都重要

进入顺序：
1. 先分清是同步接口、异步消费，还是支付基础设施
2. 再看 `cmd/main.go`
3. 再看 `internal/net/*` / `internal/consumer/*`
4. 最后进 service / infra / config

## 3. `kiwi/*`

### 默认心智
这组不要默认按新式小服务理解。它们很多是更老的核心系统，带明显的单体/工具箱痕迹。

典型仓：
- `kiwi/baseinfo`
- `kiwi/cafeteria`
- `kiwi/order-system`
- `kiwi/sso`

常见特征：
- 根目录 `main.go`
- 旧式 `app` / `conf` / `handler` / `rpc` 结构
- `gin/http + rpc + mq + jobs` 混合
- 不一定是 `internal/domain/service` 那种现代分层

差异：
- `baseinfo` 更像基础数据单体 + rpc provider + mq
- `cafeteria` 是典型老式配置驱动 grpc 服务
- `order-system` 是大型核心订单系统，http/rpc/mq/jobs 都重
- `sso` 虽然用了 `nerds/app`，但整体仍带老系统风格

进入顺序：
1. 根目录 `main.go`
2. 本地启动脚本 / app / conf
3. handler / rpc / service
4. 再看远程依赖和队列

## 4. `bi/*`

### 默认心智
这组更像数据与报表平台，不是业务链 debug 的第一入口。

典型仓：
- `bi/mbi`
- `bi/report`
- `bi/export-report-job`
- `bi/report-customizer`
- `bi/data-management`
- `bi/transformer`
- `bi/redshift-management`

常见特征：
- 有一部分是 `nerds/app` v1 + `easygo/gf` 的服务
- 有一部分是更独立的工具或平台：
  - Django
  - dbt + Airflow + Spark
  - SQL 管理仓

差异：
- `mbi` / `report` / `export-report-job` 更接近现代 Go 服务
- `report-customizer` 是较独立的工具/服务
- `data-management` 是 Django
- `transformer` 是 dbt + Airflow 数据平台
- `redshift-management` 更像 SQL/数据资产管理仓

进入顺序：
1. 先判断是在线服务、批任务、Django 平台、还是数据工程仓
2. 再按对应技术栈进入，不要强行按业务服务心智理解

## 快速判断规则

### 先按哪套模式读
- 看到 `cmd/main.go + nerds/app + internal/domain/service`：
  - 先按 `planet/nation-client/developer` 模式
- 看到支付、consumer、txmsg、mq 特别重：
  - 先按 `meican-pay` 模式
- 看到根目录 `main.go`、`handler`、`rpc`、`app`、`conf`：
  - 先按 `kiwi` 模式
- 看到 Django / dbt / Airflow / SQL 管理：
  - 先按 `bi` 模式

### 不要做的事
- 不要把 `kiwi/*` 强套成现代微服务
- 不要把 `bi/*` 当成普通业务链下游
- 不要把支付问题只当业务 handler 问题，忽略消费者和基础设施

## 相关文档
- `typical-go-service-patterns.md`
- `../architecture/repo-family-map.md`
- `../architecture/project-cards.md`
- `../architecture/owned-project-patterns.md`
