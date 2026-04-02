# 项目卡片

## 用途
这是第一批高价值项目的稳定卡片。

每张卡片只回答：
- 它是什么
- 从哪进代码
- 上下游是谁
- 常见 debug 锚点在哪

## `planet/ops`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/ops`
- 职责：planet 域里的 ops 业务服务。
- 代码入口：
  - `cmd/main.go`
  - `internal/net/grpc/provider/internal.go`
  - `internal/service/dinein.go`
- 结构特征：
  - `internal/domain/*` 同时依赖 `member`, `id_card`, `client`, `clientv2`, `idmapping`, `order20` 等多个域
  - `internal/service/*` 里 `dinein.go`, `order.go`, `client_member.go` 是高频业务入口
  - 更像业务编排服务，而不是最底层领域核心服务
- 直接拓扑锚点：
  - `internal/domain/boot.go` 会直接初始化 `member`, `client`, `clientv2`, `id_card`, `idmapping`, `checkout`, `order20`, `user_order_system` 等下游域
- 典型下游：
  - `member`
  - `id-card`
  - `client`
  - `idmapping`
  - `id-card-adapter`
- 典型 case：
  - `VerifyDineInOrder`

## `planet/planet`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`
- 职责：`/v1/planet/*` 相关核心能力提供者。
- 代码入口：
  - `cmd/main.go`
  - `internal/net/grpcgateway/register.go`
  - `internal/net/grpc/providerv1/*`
- 结构特征：
  - `cmd/main.go` 同时挂 `grpc gateway + http + grpc + jobs`
  - `internal/domain/*` 数量很多，说明它是内部大聚合服务
  - `internal/net/http/apiv1/*` 和 `internal/net/grpc/providerv1/*` 都很关键
- 直接拓扑锚点：
  - `internal/domain/boot.go` 会初始化 `area`, `casbin`, `client`, `member`, `user`, `id_card_adapter`, `ops`, `workflow`
- 前端关系：
  - `planet-ops-frontend`
  - `web-sdk-raven/sftools`
- 典型锚点：
  - `config/*/config.toml` 中的 `planet-api` / `sftools_entry` 配置
  - `internal/domain/boot.go`
  - `internal/service/service.go`

## `planet-api`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-api`
- 职责：历史独立 HTTP backend / API 聚合服务。
- 代码入口：
  - `engine/engine.go`
  - `engine/apiv1.go`
  - `engine/apiv2_0.go`
  - `engine/apiv3.go`
  - `engine/internal_api.go`
- 形态特征：
  - `gin.Engine`
  - 多组 `/api/*` 路由
  - 带 cache / dynamodb / backend 等层
- 与 frontend 的关系：
  - `planet-ops-frontend` 里仍有对 `planet-api` 的注释和配置引用

## `planet/project`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/project`
- 职责：project 领域服务，和 project proto 配套。
- 代码入口：
  - `cmd/main.go`
  - `internal/domain/*`
  - `internal/service/*`
- 关键关系：
  - 常和 `planet/project-proto` 一起看
  - 当问题落在项目、场地、组织或 project 归属信息时值得优先进入

## `api-center/protobufs`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`
- 职责：新的共享 proto 主仓。
- 代码入口：
  - `proto/**/*`
  - 各业务域下的 service / message 定义
- 使用建议：
  - method / request / response 能在这里找到时，默认先用这里作为契约 source of truth
  - 找不到再回业务 repo 自带 proto 仓

## `planet/planet-proto`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto`
- 职责：`planet` 相关独立 proto 仓。
- 关键事实：
  - README 明确包含 header 约定、编译方式、文档输出和客户端构建产物
- 使用建议：
  - 当问题落在 `/v1/planet/*` 契约且代码没有直接切到 `api-center/protobufs` 时，优先回这里

## `planet/project-proto`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/project-proto`
- 职责：`project` 域独立 proto 仓。
- 使用建议：
  - `project` 相关 method / message 优先回这里

## `planet/idmapping-proto`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping-proto`
- 职责：`idmapping` 契约仓。
- 使用建议：
  - 业务代码直接 import 它时，以它为准，不强行转到别的 proto 仓

## `developer/proto`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`
- 职责：developer 域独立 proto 仓。
- 使用建议：
  - `dapi-be`、merchant、report、meal_point、meican_pay 等开放契约先回这里

