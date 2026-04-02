# 观测入口

## 用途
这个页面回答：
- 什么时候看 log
- 什么时候看 trace
- 什么时候看 metric / dashboard
- 三者怎么串起来

## 三类入口

### Logging
用在：
- 看请求和响应 payload
- 看具体卡号、用户、订单、trace id
- 看显式错误日志

入口：
- `../operations/log-query-playbook.md`
- `../operations/verify-dine-in-order-debug.md`
- `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe`

### Tracing
用在：
- 需要确认上下游调用链
- 要从入口方法往后追服务边界
- 日志里已有 `x-otel-trace-id`

入口：
- `../operations/tracing-playbook.md`
- `../capabilities/dependency-map.md`
- `../operations/scripts/trace-service-chain.md`

### Metric / Dashboard / Alert
用在：
- 没有明显错误日志，但系统行为异常
- 需要看成功率、时延、探活、资源、DB/Redis 指标
- 需要确认 dashboard / alert / service-monitor 定义

入口：
- `observability-playbook.md`
- `argocd-playbook.md`
- `terraform-playbook.md`

## 怎么联动

### 典型 debug 顺序
1. 用 log 确认入口请求、关键标识和 trace id
2. 用 trace 看跨服务调用链
3. 用 metric / dashboard 看系统性异常和运行状态
4. 再回到代码和 proto

## 配置中心和观测的连接点
- 如果某个服务的日志、trace、metric 表现和预期不一致，不要只看业务代码，也要回看它的框架配置入口。
- 对很多 Go 服务，配置中心接入和 watch 行为来自：
  - `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app`
  - `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2`
- 当前默认判断：
  - 先按 `nerds/app` v1 理解
  - 明确看到项目用了 `.../v2` 再切换到 `nerds/app/v2`
  - 碰到 `kiwi/*` 这类更老的服务时，不要硬套这条默认路径，要先回它自己的 `main.go` / `app` / `conf`
- 当你在运行时 manifest 里看到：
  - `--config nacos://...`
  - `--watch true`
  - `nerds.k8s.meican.com/inject: "true"`
  这通常意味着观测异常可能和配置分发、credentials 注入、watch 行为一起排查，而不只是业务 handler / service。

### 如果 log 不够
- 看 trace 是否能补上下游
- 看 service-monitor / alert / dashboard 是否有对应异常

### 如果 trace 不全
- 先回 log 继续补请求锚点
- 再从代码里找 provider / service / domain 边界

## 常见代码/配置锚点
- app 侧 dashboard / alert 例子：
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform`
  - 常见文件：`dashboard.tf`, `alert_rule_group.tf`, `locals.tf`, `panels/*.json`
- Argo runtime 观测 manifests：
  - `service-monitor.yaml`
  - `pagerduty.yaml`
  - `blackbox-probe.yaml`
- 已确认的真实例子：
  - `ops` 的 runtime 观测清单：
    - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod/planet/ops/service-monitor.yaml`
    - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod/planet/ops/pagerduty.yaml`
  - 部分服务在 Argo repo 里直接带 `grafana/*.json`
    - 例如 `mutants/order20`, `mutants/cart`, `mutants/dine-in-order-mid-system`

## 平台侧常见形态
- Argo runtime 常见会有：
  - `service-monitor.yaml`
  - `pagerduty.yaml`
- app 或服务目录常见会有：
  - `doc/terraform/dashboard.tf`
  - `doc/terraform/alert_rule_group.tf`
  - `doc/terraform/panels/*.json`
- 所以排查 metric / dashboard / alert 时，通常需要同时查：
  1. app repo 的 dashboard / alert 定义
  2. Argo repo 的 service-monitor / pagerduty runtime manifests

## 相关文档
- `platform-relationships.md`
- `nerds-app-and-nacos.md`
- `observability-playbook.md`
- `../operations/log-query-playbook.md`
- `../operations/tracing-playbook.md`
