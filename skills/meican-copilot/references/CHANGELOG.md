# CHANGELOG

## Purpose
This file is the inbox-style changelog for continuous knowledge updates.

## 2026-02-24
- Implemented real `scripts/log/search_logs.sh` based on `logclick-fe` API contracts (ck/s3/list modes, cookie/base-url support, payload generation, dry-run).
- Restructured meican-copilot references into domain-based folders.
- Added overview + deep-dive split across architecture/development/operations/infra.
- Added detailed Wave 1 playbooks:
  - `operations/log-query-playbook.md`
  - `development/grpc-gateway-standard.md`
  - `infra/network-access-control.md`
  - `infra/ci-cd-playbook.md`
  - `infra/observability-playbook.md`
- Added scripts contract and script folder split.
- Kept legacy docs under `references/legacy/` with migration map.

## 2026-02-26
- Refined `infra/ci-cd-playbook.md` with base-image upgrade workflow:
  - tag existence checks in `titan/base-images`
  - `with-db-clients` fallback handling
  - DB/bootstrap idempotency checks
  - validation sequence (`make lint`, tests, revive/checkstyle alignment)
- Added branch/commit convention for the upgrade campaign:
  - branch keeps `chore/*`
  - commit prefix uses `fix:`
- Updated project catalog and capability map for current upgrade batch:
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-adapter`
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/area`
  - `/Users/zhanghang/go/src/go.planetmeican.com/be-meican-app/payment-adapter`

## Update Workflow
1. Add new finding here first with date + source anchors.
2. During weekly review, merge into target domain docs.
3. Update `legacy/MIGRATION_MAP.md` when legacy content is absorbed.
