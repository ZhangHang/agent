# Legacy Migration TODO

目的：追踪 `legacy/` 文档逐篇融合进新结构的进度，满足“融合完成再删除”。

## In Progress
- [ ] `app-bootstrap-terraform-argocd-playbook.md`
  - 目标：`../infra/terraform-playbook.md`、`../infra/argocd-playbook.md`、`../templates/app/bootstrap-checklist.md`
- [ ] `business-chains.md`
  - 目标：`../capabilities/dependency-map.md`、`../operations/common-failure-patterns.md`
- [ ] `dapi-be-gateway-failure-playbook.md`
  - 目标：`../operations/common-failure-patterns.md`
- [ ] `backend-project-standards.md`
  - 目标：`../development/deep-dive.md`
- [ ] `engineering-delivery-playbook.md`
  - 目标：`../development/deep-dive.md`
- [ ] `work-modes.md`
  - 目标：`../../SKILL.md`
- [ ] `knowledge-growth.md`
  - 目标：`../CONTRIBUTING.md`、`../CHANGELOG.md`

## Done and Deleted
- [x] `codebase-roots.md` -> `../architecture/deep-dive.md`（deleted）
- [x] `deploy-infra-roots.md` -> `../architecture/deep-dive.md` + `../infra/environments.md`（deleted）
- [x] `platform-architecture.md` -> `../architecture/overview.md` + `../architecture/deep-dive.md`（deleted）

## Deletion Gate Checklist (must all pass)
- [ ] 关键步骤 100% 保留
- [ ] 命令/路径锚点可追溯
- [ ] 失败模式与恢复已迁入
- [ ] 至少 1 个真实案例锚点
- [ ] `../INDEX.md` 已有入口
- [ ] `../CHANGELOG.md` 已记录

