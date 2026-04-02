# 平台关系

## 用途
这个页面说明：
- 环境怎么映射
- ArgoCD / Terraform / Nacos / 模板分别负责什么
- logging / tracing / metric 在平台视角怎么串

## 环境映射
- `sandbox`
- `production` (`meican1`)
- `prod` (`meican2`)

对应根路径：
- ArgoCD
  - `sandbox`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - `production`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - `prod`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
- Terraform
  - `sandbox`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-sandbox`
  - `production`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-production`
  - `prod`: `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod`

## 平台职责分层

### ArgoCD
负责运行时 manifests：
- `webapp.yaml`
- `rollout.yaml`
- `service.yaml`
- `istio-*`
- `service-monitor.yaml`
- `pagerduty.yaml`

看这里，当你要确认：
- 当前 image/tag
- service / ingress / rollout
- probes / HPA / sidecar
- service-monitor / pagerduty runtime manifests

### Terraform
负责 infra / resource provisioning：
- ECR
- Route53
- IAM
- RDS / Redis / MQ / alarms
- dashboard / alert 的 app 侧定义锚点

看这里，当你要确认：
- 资源是否存在
- host / repo / IAM role 是否被创建
- dashboard / alert 定义在哪里

### Nacos
当前已确认的事实更准确应表述为：
- Nacos 本身不是这里的业务源码仓；在业务项目视角里，它主要体现为配置中心和运行时配置来源。
- 应用侧接入通常不是手写一套 nacos 客户端逻辑，而是通过 `nerds/app` / `nerds/app/v2` 这类框架能力自动接入。
  - 当前默认应先按 `nerds/app` v1 理解。
  - 本地抽样结果里，大多数真实业务项目仍然直接引用 `go.planetmeican.com/nerds/app`，而不是 `.../v2`。
  - `v2` 目前更多出现在框架自身、脚手架链路或少量新代码里。
  - 真实锚点：
    - `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/README.md`
    - `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2/README.md`
    - `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2/app.go`
    - `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2/pkg/conf/datasource/nacos/nacos.go`
  - `nerds/app` README 明确写明支持从 `nacos` 拉配置和 credentials。
  - `nerds/app/v2` 里直接注册了 nacos datasource provider，并支持 `watch`。
- 平台资源目录存在：
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/terraform-prod/nacos`
  - `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/terraform-prod/nacos`
- 在真实 rollout 模板里，应用通过框架 flag 读取 Nacos：
  - 例子：
    - `/Users/zhanghang/go/src/go.planetmeican.com/paperwork/migrate-client/argo-sandbox/helm/templates/rollout.yaml`
  - 参数形态：
    - `--config nacos://http:nacos-hs.nacos:8848/<namespace>?dataid=config.toml&group=<project>`
    - `--watch true`
- 这个模式不是个别例子，已经在多个 runtime manifest 里重复出现。
- 已确认重复出现的业务例子包括：
  - `nation-client/client`
  - `client-internal/member`
  - `nation-client/id-card-adapter`
  - `meican-pay/payment`
  - `meican-pay/checkout`
  - `mutants/order20`
- 常见附带约定：
  - `nerds.k8s.meican.com/inject: "true"`
  - `APP_CONFIG` / `APP_CREDENTIALS` / `APP_GROUP` / `APP_PROJECT` 等环境变量由注入机制补齐
  - `nerds/app/v2/flags.go` 对这些 env 和 `nacos://...` DSN 形态有明确说明

现阶段规则：
- 可以确认 Nacos 在公司项目里主要是“配置中心 + 由应用框架接入”的角色。
- 看某个项目怎么接入 Nacos，优先顺序应该是：
  1. 先看项目是否基于 `nerds/app` v1
  2. 如果不是，再判断是否是 `nerds/app/v2`
  3. 再看 rollout / helm / argo 模板里的 `--config nacos://...`
  4. 最后才看具体项目自定义的 config / credentials
- 不先假设所有服务都完全共用同一套变更流程；具体项目仍要再看一轮本地事实。

### 模板
模板负责新项目起手结构和实施检查：
- `../../templates/app/bootstrap-checklist.md`
- `../../templates/app/rollout-checklist.md`
- `../../templates/app-bootstrap-pack/README.md`

## 一次常见变更会碰哪些层

### 只改运行时行为
通常先看：
1. ArgoCD
2. 必要时 Nacos / 配置入口

### 需要新资源或 host / IAM / DB / dashboard
通常先看：
1. Terraform
2. 再核对 ArgoCD

### 新项目或规范化项目
通常按这个顺序：
1. 模板 / checklist
2. Terraform 最小集
3. ArgoCD 最小运行时
4. dashboard / alert / service-monitor

## 观测系统在平台视角的分工
- logging：`logclick`
- tracing：调用链和 trace pivot
- metric：Grafana / dashboard / alert / service-monitor

先看哪里：
- 需要具体请求与 payload：先 log
- 需要上下游链路：先 trace
- 需要容量、错误率、探活、系统性异常：先 metric / dashboard

## 相关文档
- `overview.md`
- `environments.md`
- `nerds-app-and-nacos.md`
- `argocd-playbook.md`
- `terraform-playbook.md`
- `observability-entry.md`
- `observability-playbook.md`