## `nation-client/client-proto`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`
- 职责：client 相关旧/独立 proto 仓。
- 代码入口：
  - `proto/**/*`
- 使用建议：
  - 当 `api-center/protobufs` 里没有对应 method，或者确认是 client 历史链路时再回这里

## `planet-ops-frontend`
- 路径：`/Users/zhanghang/meican/planet-ops-frontend`
- 职责：ops frontend。
- 代码入口：
  - `src_v3/components/common/sf-tools/index.js`
  - `parameters/baseParameters.js`
- 关键关系：
  - 调 `@fe/planet-sf-tools`
  - 页面里有大量 `/v1/planet/*` path 常量
- 典型 debug：
  - 先找页面入口，再找 path 常量，再对到 backend

## `web-sdk-raven`
- 路径：`/Users/zhanghang/meican/web-sdk-raven`
- 职责：web sdk 与 `sftools` 页面实现。
- 代码入口：
  - `src/pages/sftools/main.js`
  - `src/pages/sftools/router.js`
  - `src/pages/sftools/const/api.js`
- 关键关系：
  - 被 `planet-ops-frontend` 通过 `@fe/planet-sf-tools` 嵌入
  - `sftools` 里直接调用 `/v1/planet/*`

## `planet-h5`
- 路径：`/Users/zhanghang/meican/planet-h5`
- 职责：`Planet H5`，README 明确给出 sandbox / staging / prod 地址。
- 代码入口：
  - `src/*`
  - `CONTRIBUTING.md`
- 形态特征：
  - 明显按 hybrid / app-like H5 设计
  - 有 route stack、modal stack、bridge、转场动画约定
- 常见 debug：
  - 先区分是纯 H5 页面问题、hybrid bridge 问题，还是后端接口问题

## `meican-mp`
- 路径：`/Users/zhanghang/meican/meican-mp`
- 职责：微信 / 支付宝 / 鸿蒙 / Web 4.0 多端前端工程。
- 代码入口：
  - `src/*`
  - `config/*`
  - `README.md`
- 形态特征：
  - 同仓支持多平台构建
  - H5 / weapp / alipay / harmony 切换依赖不同构建入口
- 常见 debug：
  - 先定平台，再找页面，再看公共 hooks / shared modules

## `meican-app-graphql`
- 路径：`/Users/zhanghang/meican/meican-app-graphql`
- 职责：面向前端的 GraphQL contract / operations / codegen 工具链。
- 代码入口：
  - `README.md`
  - `clients/*/operations.yml`
  - `.codegen*.yml`
  - `packages/meican-app-graphql/*`
- 关键关系：
  - README 明确写明对接 `meican-bff`
  - 生成 Typescript types、RTK Query hooks、Apollo hooks
- 常见 debug：
  - schema 不匹配、operation 缺失、生成 hook/types 不对时先看这里

## `awesome-sdk`
- 路径：`/Users/zhanghang/meican/awesome-sdk`
- 职责：对内对外开发套件合集，pnpm monorepo 形态的前端/SDK 工具箱。
- 代码入口：
  - `package.json`
  - `packages/*`
  - `projects/*`
- 结构特征：
  - monorepo 明确拆成 `packages/core`, `packages/hybrid`, `packages/styles`, `packages/widgets`
  - `projects/device`, `projects/destination`, `projects/docs`, `projects/mctdocs` 更像宿主 demo / docs / playground
- 常见 debug：
  - 先区分是 SDK 包本身问题，还是被某个宿主项目嵌入后的问题

## `client-cli`
- 路径：`/Users/zhanghang/meican/client-cli`
- 职责：独立 CLI 工程。
- 代码入口：
  - `main.go`
  - `cmd/*`
  - `cli/*`
- 常见用途：
  - 本地命令行工作流
  - completion / 子命令排查

## `meican-api-doc`
- 路径：`/Users/zhanghang/meican/meican-api-doc`
- 职责：Developer API 文档门户。
- 代码入口：
  - `README.md`
  - `package.json`
  - `src/*`
- 结构特征：
  - Gatsby 静态站
  - 明确有 beta / prod 文档站发布脚本
