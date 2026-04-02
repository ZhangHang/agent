# 前端 / BFF / SDK 阅读模式

## 用途
这个页面沉淀 `/Users/zhanghang/meican` 这类前端、BFF、SDK、GraphQL、前端邻接 Go API 仓的常见阅读方法。

目标不是替代具体项目卡片，而是回答：
- 这类仓通常该从哪层进
- 它们和后端服务、GraphQL、SDK、配置中心怎么连
- 遇到问题时先怀疑哪一层

## 先分类型，再进代码

### 1. 宿主前端
典型仓：
- `/Users/zhanghang/meican/planet-ops-frontend`
- `/Users/zhanghang/meican/planet-h5`
- `/Users/zhanghang/meican/meican-mp`
- `/Users/zhanghang/meican/solomon-fe`

推荐进入顺序：
1. route / page / feature 入口
2. 页面下的 service / API 常量
3. 公共组件、hooks、state
4. 最后再回 BFF 或后端

常见判断：
- 页面没展示、交互不对，先看宿主前端
- 页面发错请求、参数不对，再往后追 API 常量或调用层

### 2. 嵌入式 SDK / 工具箱 monorepo
典型仓：
- `/Users/zhanghang/meican/web-sdk-raven`
- `/Users/zhanghang/meican/awesome-sdk`

推荐进入顺序：
1. monorepo root 的 `package.json`
2. `projects/*` 下的宿主 demo / docs / playground
3. `packages/*` 下的核心能力、widgets、styles、hybrid bridge
4. 再回真实嵌入点所在宿主前端

常见判断：
- SDK 自身行为、组件、bridge 问题，先看 monorepo 包
- 被哪个宿主页面怎么嵌进去，再回宿主仓

### 3. GraphQL contract / codegen 工具链
典型仓：
- `/Users/zhanghang/meican/meican-app-graphql`

推荐进入顺序：
1. `clients/*/operations.yml`
2. `.codegen*.yml`
3. `packages/meican-app-graphql/*`
4. generated hooks / types 包
5. 最后再回宿主前端或 BFF

常见判断：
- schema 不匹配
- operation 缺失
- generated hooks / types 不对
- playground/endpoint 指向错误

这些都应先看 GraphQL 工具链仓，而不是直接怀疑宿主前端。

### 4. 前端邻接 Go API / BFF
典型仓：
- `/Users/zhanghang/meican/meican-pay-checkout-bff`
- `/Users/zhanghang/meican/user-management`
- `/Users/zhanghang/meican/bi-api`
- `/Users/zhanghang/meican/bi-api-app`

推荐进入顺序：
1. `cmd/main.go` 或根目录 `main.go`
2. `internal/domain/*` 或等价 service/provider 目录
3. `internal/net/http` / `internal/grpc-provider` / `internal/net/grpc`
4. config / ORM / cron / queue

常见判断：
- BFF/Go API 仓往往既不是纯前端，也不是标准领域核心服务
- 先分清它是：
  - HTTP query API
  - gRPC gateway / aggregation
  - 报表导出 / 任务驱动服务
  - 支付 checkout 聚合层

### 5. 独立观测或工具前端
典型仓：
- `/Users/zhanghang/meican/logclick/logclick-fe`

推荐进入顺序：
1. `src/app/*` 或页面目录
2. `src/services/*`
3. `src/hooks/*`
4. `src/store/*`
5. 再回对应 backend / API 契约

常见判断：
- 查询条件、表格、图表问题先看前端状态与 hook
- 接口契约、过滤语义再回 backend / swagger / generated client

## 高价值例子

### `planet-ops-frontend -> @fe/planet-sf-tools -> web-sdk-raven -> /v1/planet/*`
阅读顺序：
1. `planet-ops-frontend` 页面或组件入口
2. `src_v3/components/common/sf-tools/index.js`
3. `web-sdk-raven/src/pages/sftools/*`
4. `/v1/planet/*` 对应后端

### `宿主前端 -> meican-app-graphql -> meican-bff -> backend`
阅读顺序：
1. 宿主前端页面 / feature
2. GraphQL operation / hook
3. `meican-app-graphql` 的 operation / generated types
4. `meican-bff`
5. 真正业务后端

### `前端问题其实落在 Go API / BFF`
典型例子：
- `user-management`
- `bi-api`
- `bi-api-app`
- `meican-pay-checkout-bff`

阅读顺序：
1. 先看前端发的是哪个 endpoint
2. 再看 Go API / BFF 的 `main.go`
3. 再看 domain / provider / net 层
4. 最后再扩到下游依赖

## 仓级事实锚点

### `awesome-sdk`
- `/Users/zhanghang/meican/awesome-sdk/package.json`
- 这是 pnpm monorepo
- 真实工作区包括：
  - `packages/core`
  - `packages/hybrid`
  - `packages/styles`
  - `packages/widgets`
  - `projects/device`
  - `projects/destination`
  - `projects/docs`
  - `projects/mctdocs`

### `solomon-fe`
- `/Users/zhanghang/meican/solomon-fe/package.json`
- 明确是 `Vue 3 + TypeScript + Vite`

### `logclick-fe`
- `/Users/zhanghang/meican/logclick/logclick-fe/package.json`
- `/Users/zhanghang/meican/logclick/logclick-fe/README.md`
- 明确是 `Next.js App Router + React Query + Zustand + Axios`

### `user-management`
- `/Users/zhanghang/meican/user-management/cmd/main.go`
- 明确是 `nerds/app` v1 + `easygo/gf v2`
- 会挂：
  - `internal/domain`
  - `internal/net/http`
  - ORM / Redis / DynamoDB / Elasticsearch

### `bi-api`
- `/Users/zhanghang/meican/bi-api/main.go`
- 更老式
- 根目录 `main.go` + 手工 config + postgres/redshift + grpc provider

### `bi-api-app`
- `/Users/zhanghang/meican/bi-api-app/cmd/main.go`
- 更接近现代 Go 服务
- `nerds/app` v1 + gocron + grpc provider + postgres/redshift + S3

## 工作方法
- 先判断仓类型，再决定阅读顺序。
- 不要把前端、SDK、GraphQL、BFF 都当成同一种前端仓。
- 只要看到 Go API / BFF，就优先回 `main.go -> domain -> net`。
- 只要看到 GraphQL codegen，就优先回 operation / schema / generated types。
- 只要看到 monorepo SDK，就先分 `packages/*` 和 `projects/*` 的职责。

## 相关文档
- `../architecture/project-map.md`
- `../architecture/project-cards.md`
- `repo-family-patterns.md`
- `typical-go-service-patterns.md`
