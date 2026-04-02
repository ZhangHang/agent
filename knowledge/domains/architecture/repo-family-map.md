# Repo Family Map

## 用途
这个页面把本地公司仓按“项目族”分组，方便快速回答：

- 这个问题大概落在哪个 repo family
- 这一组仓通常是业务主仓、契约仓、平台仓，还是前端宿主
- 这一组里哪些仓本地 git 历史已确认包含 `zhanghang`

详细 ownership 不在这里定义；这里更适合做“先去哪组仓找”的工作入口。

## 规则

- `*` 表示：本地 git 历史里作者名或邮箱包含 `zhanghang`
- 没有 `*` 不表示不重要，只表示当前更适合作为上下游或背景阅读

## `planet/*`
典型职责：
- 内部聚合服务
- ops 业务编排
- ID 映射
- project / regulation / reporting / payment-companion 等周边能力

已确认高价值仓：
- `* planet/ops`
- `* planet/planet`
- `* planet/planet-api`
- `* planet/idmapping`
- `* planet/operator`
- `* planet/project`
- `* planet/app-constraint`
- `* planet/payment-companion`
- `* planet/regulation`
- `* planet/reporter`
- `* planet/ranker`
- `* planet/calculator`
- `* planet/profit-sharing`
- `* planet/client-member-cleaner`
- `* planet/virtual-number`
- `planet/wallet`

常见阅读顺序：
1. 先定入口服务是 `ops`、`planet`、`project` 还是 `idmapping`
2. 再看对应 proto / grpc provider / http or grpcgateway surface
3. 最后再扩到下游 domain

## `nation-client/*`
典型职责：
- client / mealplan 领域核心
- id-card / card identity
- client-be HTTP 与异步任务层
- 若干 proto 与周边领域服务

已确认高价值仓：
- `* nation-client/client`
- `* nation-client/client-be`
- `* nation-client/id-card`
- `* nation-client/id-card-adapter`
- `* nation-client/client-proto`
- `* nation-client/area`
- `* nation-client/meal-group`
- `* nation-client/meal-group-proto`

常见阅读顺序：
1. 先看 `client` / `id-card`
2. 再看 `client-proto` 或 `api-center/protobufs`
3. 需要 HTTP / 异步入口时再看 `client-be`

## `client-internal/*`
典型职责：
- client member / mealplan 管理与查询
- 偏内部支撑而不是直接产品宿主

已确认高价值仓：
- `* client-internal/member`

## `developer/*`
典型职责：
- developer 域 API / adapter / mock / 文档
- gateway、签名、转发、文档契约

已确认高价值仓：
- `* developer/dapi-be`
- `* developer/dapi-adapter`
- `* developer/dapi-http-mock`
- `* developer/development-team-be`
- `* developer/developer-api-doc`
- `* developer/meican-api-doc`
- `* developer/proto`

## `api-center/*`
典型职责：
- 新 proto 主仓
- 跨服务共享契约

已确认高价值仓：
- `* api-center/protobufs`

使用建议：
- method / request / response 能在这里找到时，默认先用这里作为 proto source of truth
- 但仍要接受现实：很多业务链代码里还会直接 import 旧/独立 proto 仓

## `meican-cd/*`
典型职责：
- ArgoCD runtime manifests
- Terraform infra/resource provisioning

已确认高价值仓：
- `* meican-cd/argocd-sandbox`
- `* meican-cd/argocd-production`
- `* meican-cd/argocd-prod`
- `* meican-cd/terraform-sandbox`
- `* meican-cd/terraform-production`
- `* meican-cd/terraform-prod`

## `nerds/*`
典型职责：
- app bootstrap
- config / credentials / tracer / metrics 接入
- skeleton / framework support

高价值仓：
- `nerds/app`
- `nerds/app-cli`

说明：
- 大多数项目默认先按 `nerds/app` v1 理解
- 只有明确 import `go.planetmeican.com/nerds/app/v2` 时再切 v2 语义