- 常见 debug：
  - 文档构建、静态发布、内容展示问题先看这里；真正 API 行为仍回 developer backend / proto

## `meican-tui`
- 路径：`/Users/zhanghang/meican/meican-tui`
- 职责：终端里的美餐客户端与实验性 TUI/CLI 工具。
- 代码入口：
  - `cmd/main.go`
  - `internal/cli/*`
  - `internal/api/graphqlgen/*`
- 结构特征：
  - Go CLI + Bubble Tea TUI
  - GraphQL API + 本地 SQLite + 可选 LLM
- 常见 debug：
  - 先分清是 CLI 子命令、TUI 状态、GraphQL 契约，还是本地数据/LLM 配置问题

## `iMeicanPay`
- 路径：`/Users/zhanghang/meican/iMeicanPay`
- 职责：支付相关 iOS SDK / framework。
- 代码入口：
  - `Package.swift`
  - `Sources/*`
  - `Scripts/build-xcframework.sh`
  - `MeicanPayment.xcframework`
- 结构特征：
  - Swift Package Manager
  - 同时维护 xcframework 构建与测试工程
- 常见 debug：
  - iOS 集成、framework 打包、第三方支付 SDK 接入问题先看这里

## `aws-nginx-web`
- 路径：`/Users/zhanghang/meican/aws-nginx-web`
- 职责：历史 nginx/front-door 配置集合。
- 代码入口：
  - `nginx.conf`
  - `meican/*.conf`
  - `lua/*`
- 结构特征：
  - 大量域名级 `.conf`
  - 带 `proxy-order-system.lua` 等入口脚本
- 常见 debug：
  - 域名入口、反向代理、历史 host 路由问题先看这里

## `planet-nginx-v2`
- 路径：`/Users/zhanghang/meican/planet-nginx-v2`
- 职责：整合后的 planet nginx 入口配置仓。
- 代码入口：
  - `README.md`
  - `nginx.conf`
  - `conf.d/*.conf`
  - `common/*.conf`
- 结构特征：
  - README 明确描述 `public/internal`、WAF、ALB、TargetGroup 关系
  - 配置里能直接看到 `ops.conf`, `planet-sf-tools.conf`, `nacos.conf`, `grafana.conf`, `tracing.conf`
- 常见 debug：
  - Host、入口流量、public/internal 暴露边界问题先看这里

## `bi-dbt`
- 路径：`/Users/zhanghang/meican/bi-dbt`
- 职责：BI 数据建模 / dbt 工程集合。
- 代码入口：
  - `bi_dbt/*`
  - `bi_dbt_doris/*`
  - `dbt_poc/*`
  - `docs/*`
- 结构特征：
  - 同仓同时容纳 DuckDB/Redshift 与 Doris 方向的 dbt 项目
  - `docs/*` 明确有 migration roadmap / layer plan / tracker
- 常见 debug：
  - 数据模型、dbt 项目分层、迁移计划或 Doris/Redshift 分叉问题先看这里

## `user-management`
- 路径：`/Users/zhanghang/meican/user-management`
- 职责：给第三方开发者提供内部查询接口，更像前端邻接 Go API / query service。
- 代码入口：
  - `cmd/main.go`
  - `internal/domain/*`
  - `internal/net/http/*`
- 结构特征：
  - `nerds/app` v1 + `easygo/gf v2`
  - 同时接 ORM、DynamoDB、Redis、Elasticsearch
  - 不是典型领域核心服务，更像“查询 API + integration service”
- 常见 debug：
  - 先区分是 HTTP query 层、数据源层，还是 developer 链路权限/转发问题

## `bi-api`
- 路径：`/Users/zhanghang/meican/bi-api`
- 职责：面向 BI / 报表数据的 gRPC API 服务。
- 代码入口：
  - `main.go`
  - `grpc-provider/*`
  - `services/postgres/*`
- 结构特征：
  - 更老式 Go 服务形态
  - 根目录 `main.go` 手工加载 config，再初始化 postgres / redshift / s3 / grpc
- 常见 debug：
  - 报表接口、Redshift、导出或模板能力问题先看这里

## `bi-api-app`
- 路径：`/Users/zhanghang/meican/bi-api-app`
- 职责：BI 相关的现代化 app 形态服务，兼具 gRPC 与定时任务。
- 代码入口：
  - `cmd/main.go`
  - `internal/grpc-provider/*`
  - `internal/services/task/*`
