# Debug Workflow

## 用途
这个页面定义标准 debug 闭环：
- 收入口信息
- 1-2 轮查询
- 本地缓存 JSON
- trace / proto / code anchor
- facts / inference
- case
- durable reference / skill update

## 标准步骤

### 1. 收入口信息
先固定这些字段中的至少一个：
- method
- card code
- user id
- client member id
- order id
- time window
- environment

### 2. 第一轮查询：找到入口与 trace
优先只查入口，不一开始把所有服务都打满。

推荐：
- 用 `logclick query run`
- 优先带：
  - `time`
  - `app`
  - `x-otel-trace-id`
  - `method`
  - `req`
  - `reply`

目标：
- 找到入口请求
- 拿到关键 trace id

### 3. 第二轮查询：查整条 trace
拿到 `x-otel-trace-id` 后，再查全链路。

推荐：
- `SELECT time, app, method, req, reply, raw`
- 直接 `--json`
- 落本地 `/tmp/<case>.json`

目标：
- 减少重复查询
- 后续优先本地 `jq` 分析

### 4. 代码和 proto 对照
日志证据拿到后，再去：
- provider / service / domain
- proto
- frontend / sdk / adapter

优先找：
- 入口方法
- 下游调用点
- 显式过滤/失败日志
- request/response message

### 4.1 先用 `internal/domain` 画初版拓扑
对很多 Go 服务，不要一开始就盲搜全仓。

先看：
- `internal/domain/*`
- `internal/domain/boot.go`
- domain 文件里的 `rpc.New("...")` / `grpc.New("...")`

这一步的目标是：
- 先画出“它可能调了谁”的初版拓扑
- 再用 trace 和日志验证，而不是边查边猜

参考：
- `../architecture/topology-from-domain-dirs.md`
- `../development/proto-family-map.md`

### 5. facts 和 inference 分开
facts：
- 直接来自日志、trace、代码锚点

inference：
- 来自代码路径推断
- 来自未观察到日志但能解释现象的逻辑

永远不要混写。

### 6. 写 case
用 `debug-case-writer` 的结构：
- scope
- query path
- key identifiers
- facts
- downstream flow
- code anchors
- confirmed reasons
- inference / open gaps

输出到：
- `knowledge/inbox/<case>.md`

### 7. 更新长期知识
如果个案沉淀出了稳定模式：
- 更新 domain reference
- 必要时收紧 skill 默认行为
- 记入 `knowledge/inbox/changelog.md`

这一步用：
- `knowledge-maintainer`

## Skill 分工
- 查询：`logclick-debug`
- 代码/链路追踪：`service-trace`
- 个案写作：`debug-case-writer`
- 长期沉淀：`knowledge-maintainer`
- 路由：`meican-copilot`

## 何时升级成长期 reference
- 同类问题重复出现
- 查询模板已经稳定
- 下游链路稳定
- 未来 agent 不看 case 也需要知道这件事

## 相关文档
- `log-query-playbook.md`
- `verify-dine-in-order-debug.md`
- `tracing-playbook.md`
- `../architecture/topology-from-domain-dirs.md`
- `../development/proto-family-map.md`
- `../../inbox/changelog.md`