## `titan/*`
典型职责：
- observability UI / infra
- base images / shared platform artifacts

高价值仓：
- `* titan/base-images`
- `* titan/terraform-prod`
- `titan/web-apps/logclick-fe`

## `meican-pay/*`
典型职责：
- 支付 / 补贴 / checkout 相关后端

已确认高价值仓：
- `* meican-pay/payment`
- `* meican-pay/subsidy`
- `meican-pay/checkout`

补充前端/BFF：
- `* meican/meican-pay-checkout-bff`
- `* meican/iMeicanPay`

常见阅读顺序：
1. 先分清是 `payment`、`subsidy` 还是 `checkout`
2. `payment` 更像典型 `nerds/app` v1 grpc 服务
3. `checkout` 更像同时挂 http + grpc + consumer 的重型支付服务
4. 涉及前端/结算体验时，再补 `meican-pay-checkout-bff` 或客户端侧仓

## `kiwi/*`
典型职责：
- 较老的一组业务系统
- 更强的单体/工具箱/历史服务风格
- 覆盖基础数据、食堂、订单、SSO 等核心域

高价值仓：
- `kiwi/baseinfo`
- `kiwi/cafeteria`
- `kiwi/order-system`
- `kiwi/sso`

使用建议：
- 不要默认按新式 `planet/nation-client` 服务形态理解
- 先看 `main.go`、本地启动脚本、旧式 app/config 入口
- 再判断是 gin/http 单体、grpc provider，还是混合模式

## `bi/*`
典型职责：
- 数据平台、报表、导出、transform

已确认高价值仓：
- `* bi/data-management`
- `* bi/docs`
- `* bi/export-report-job`
- `* bi/mbi`
- `* bi/redshift-management`
- `* bi/report`
- `* bi/report-customizer`
- `* bi/transformer`
- `* bi/web-sdk-raven`

常见阅读顺序：
1. 先判断是在线 Go 服务、定制化报表工具、Django 平台，还是 dbt/Airflow 数据工程仓
2. `mbi/report/export-report-job` 更像现代 Go 服务
3. `data-management` 是 Django
4. `transformer` / `redshift-management` 更像数据工程或 SQL 资产仓

## `/Users/zhanghang/meican` 前端 / 多端 / 客户端族
典型职责：
- 宿主前端
- Web SDK
- H5 / 小程序 / iOS / CLI
- 历史系统和 BFF

已确认高价值仓：
- `* planet-ops-frontend`
- `* web-sdk-raven`
- `* planet-h5`
- `* client-cli`
- `* meican-api-doc`
- `* meican-tui`
- `* fan`
- `* doorkeeper-api`
- `* doorkeeper-fe`
- `* meican-pay-checkout-bff`
- `* aws-nginx-web`
- `* planet-nginx-v2`
- `* bi-dbt`
- `* logclick/logclick-cli`
- `* solomon-fe`
- `* user-management`
- `* bi-api`
- `* bi-api-app`
- `* ios/planet-ios`
- `* ios/meican-ios-swift`
- `* iMeicanPay`

高价值背景仓：
- `meican-app-graphql`
- `meican-mp`
- `logclick/logclick-fe`
- `awesome-sdk`

补充阅读心智：
- 宿主前端优先从 route / page / feature 入口看
- SDK / toolkit monorepo 优先区分 `packages/*` 与 `projects/*`
- GraphQL/tooling 仓优先看 operation / codegen / generated hooks
- 前端邻接 Go API / BFF 优先按 `main.go -> domain -> net` 阅读，而不是当纯前端仓
- nginx/front-door 仓优先看 host conf、upstream、proxy/Lua，而不是业务代码
- dbt/data-model 仓优先看 project layout、profiles、migration docs，而不是按普通 Go/FE 心智理解

## 相关文档
- `workspace-and-contribution-signals.md`
- `project-map.md`
- `project-cards.md`
- `owned-project-patterns.md`
- `../development/repo-family-patterns.md`