- 结构特征：
  - `nerds/app` v1
  - 同时挂 gRPC、gocron、postgres、redshift、S3
  - 比 `bi-api` 更接近现代 app/bootstrap 形态
- 常见 debug：
  - 先区分是同步 gRPC 接口、定时任务，还是数据源接入问题

## `solomon-fe`
- 路径：`/Users/zhanghang/meican/solomon-fe`
- 职责：独立前端应用。
- 代码入口：
  - `package.json`
  - `src/*`
- 结构特征：
  - `Vue 3 + TypeScript + Vite`
  - 比较标准的现代 Vue 前端壳子
- 常见 debug：
  - 优先看 route / page / api 调用，再回对应 BFF 或后端

## `meican-pay/payment`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/payment`
- 职责：支付域后端服务。
- 代码入口：
  - `cmd/main.go`
  - `internal/boot/*`
  - `internal/net/grpc/*`
- 结构特征：
  - 典型 `nerds/app` v1 启动
  - `Startup(\"payment\") -> boot.Init -> grpc server + consumer`
- 常见 debug：
  - 先看 grpc provider / consumer，再回 boot 和 config

## `meican-pay/subsidy`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/subsidy`
- 职责：餐补/补贴服务。
- 代码入口：
  - `cmd/main.go`
  - `internal/job/*`
  - `internal/net/grpc/*`
- 结构特征：
  - 带更早期的 `gogf + telemetry.InitJaeger + nerds/app` 混合形态
  - 启动时会先跑 jobs，再挂 grpc
- 常见 debug：
  - 要同时看 job 和 grpc，不要只盯接口层

## `meican-pay/checkout`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/checkout`
- 职责：收银台后端。
- 代码入口：
  - `cmd/main.go`
  - `internal/net/http/*`
  - `internal/net/grpc/*`
  - `internal/consumer/*`
- 结构特征：
  - 典型重型支付服务：同时挂 `http + grpc + consumer`
  - 使用 `nerds/app` v1，但内部基础设施更重（db、mq、otel、provider、service）
- 常见 debug：
  - 先分清是同步接口问题、消费链问题，还是支付基础设施问题

## `kiwi/baseinfo`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/kiwi/baseinfo`
- 职责：基础数据系统，负责订餐前的大量基础数据准备。
- 代码入口：
  - `main.go`
  - `handler/*`
  - `rpc/provider/*`
- 结构特征：
  - 典型旧式 gin/http 单体 + rpc provider + mq 混合模式
  - 不按新式 `cmd/main.go + internal/domain/service` 组织
- 常见 debug：
  - 先看 `main.go` 里怎么组 infra、http routes、rpc、mq，再进具体 handler

## `kiwi/cafeteria`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/kiwi/cafeteria`
- 职责：食堂系统。
- 代码入口：
  - `main.go`
  - `app/*`
  - `grpc/*`
- 结构特征：
  - 旧式 `flag + app.Parse(workdir, env)` 启动
  - 更像传统配置驱动服务，不是 `nerds/app` 主干
- 常见 debug：
  - 先看 `app.Parse` 和 conf，再看 grpc provider

## `kiwi/order-system`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/kiwi/order-system`
- 职责：订单系统，负责订单存储、支付、生命周期。
- 代码入口：
  - `main.go`
  - `handler/*`
  - `rpc/*`
  - `service/*`
- 结构特征：
  - 旧式大型业务服务：`gin/http + rpc + mq + jobs`
  - 不适合按新式小服务心智进入
- 常见 debug：
  - 先分清是下单/支付/http 路径，还是 rpc / mq / cron 路径

## `kiwi/sso`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/kiwi/sso`
- 职责：统一登录授权服务。
- 代码入口：
  - `cmd/main.go`
  - `internal/net/http/*`
  - `internal/net/grpc/*`
  - `appConf/*`
- 结构特征：
  - 虽然用了 `nerds/app`，但整体仍带明显的旧系统风格
  - 同时挂 `http + grpc + pulsar consumer/producer`
  - `Config.OnChange(...)` 是值得留意的锚点
- 常见 debug：
  - 登录态、远程依赖、配置热更新一起看

