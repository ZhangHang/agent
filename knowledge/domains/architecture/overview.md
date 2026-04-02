# Architecture Overview

## Scope
这个域回答两类问题：
- 项目 / 仓库在哪里
- 系统与业务链路之间如何关联

## 从哪里开始
- 查项目、仓库、前后端关系：`project-map.md`
- 看给定项目清单和路径：`project-inventory.md`
- 看高价值服务摘要：`service-catalog.md`
- 看运行时结构和环境边界：`deep-dive.md`

## 这个域应承载的内容
- repo 与服务的稳定职责
- 前端 / 后端 / proto / infra 的关系
- 运行时边界（EKS / ECS / Lambda / gateway）
- 高价值服务清单

## 不放在这里的内容
- 具体 debug 步骤：去 `operations/`
- 发布 / 配置 / infra 操作：去 `infra/`
- 编码规范和模板：去 `development/`
