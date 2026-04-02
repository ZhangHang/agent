# Infra Overview

## Scope
这个域回答三类问题：
- 服务部署在哪个环境、哪个 repo
- ArgoCD / Terraform / Nacos / 模板之间怎么分工
- logging / tracing / metric / dashboard 在平台侧怎么接

## 从哪里开始
- 平台分层和关系：`platform-relationships.md`
- 环境映射：`environments.md`
- Argo runtime manifests：`argocd-playbook.md`
- Terraform infra 资源：`terraform-playbook.md`
- 观测入口：`observability-entry.md`
- 观测细节：`observability-playbook.md`

## 这个域应承载的内容
- 环境与账号映射
- 交付和运行时配置入口
- 平台职责边界
- dashboard / alert / service-monitor / pagerduty 等平台约束

## 不放在这里的内容
- 具体业务链 debug：去 `operations/`
- 项目职责和代码入口：去 `architecture/`
- 编码规范：去 `development/`