## `bi/mbi`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/mbi`
- 职责：BI 在线服务之一。
- 代码入口：
  - `cmd/main.go`
  - `internal/domain/*`
  - `internal/net/grpc/*`
  - `internal/net/http/*`
- 结构特征：
  - `nerds/app` v1 + `easygo/gf/v2/boot`
  - 同时挂 `grpc + http + job`
- 常见 debug：
  - 当 BI 问题落在在线接口或 job，而不是数据工程链路时先看这里

## `bi/report`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/report`
- 职责：报表服务。
- 代码入口：
  - `cmd/main.go`
  - `internal/net/http/*`
  - `cmd/boot/*`
- 结构特征：
  - `nerds/app` v1 + `easygo/gf/v2/boot`
  - 带 `s3`、job 和本地插件化报表生成能力
- 常见 debug：
  - 先分清是 HTTP 报表接口、job，还是本地 plugin/report type 逻辑

## `bi/export-report-job`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/export-report-job`
- 职责：报表导出任务服务。
- 代码入口：
  - `cmd/main.go`
  - `internal/domain/*`
  - `internal/net/http/*`
- 结构特征：
  - `nerds/app` v1 + `easygo/gf/v2/boot`
  - 更偏 job/导出服务

## `bi/report-customizer`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/report-customizer`
- 职责：定制化报表服务。
- 代码入口：
  - `main.go`
  - `config/*`
  - `route/*`
  - `customizer/*`
- 结构特征：
  - 非 `nerds/app` 主干
  - 更像独立工具/服务
- 常见 debug：
  - 先看配置加载、dao、plugin、reporter 初始化链

## `bi/data-management`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/data-management`
- 职责：BI 元数据/数据管理平台。
- 代码入口：
  - `data_management/manage.py`
  - `data_management/settings*`
- 结构特征：
  - Django 项目，不是 Go 服务
- 常见 debug：
  - 先按 Django 管理后台/接口/模型心智进入

## `bi/transformer`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/transformer`
- 职责：dbt + Airflow + Spark + Iceberg 数据平台。
- 代码入口：
  - `dbt_project/*`
  - `airflow_project/*`
  - `docker/local/*`
- 结构特征：
  - 数据工程仓，不是在线业务服务
- 常见 debug：
  - 先判断是 dbt model、Airflow 编排、还是本地 Spark/Kyuubi 环境问题

## `bi/redshift-management`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/bi/redshift-management`
- 职责：Redshift SQL / DWD-DWS-ADS 数据产出管理。
- 代码入口：
  - `*.sql`
  - `cmp_table_data.py`
- 结构特征：
  - SQL / 数据校验资产仓，不是在线服务

## `meican-cd/argocd-*`
- 路径：
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- 职责：runtime manifests 的主入口。
- 常见入口：
  - 目标应用目录下的 `deployment.yaml` / `service.yaml` / `rollout.yaml` / `service-monitor.yaml`
- 常见 debug：
  - image、env、args、port、rollout、service monitor、pagerduty 之类运行时问题先看这里

## `meican-cd/terraform-*`
- 路径：
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`
- 职责：infra / resource / dashboard / alert provisioning 主入口。
- 常见入口：
  - 应用或平台相关的 terraform module / dashboard / alert 定义
- 常见 debug：
  - 资源、权限、监控定义、Grafana dashboard/alert、Nacos 平台资源相关问题优先看这里

## `nerds/app`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nerds/app`
- 职责：应用 bootstrap toolkit，不是业务服务；当前公司项目里默认优先看的版本。
- 代码入口：
  - `README.md`
  - `app.go`
  - `pkg/conf/*`
  - `pkg/credentials/*`
- 关键关系：
  - 提供 config / credentials / logger / telemetry / tracer / lifecycle 基础能力
  - README 明确写明支持从 `file` / `nacos` / `tower` 拉配置或 credentials
- 常见 debug：
  - 当项目的启动、配置、credentials、环境注入看不懂时先回这里

## `nerds/app/v2`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2`
- 职责：新一代应用 bootstrap / component / datasource 框架。
- 代码入口：
  - `README.md`
  - `app.go`
  - `flags.go`
  - `pkg/conf/datasource/nacos/nacos.go`
