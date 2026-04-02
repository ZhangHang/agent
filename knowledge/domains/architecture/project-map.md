# 项目地图

## 用途
这个页面是“先去哪看代码、项目之间怎么连”的总入口。

先看这里，再进入更细的 `project-inventory.md`、`service-catalog.md` 或具体 debug reference。

## 代码根目录

### `/Users/zhanghang/go/src/go.planetmeican.com`
这是后端、proto、infra、平台仓的主根目录。

当前已确认的高频分组包括：
- `planet/*`
- `nation-client/*`
- `developer/*`
- `meican-cd/*`
- `nerds/*`
- `titan/*`
- `meican-pay/*`
- `client-internal/*`
- `mutants/*`
- `api-center/protobufs`

### `/Users/zhanghang/meican`
这是前端、旧系统、客户端、SDK、部分独立服务仓的本地工作根目录。

当前已确认的高频分组包括：
- `planet-ops-frontend`
- `web-sdk-raven`
- `awesome-sdk`
- `logclick/*`
- `fan`
- `planet-h5`
- `meican-mp`
- `meican-app-graphql`
- `meican-api-doc`
- `meican-tui`
- `bi-api`
- `bi-api-app`
- `client-cli`
- `meican-pay-checkout-bff`
- `aws-nginx-web`
- `planet-nginx-v2`
- `bi-dbt`
- `doorkeeper-*`
- `solomon-fe`
- `user-management`
- `ios/*`

经验规则：
- 先想“这是后端服务 / proto / infra 问题”，优先进 `go.planetmeican.com`
- 先想“这是前端 / sdk / 客户端 / 历史系统问题”，优先进 `meican`

## 主域分组

