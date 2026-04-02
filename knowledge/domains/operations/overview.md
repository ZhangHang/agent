# Operations Overview

## Scope
这个域回答：
- 如何 debug 一条链路
- 如何收集证据
- 如何把一次调查沉淀成 case 和长期知识

## 从哪里开始
- 标准 debug 流程：`debug-workflow.md`
- incident 入口：`incident-workflow.md`
- 日志查询：`log-query-playbook.md`
- trace 调试：`tracing-playbook.md`
- dapi 签名排查：`dapi-be-signature-debug.md`
- VerifyDineInOrder 参考：`verify-dine-in-order-debug.md`
- 常见失败模式：`common-failure-patterns.md`

## 这个域应承载的内容
- 证据获取与验证
- facts / inference 的分层
- 日志 / trace / DB / code anchors 的组合使用
- 个案沉淀与复用

## Script Registry
### Active
- `scripts/collect-context.md`
- `scripts/trace-service-chain.md`

### Inactive (Parked)
- `scripts/search-logs.md`
- `scripts/trace-lookup.md`
- `scripts/db-checks.md`
