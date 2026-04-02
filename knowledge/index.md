# Knowledge Index

这是 shared agent 的工作知识库入口，采用 **knowledge-first, skill-second**。

先按对象或任务找到稳定文档，再决定是否使用 micro skill。

## 按对象查

### 项目 / 仓库
1. [项目地图](domains/architecture/project-map.md)
2. [项目卡片](domains/architecture/project-cards.md)
3. [Repo Family Map](domains/architecture/repo-family-map.md)
4. [负责项目常见模式](domains/architecture/owned-project-patterns.md)
5. [工作区与贡献信号](domains/architecture/workspace-and-contribution-signals.md)
6. [项目清单](domains/architecture/project-inventory.md)
7. [服务目录](domains/architecture/service-catalog.md)
8. [系统结构总览](domains/architecture/overview.md)

### 平台 / 环境 / 交付
1. [平台关系](domains/infra/platform-relationships.md)
2. [环境映射](domains/infra/environments.md)
3. [nerds/app 与 Nacos](domains/infra/nerds-app-and-nacos.md)
4. [ArgoCD Playbook](domains/infra/argocd-playbook.md)
5. [Terraform Playbook](domains/infra/terraform-playbook.md)

### 观测系统
1. [观测入口](domains/infra/observability-entry.md)
2. [Log Query Playbook](domains/operations/log-query-playbook.md)
3. [Tracing Playbook](domains/operations/tracing-playbook.md)
4. [Observability Playbook](domains/infra/observability-playbook.md)

### 规范 / 模板
1. [规范入口](domains/development/standards-index.md)
2. [Development Overview](domains/development/overview.md)
3. [Engineering Principles](principles/engineering-principles.md)
4. [Template Library](#模板库)

## 按任务查

### 调试一条业务链路
1. [Debug Workflow](domains/operations/debug-workflow.md)
2. [Scenario Index](domains/capabilities/scenario-index.md)
3. [Dependency Map](domains/capabilities/dependency-map.md)
4. [Service Trace Script Contract](domains/operations/scripts/trace-service-chain.md)

### 查日志 / Trace / 指标
1. [观测入口](domains/infra/observability-entry.md)
2. [Log Query Playbook](domains/operations/log-query-playbook.md)
3. [Tracing Playbook](domains/operations/tracing-playbook.md)
4. [VerifyDineInOrder Debug Reference](domains/operations/verify-dine-in-order-debug.md)
5. [dapi-be Signature Debug Reference](domains/operations/dapi-be-signature-debug.md)

### 发布 / 配置 / Infra 变更
1. [平台关系](domains/infra/platform-relationships.md)
2. [Infra Overview](domains/infra/overview.md)
3. [ArgoCD Playbook](domains/infra/argocd-playbook.md)
4. [Terraform Playbook](domains/infra/terraform-playbook.md)

### 新建 / 规范化项目
1. [规范入口](domains/development/standards-index.md)
2. [App Planning](domains/development/app-planning.md)
3. [App Bootstrap Checklist](templates/app/bootstrap-checklist.md)
4. [Rollout Checklist](templates/app/rollout-checklist.md)

### 沉淀 case / 更新知识
1. [Debug Workflow](domains/operations/debug-workflow.md)
2. [Daily Inbox Changelog](inbox/changelog.md)
3. [Contributing Rules](meta/contributing.md)
4. [Weekly Review Checklist](meta/review-checklist.md)

## Domain Overviews
- [Architecture](domains/architecture/overview.md)
- [Infra](domains/infra/overview.md)
- [Operations](domains/operations/overview.md)
- [Development](domains/development/overview.md)
- [Capabilities](domains/capabilities/overview.md)

## 典型入口
- 项目关系和代码入口： [项目地图](domains/architecture/project-map.md)
- 高频 repo 事实卡片： [项目卡片](domains/architecture/project-cards.md)
- 本地仓按项目族分组： [Repo Family Map](domains/architecture/repo-family-map.md)
- 你负责项目的常见链路： [负责项目常见模式](domains/architecture/owned-project-patterns.md)
- 前端到服务的高频拓扑： [Frontend Service Topology](domains/architecture/frontend-service-topology.md)
- 本地工作区和 `zhanghang` 贡献信号： [工作区与贡献信号](domains/architecture/workspace-and-contribution-signals.md)
- 从 `internal/domain` 快速推断拓扑： [Topology From Domain Dirs](domains/architecture/topology-from-domain-dirs.md)
- 典型 Go 服务怎么长： [典型 Go 服务模式](domains/development/typical-go-service-patterns.md)
- 不同项目族怎么读代码： [Repo Family Patterns](domains/development/repo-family-patterns.md)
- 新知识怎么从代码蒸馏出来： [Code Distillation Method](domains/development/code-distillation-method.md)
- 前端 / BFF / SDK 怎么读代码： [Frontend / BFF / SDK Patterns](domains/development/frontend-bff-sdk-patterns.md)
- proto 应该先去哪个仓找： [Proto Family Map](domains/development/proto-family-map.md)
- `ops -> member -> id-card -> client -> idmapping` 业务链： [VerifyDineInOrder Debug Reference](domains/operations/verify-dine-in-order-debug.md)
- `dapi-be` v1 / v2 验签失败怎么查： [dapi-be Signature Debug Reference](domains/operations/dapi-be-signature-debug.md)
- 环境、ArgoCD、Terraform、Grafana 关系： [平台关系](domains/infra/platform-relationships.md)
- 配置中心 / `nerds/app` / Nacos 怎么接： [nerds/app 与 Nacos](domains/infra/nerds-app-and-nacos.md)
- 日志、trace、metric 怎么联动： [观测入口](domains/infra/observability-entry.md)
- 如何把真实排查沉淀成 case 和长期知识： [Debug Workflow](domains/operations/debug-workflow.md)

## 模板库
- [Incident Ticket Template](templates/incident/ticket-template.md)
- [Incident RCA Template](templates/incident/rca-template.md)
- [Design Review Template](templates/design/review-template.md)
- [Technical Plan Template](templates/design/technical-plan-template.md)
- [App Bootstrap Checklist](templates/app/bootstrap-checklist.md)
- [Rollout Checklist](templates/app/rollout-checklist.md)
- [App Bootstrap Pack README](templates/app-bootstrap-pack/README.md)
- [App Bootstrap Pack Coupling Checklist](templates/app-bootstrap-pack/coupling-checklist.md)

## Maintenance
- [Daily Inbox Changelog](inbox/changelog.md)
- [Contributing Rules](meta/contributing.md)
- [Weekly Review Checklist](meta/review-checklist.md)