- 关键关系：
  - 直接注册 nacos datasource provider
  - `flags.go` 明确了 `APP_CONFIG` / `APP_CREDENTIALS` / `APP_GROUP` / `APP_PROJECT` 等注入环境变量
  - 配置形态直接支持 `nacos://...`
- 常见 debug：
  - 当明确看到项目 import 了 `go.planetmeican.com/nerds/app/v2`，或新链路已迁到 v2 时，再回这里理解框架行为

## `nerds/app-cli`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nerds/app-cli`
- 职责：应用脚手架 / skeleton 生成工具。
- 常见入口：
  - `main.go`
  - `cmd/*`
- 使用建议：
  - 当问题落在“新项目是怎么起手的”“脚手架默认生成了什么”时再看这里

## `developer/dapi-be`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
- 职责：developer 域的 gateway/backend，前置处理 sign / rate / auth / endpoint 等复杂逻辑。
- 代码入口：
  - `cmd/main.go`
  - `internal/net/grpcgateway/register.go`
  - `internal/net/grpc/register.go`
  - `internal/net/grpc/provider/*`
- 结构特征：
  - `cmd/main.go` 同时挂 `grpc + grpcgateway + jobs`
  - `internal/domain/*` 很多，`internal/service/*` 按产品能力入口组织
  - 更像复杂网关 / 聚合入口，而不是单一领域服务
- 直接拓扑锚点：
  - `internal/domain/boot.go` 会直接初始化 `ops`, `member`, `client`, `checkout`, `id_card`, `idmapping`, `sso`, `subsidy`, `payment_gateway` 等下游域
- 常见 debug：
  - 先区分“业务逻辑没走到”还是“前置网关校验失败”

## `titan/web-apps/logclick-fe`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe`
- 职责：LogClick frontend 与 API 契约参考。
- 常见锚点：
  - `src/services/logclick-api.ts`
  - `next.config.ts`
- 常见用途：
  - 查 `/v1/ck/*`
  - 查 `/v1/s3/*`
  - 对照前端查询契约和接口重写

## `logclick/logclick-fe`
- 路径：`/Users/zhanghang/meican/logclick/logclick-fe`
- 职责：LogClick 新前端，日志检索与可视化页面。
- 代码入口：
  - `src/app/*`
  - `src/services/*`
  - `src/hooks/*`
  - `src/store/*`
- 结构特征：
  - `Next.js App Router`
  - `TanStack React Query + Zustand + Axios`
  - 既有 dashboard，也有 `clickhouse/logs` 主查询页
- 常见 debug：
  - 先区分是页面状态、查询参数、表格/图表渲染，还是 backend 接口契约问题

## `nation-client/client`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`
- 职责：client / mealplan 核心服务。
- 典型入口：
  - legacy/fan 路径和 plan/member 路径
  - `ListDinnerInInfoByUser` 是高频排查入口
- 结构特征：
  - `cmd/main.go` 主要挂 `grpc + jobs`
  - `internal/domain/*` 聚焦外部依赖
  - `internal/service/*` 承担大量实际业务筛选逻辑，如 `fan`, `legacy_client`, `plan_member`, `plan_restriction`
- 相关 proto：
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`
  - `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`（新 proto 默认）

## `nation-client/client-be`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-be`
- 职责：client 服务的 BE / 异步任务层。
- 代码入口：
  - `cmd/main.go`
  - `README.md`
- 形态特征：
  - README 明确写明它是基于 Gin 的 HTTP 接口服务
  - 同时使用 Machinery 异步任务队列
  - 常见能力是批量创建用餐人员、批量创建配送地址
- 常见 debug：
  - 先区分同步 HTTP 上传/任务创建阶段，还是异步任务消费阶段

## `nation-client/id-card`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card`
- 职责：卡身份核心服务。
- 结构特征：
  - `internal/domain/*` 聚焦 `fan`, `id_card_adapter`, `idmapping`, `member`, `opslog`
  - `internal/service/*` 按卡能力拆分：`card_member`, `card_type`, `entity_config`, `external_card`, `operation_record`
- 直接拓扑锚点：
  - `internal/domain/member/member.go` 直接对接 `client-internal/member`
  - `internal/domain/idmapping/*`、`internal/domain/id_card_adapter/*` 直接暴露外围依赖
