# 前端到服务拓扑参考

## 用途
这个页面沉淀几条高频的“前端 / SDK / 文档门户 / 观测前端 -> 后端服务 / 契约 / 边界层”的稳定拓扑。

目标：
- 遇到前端相关问题时，不只知道看哪个仓
- 还能快速知道它背后通常连到哪类 BFF / backend / proto / gateway

## `planet-ops-frontend -> @fe/planet-sf-tools -> web-sdk-raven -> /v1/planet/*`

### 已验证锚点
- `/Users/zhanghang/meican/planet-ops-frontend/src_v3/components/common/sf-tools/index.js`
- `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/main.js`
- `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/const/api.js`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`

### 拓扑
1. `planet-ops-frontend` 作为宿主前端挂载 `@fe/planet-sf-tools`
2. `@fe/planet-sf-tools` 落到 `web-sdk-raven` 的 `sftools` 页面实现
3. `web-sdk-raven` 直接调用 `/v1/planet/*`
4. 对应后端默认先回 `planet/planet`

### 调试建议
- 页面/交互问题先看宿主前端
- SFTools 组件/路由/API 常量问题先看 `web-sdk-raven`
- 真正接口行为再回 `planet`

## `宿主前端 -> meican-app-graphql -> meican-bff -> backend`

### 已验证锚点
- `/Users/zhanghang/meican/meican-app-graphql/README.md`
- `/Users/zhanghang/meican/meican-app-graphql/clients/*/operations.yml`
- `/Users/zhanghang/meican/meican-app-graphql/packages/*`

### 拓扑
1. 宿主前端调用 GraphQL hooks / operations
2. operation / schema / generated types 由 `meican-app-graphql` 提供
3. GraphQL endpoint 对接 `meican-bff`
4. `meican-bff` 再回源后端服务

### 调试建议
- schema / operation / generated hooks 异常先看 `meican-app-graphql`
- 请求路径、聚合字段、resolver 语义再回 BFF / backend

## `LogClick FE -> log backend / swagger / query contracts`

### 已验证锚点
- `/Users/zhanghang/meican/logclick/logclick-fe/src/app/*`
- `/Users/zhanghang/meican/logclick/logclick-fe/src/services/*`
- `/Users/zhanghang/meican/logclick/logclick-fe/docs/logclick.swagger.json`
- `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe`

### 拓扑
1. `logclick/logclick-fe` 是新版查询前端
2. 它本地自带 swagger / API 封装 / React Query hooks / Zustand state
3. 老的 `titan/web-apps/logclick-fe` 仍可作为前端与 API 契约背景锚点
4. 真正日志查询后端再回 logclick / clickhouse / API 服务链

### 调试建议
- 搜索条件、表格、图表、页面状态先看新前端
- API 路径、老约定或 rewrite 参考可回 `titan/web-apps/logclick-fe`

## `Developer API Docs -> developer API / 文档门户`

### 已验证锚点
- `/Users/zhanghang/meican/meican-api-doc/README.md`
- `/Users/zhanghang/meican/meican-api-doc/package.json`

### 拓扑
1. `meican-api-doc` 是 Gatsby 文档门户
2. 主要承担开发者文档展示和静态部署
3. 内容面向 Meican Developer API，而不是直接承载业务服务实现

### 调试建议
- 文档展示、内容发布、静态站构建问题先看这里
- 真正 API 行为仍应回 developer 域 backend / proto

## `awesome-sdk / web-sdk-raven -> 宿主前端`

### 已验证锚点
- `/Users/zhanghang/meican/awesome-sdk/package.json`
- `/Users/zhanghang/meican/web-sdk-raven/src/*`

### 拓扑
1. `awesome-sdk` 是 toolkit / SDK monorepo
2. `web-sdk-raven` 是更具体的 web sdk / 页面实现仓
3. 宿主前端按需要嵌入这些 SDK / widgets / hybrid 能力

### 调试建议
- 先判断问题属于：
  - 宿主接入
  - SDK 核心包
  - 文档/demo 项目

## `aws-nginx-web / planet-nginx-v2 -> 前端入口 / 边界层`

### 已验证锚点
- `/Users/zhanghang/meican/aws-nginx-web/meican/*.conf`
- `/Users/zhanghang/meican/planet-nginx-v2/conf.d/*.conf`
- `/Users/zhanghang/meican/planet-nginx-v2/README.md`

### 拓扑
1. 一部分前端域名、入口和边界层路由还会经过 nginx 配置仓
2. `aws-nginx-web` 更像历史 nginx/front-door 配置集合
3. `planet-nginx-v2` 是整合后的 `public/internal` nginx 入口配置仓

### 调试建议
- 域名、host、入口路由、WAF/ALB/反向代理问题先看这些仓
- 它们不提供业务逻辑，只定义流量入口和转发边界

## 相关文档
- `project-map.md`
- `project-cards.md`
- `repo-family-map.md`
- `../development/frontend-bff-sdk-patterns.md`
