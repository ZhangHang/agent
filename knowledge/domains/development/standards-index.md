# 规范入口

## 用途
这个页面只做规范与模板导航，不承载项目事实和具体 case。

## 服务实现规范
- `grpc-gateway-standard.md`
- `proto-strategy.md`
- `proto-family-map.md`
- `deep-dive.md`
- `typical-go-service-patterns.md`
- `repo-family-patterns.md`
- `code-distillation-method.md`
- `frontend-bff-sdk-patterns.md`

重点问题：
- 服务怎么分层
- proto 放哪里
- 具体应该先去哪个 proto 仓找
- grpc-gateway 怎么暴露
- 典型 Go 服务通常长什么样
- 不同 repo family 该带什么阅读心智
- 新知识应如何从代码蒸馏进知识库
- 前端 / SDK / GraphQL / BFF 应该从哪层进入

## 项目建设规范
- `app-planning.md`
- `../../templates/app/bootstrap-checklist.md`
- `../../templates/app/rollout-checklist.md`
- `../../templates/app-bootstrap-pack/README.md`

重点问题：
- 新项目怎么起手
- rollout 前要检查什么
- 常见耦合项有哪些

## 平台配置规范
- `../infra/argocd-playbook.md`
- `../infra/terraform-playbook.md`
- `../infra/observability-playbook.md`
- `../infra/platform-relationships.md`
- `../infra/nerds-app-and-nacos.md`

重点问题：
- runtime manifests 基本形态
- terraform 最小集
- dashboard / alert / mq 声明约定
- Nacos / 注入 / rollout 参数这类平台接入约束
- 何时按 `nerds/app` v1 理解，何时回看更老的非框架项目

## 工作方法规范
- `../../principles/engineering-principles.md`
- `../../principles/decision-frameworks.md`
- `../../principles/risk-checklists.md`

重点问题：
- facts vs inference
- 风险判断
- 如何做可复用沉淀