- 高价值方法：
  - `ListIdCardByMerchant`
  - `GetIdCardDetails`
  - `GetElectricCardIdentity`

## `planet/idmapping`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping`
- 职责：legacy id / snowflake id 映射。
- 高价值方法：
  - `GetByID`
  - `ListByLegacyIDs`

## `client-internal/member`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/client-internal/member`
- 职责：client、client member、mealplan 的管理与查询服务。
- 代码入口：
  - `cmd/main.go`
  - `README.md`
- 形态特征：
  - README 明确提到 client / client member / mealplan 管理与查询
  - 带 SNS / Pulsar 事件约定
  - `internal/service/*` 里同时有 `client_member`, `mealplan`, `mealplan_member`, `verification`, `search`
- 直接拓扑锚点：
  - `internal/domain/ops.go` 直接对接 `planet/ops`
  - `internal/domain/idmapping.go` 直接对接 `planet/idmapping`
- 常见 debug：
  - client member 建立/绑定餐计划类问题先看这里

## `planet/operator`
- 路径：`/Users/zhanghang/go/src/go.planetmeican.com/planet/operator`
- 职责：跨不同用户系统的 operator 统一查询服务。
- 代码入口：
  - `cmd/main.go`
  - `README.md`
- 形态特征：
  - README 自带主流程和 Fan 数据获取流程图
  - `internal/domain/*` 直接暴露 `member`, `user`, `idmapping`, `meican-staff` 这几个外围依赖
  - 依赖 idmapping、client member、user、developer 等多源查询
- 常见 debug：
  - 查询“某个 operator 为什么查不到/查重了/映射不对”时先看这里

## `meican-cd/argocd-*`
- 路径：
  - `argocd-sandbox`
  - `argocd-production`
  - `argocd-prod`
- 职责：运行时 manifests。
- 常见文件：
  - `webapp.yaml`
  - `rollout.yaml`
  - `service.yaml`
  - `service-monitor.yaml`
  - `pagerduty.yaml`

## `meican-cd/terraform-*`
- 路径：
  - `terraform-sandbox`
  - `terraform-production`
  - `terraform-prod`
- 职责：infra / resource provisioning。
- 常见文件：
  - `env.tf`
  - `locals.tf`
  - `ecr.tf`
  - `route53.tf`
  - `iam.tf`

## `fan`
- 路径：`/Users/zhanghang/meican/fan`
- 职责：历史 Java 业务系统，在 legacy 路径中仍然是重要依赖。
- 代码入口：
  - `app/*`
  - `conf/*`
  - `argo-sandbox/*`
- 形态特征：
  - 既有应用代码，也带运行时部署目录
  - 经常作为 legacy 用户、legacy mealplan、legacy corp 语义的来源
- 常见 debug：
  - 当 `client`/`ops` 日志里出现 `fan`、legacy corp/member/plan 语义时，要回这个仓补上下文

## `doorkeeper-fe`
- 路径：`/Users/zhanghang/meican/doorkeeper-fe`
- 职责：doorkeeper 前端。
- 代码入口：
  - `src/*`
  - `package.json`
  - `README.md`
- 形态特征：
  - 标准 Vue CLI 风格前端
- 常见 debug：
  - 先看页面和前端交互，再回 `doorkeeper-api`

## `doorkeeper-api`
- 路径：`/Users/zhanghang/meican/doorkeeper-api`
- 职责：doorkeeper API 服务。
- 代码入口：
  - `src/*`
  - `config/*`
  - `README.md`
- 形态特征：
  - README 明确给出本地 MySQL + Yarn + `dev-config.json` 的调试方式
  - 仍然是较传统的 Node/JS 服务形态
- 常见 debug：
  - 本地联调、数据库配置、iOS/doorkeeper 客户端联动问题先看这里

## `meican-pay-checkout-bff`
- 路径：`/Users/zhanghang/meican/meican-pay-checkout-bff`
- 职责：支付 checkout 相关的 BFF/聚合层。
- 代码入口：
  - `cmd/main.go`
  - `README.md`
- 形态特征：
  - Go 服务形态
  - README 直接描述支付单 / 手动支付 / 查询下一步的领域模型
- 常见 debug：
  - 支付单状态、manual pay、checkout 支付编排问题先看这里