### Planet
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`
  - `planet` 主服务与 `/v1/planet/*` 能力提供者。
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops`
  - `ops` 业务服务，包含 `VerifyDineInOrder` 等链路入口。
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-api`
  - 本地存在的独立 backend repo。
  - 代码形态更接近历史 HTTP API 聚合服务，`engine/engine.go` 里统一注册 `/api/v1`、`/api/v2.0`、`/api/v3`、`/internalapi` 等路由。
  - 当前已确认与 frontend 有历史/邻接关系；`planet-ops-frontend` 代码中仍保留对 `planet-api` 的注释和配置引用。
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping`
  - legacy id 与 snowflake id 映射服务。

### Nation Client
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`
  - client / mealplan 核心服务。
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card`
  - 卡身份核心服务。
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card-adapter`
  - adapter 卡来源与身份桥接。

### Frontend / Embedded Tools
- `/Users/zhanghang/meican/planet-ops-frontend`
  - ops frontend。
- `/Users/zhanghang/meican/web-sdk-raven`
  - web sdk 与 `sftools` 页面实现。
- `/Users/zhanghang/meican/awesome-sdk`
  - 前端/SDK 工具箱 monorepo。
- `/Users/zhanghang/meican/meican-api-doc`
  - Developer API 文档门户。
- `/Users/zhanghang/meican/planet-h5`
  - ops H5 / hybrid 风格前端。
- `/Users/zhanghang/meican/meican-mp`
  - 小程序 / H5 / 多端用户前端。
- `/Users/zhanghang/meican/meican-app-graphql`
  - 面向前端的 GraphQL schema / operation / codegen 工具链。

### Client / User-Facing Frontend
- `/Users/zhanghang/meican/planet-h5`
  - H5 宿主，README 明确标注为 `Planet H5`，有 sandbox / staging / prod 地址。
- `/Users/zhanghang/meican/meican-mp`
  - 微信 / 支付宝 / 鸿蒙 / Web 4.0 多端工程。
- `/Users/zhanghang/meican/meican-app-graphql`
  - 对接 `meican-bff` 的 GraphQL operations 与前端类型生成仓。
- `/Users/zhanghang/meican/solomon-fe`
  - 独立 Vue 3 + TypeScript + Vite 前端。
- `/Users/zhanghang/meican/iMeicanPay`
  - 支付相关 iOS SDK / framework。

### Internal / Support Services
- `/Users/zhanghang/go/src/go.planetmeican.com/client-internal/member`
  - client / client member / mealplan 管理与查询服务。
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/operator`
  - 多类 operator 统一查询服务。
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-be`
  - client 的 BE/异步任务层。

### Developer / Gateway
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
  - developer 域的 gateway/backend。

### Frontend-Adjacent Go APIs / BFF
- `/Users/zhanghang/meican/user-management`
  - 第三方开发者内部查询接口服务。
- `/Users/zhanghang/meican/bi-api`
  - BI 报表与统计数据相关 API。
- `/Users/zhanghang/meican/bi-api-app`
  - BI 相关的 `nerds/app` v1 + gRPC + cron 服务。
- `/Users/zhanghang/meican/meican-pay-checkout-bff`
  - 支付 checkout BFF / 聚合层。
- `/Users/zhanghang/meican/meican-tui`
  - 终端里的美餐客户端与实验性 TUI/CLI 工具。

### Payment / Platform-Adjacent
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/checkout`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/payment`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/subsidy`

### Kiwi / Legacy Core Systems
- `/Users/zhanghang/go/src/go.planetmeican.com/kiwi/baseinfo`
- `/Users/zhanghang/go/src/go.planetmeican.com/kiwi/cafeteria`
- `/Users/zhanghang/go/src/go.planetmeican.com/kiwi/order-system`
- `/Users/zhanghang/go/src/go.planetmeican.com/kiwi/sso`

### Proto / Shared Contract
- `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`
  - 新 proto 默认放这里。
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`
  - client 相关旧/独立 proto。

### Delivery / Infra
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

### Framework / Bootstrap
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app`
  - 公司里大多数 Go 服务默认先看的 bootstrap/config 框架。
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2`
  - 新一代应用 bootstrap / component / datasource 框架，但当前不是默认主流。
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app-cli`
  - 用于脚手架和 skeleton 生成的 CLI。

### Observability
- `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe`
  - LogClick frontend / API 契约参考。
- `/Users/zhanghang/meican/logclick/logclick-fe`
  - 新版 LogClick 前端。

### Edge / Nginx / Front Door
- `/Users/zhanghang/meican/aws-nginx-web`
  - 历史 nginx/front-door 配置集合。
- `/Users/zhanghang/meican/planet-nginx-v2`
  - 整合后的 `public/internal` nginx 入口配置仓。

### Data Modeling / Analytics Projects
- `/Users/zhanghang/meican/bi-dbt`
  - dbt 数据建模与迁移工程集合。

## 高价值关系

### `planet-ops-frontend -> planet-sf-tools -> web-sdk-raven -> /v1/planet/*`
已验证锚点：
- `planet-ops-frontend`
  - `/Users/zhanghang/meican/planet-ops-frontend/src_v3/components/common/sf-tools/index.js`
  - 通过 `@fe/planet-sf-tools` 渲染 SFTools。
- `web-sdk-raven`
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/main.js`
  - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/const/api.js`
  - `sftools` 页面调用 `/v1/planet/*`。
- `planet`
  - 本地 `planet` repo 中有 `sftools_entry` 和对应能力配置锚点。

### `meican-app-graphql -> meican-bff`
已验证锚点：
- `meican-app-graphql`
  - `/Users/zhanghang/meican/meican-app-graphql/README.md`
  - 明确写明它是 `meican-bff` 的 GraphQL 文件集合和 codegen 工具链。
  - playground / endpoint 直接指向 `https://meican-bff.sandbox.planetmeican.com/graphql`
- 经验规则：
  - 当前端问题落在 GraphQL schema、operation、generated types、RTK/Apollo hooks 时，先看这个仓，再回具体宿主前端。

### `ops -> member -> id-card -> client -> idmapping -> id-card-adapter`
高频业务链：
- 入口：`/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/net/grpc/provider/internal.go`
- 参考：`../operations/verify-dine-in-order-debug.md`

### `go.planetmeican.com` 和 `meican` 的协作模式
- 后端主服务、proto、infra repo 主要在 `go.planetmeican.com`
- 前端宿主、嵌入 SDK、部分历史系统主要在 `meican`
- 一个常见模式是：
  - 前端在 `/Users/zhanghang/meican/...`
  - 后端 API / gRPC 服务在 `/Users/zhanghang/go/src/go.planetmeican.com/...`
  - 运行时配置和观测在 `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/...`
- 另一种高频模式是：
  - 业务宿主前端在 `/Users/zhanghang/meican/...`
  - GraphQL contract / generated hooks 在 `/Users/zhanghang/meican/meican-app-graphql`
  - 真正后端或 BFF 再回 `go.planetmeican.com` 或独立 BFF repo 查
- 还有一类高频模式是：
  - 宿主前端或工具 UI 在 `/Users/zhanghang/meican/...`
  - 嵌入式 SDK / toolkit 在 `web-sdk-raven` 或 `awesome-sdk`
  - 真正接口再回 `planet`、独立 BFF，或 Go API 仓
- 还有一类边界层模式是：
  - 页面或域名问题表面看像前端
  - 实际入口、Host、public/internal 暴露、代理转发在 `aws-nginx-web` 或 `planet-nginx-v2`
- 对很多 Go 服务，还会再加一层：
  - 应用 bootstrap / config / tracer / metrics / config-center 接入由 `nerds/app` 提供，少量项目或新链路会用 `nerds/app/v2`
  - 所以查配置来源、watch 行为、标准 flags 时，默认先回到 `nerds/app`，再判断需不需要看 `v2`

## 怎么进入一个项目

### Backend 服务
优先顺序：
1. `cmd/main.go`
2. `internal/net/grpc/provider*` 或 `grpcgateway/register.go`
3. `internal/service/*`
4. `internal/domain/*`
5. 关联 proto
6. 如果启动/config/watch 行为看不明白，默认先回 `nerds/app`
7. 确认项目是新链路或明确用了 `.../v2` 时，再看 `nerds/app/v2`

例外：
- `kiwi/baseinfo`
- `kiwi/cafeteria`
- `kiwi/order-system`

这些项目更适合直接从根目录 `main.go`、本地脚本、旧式 config/app 入口开始，不要强套新式服务结构。

### Frontend / Web SDK
优先顺序：
1. 页面路由或组件入口
2. API 常量或 service 层
3. 嵌入点 / SDK 初始化点
4. 被调用 backend 的方法或路由

常见例子：
- `planet-ops-frontend`
  - 页面入口 / 组件入口
  - `parameters/baseParameters.js`
  - `src_v3/components/common/sf-tools/index.js`
- `web-sdk-raven`
  - `src/pages/sftools/main.js`
  - `src/pages/sftools/router.js`
  - `src/pages/sftools/const/api.js`
- `planet-h5`
  - 先看页面 / route / feature module
  - 再看 hybrid bridge / route stack / modal stack
- `meican-mp`
  - 先定平台（weapp / alipay / h5 / harmony）
  - 再找对应 `src` 页面和多端构建配置
- `meican-app-graphql`
  - 先看 `clients/*/operations.yml`
  - 再看 `.codegen.yml`
  - 再看 `packages/*` 生成后的 hook / types 包

### Frontend / SDK / BFF 复合项目
优先顺序：
1. 先判断它是宿主前端、SDK monorepo、GraphQL 工具链，还是 Go API / BFF
2. 宿主前端先看页面/feature
3. SDK monorepo 先分 `packages/*` 和 `projects/*`
4. GraphQL 工具链先看 operation / codegen / generated hooks
5. Go API / BFF 先看 `cmd/main.go` 或根目录 `main.go`

高价值例子：
- `awesome-sdk`
- `meican-app-graphql`
- `user-management`
- `bi-api`
- `bi-api-app`
- `meican-pay-checkout-bff`
- `logclick/logclick-fe`
- `meican-tui`

### Frontend + GraphQL / BFF
优先顺序：
1. 宿主前端页面 / feature 入口
2. GraphQL operation 或 hook 调用点
3. `meican-app-graphql` 里的 operation / generated types / packages
4. 再回 BFF 或 backend

常见例子：
- `meican-app-graphql`
  - `README.md`
  - `clients/*/operations.yml`
  - `packages/meican-app-graphql/src/*`
  - `packages/*-graphql-hook/*`

### Infra / Delivery
优先顺序：
1. 先定环境
2. 再看 ArgoCD 运行时目录
3. 再看 Terraform 资源目录
4. 需要 dashboard / alert 时再看 observability 相关路径

### Config Center / Framework
优先顺序：
1. 先按 `nerds/app` v1 理解项目的框架接入
2. 再判断项目是否已经迁到 `nerds/app/v2`
3. 看 rollout / helm / argo 模板中的 `--config nacos://...` 和 `--watch true`
4. 看 `credentials.toml` / `config.toml` / 框架 flags
5. 再看 Nacos 平台资源或更细平台文档

## 相关文档
- 详细 repo 清单：`project-inventory.md`
- repo family 总览：`repo-family-map.md`
- 详细项目卡片：`project-cards.md`
- 负责项目常见模式：`owned-project-patterns.md`
- 前端 / BFF / SDK 阅读模式：`../development/frontend-bff-sdk-patterns.md`
- 前端到服务拓扑：`frontend-service-topology.md`
- 从 `internal/domain` 推断拓扑：`topology-from-domain-dirs.md`
- 工作区与贡献信号：`workspace-and-contribution-signals.md`
- 高价值服务摘要：`service-catalog.md`
- 业务依赖链：`../capabilities/dependency-map.md`
- 平台关系：`../infra/platform-relationships.md`
