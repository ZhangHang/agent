# Project Inventory

## Purpose
Consolidated inventory of repositories with path and functional summary.

Use this as the raw inventory.

For the working entrypoint, start from:
- `project-map.md`

## Common Chain Index
- verify dine-in order:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/net/grpc/provider/internal.go`
  - downstream: `member`, `id-card`, `idmapping` (and conditional `id-card-adapter` via `id-card`).
- id mapping lookup:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping`
  - proto: `/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping-proto`
- card identity resolution:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card`
  - adapter path: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card-adapter`

## Planet Domain
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`
  - Internal management backend.
  - Aggregates multiple microservices (for example `nation-client/client`) for management workflows.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto`
  - Planet standalone proto repository.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/app-constraint`
  - App version/constraint service (check/upgrade logic).
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops`
  - Ops-facing service in planet domain.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/dwz`
  - Short URL service.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/operator`
  - Cross-system operator lookup service.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/payment-companion`
  - Payment companion service in planet domain.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/meican-staff`
  - Meican staff service.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/regulation`
  - Privacy policy and agreement/protocol service.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping`
  - Legacy ID to snowflake ID mapping service.
  - Used when upstream/downstream still provides legacy IDs but external-facing usage requires snowflake IDs.
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/idmapping-proto`
  - ID mapping proto repository.

## Developer Domain
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
  - Developer open-platform backend gateway (sign/rate/auth complexity).
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`
  - Developer proto repository.
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-adapter`
  - Adapter for third-party developer platform integration.

## Nation-Client Domain
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`
  - Core client entity service.
  - Each client can own many meal plans (`plan`) and related configurations.
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-be`
  - BE layer for client domain.
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card`
  - Identity card core service.
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card-adapter`
  - Adapter between external card inputs and internal identity model.
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/meal-group`
  - Meal group service.
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/area`
  - Area/region data provider service.
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`
  - Client proto repo (legacy/standalone; usually excluded from current upgrade waves).

## Shared Platform / Infra
- `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`
  - Central protobuf repository (default for new proto definitions).
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-sandbox`
  - ArgoCD repo for sandbox env.
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-production`
  - ArgoCD repo for meican1 production env.
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd/argocd-prod`
  - ArgoCD repo for meican2 prod env.
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-cd`
  - Infrastructure root (terraform and deployment repos).
- `/Users/zhanghang/go/src/go.planetmeican.com/titan/base-images`
  - Base image source of truth for CI/runtime upgrades.
- `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe`
  - Log query frontend and API contract reference.

## Business App Domain
- `/Users/zhanghang/go/src/go.planetmeican.com/be-meican-app/payment-adapter`
  - Payment adapter service for new payment interfaces.

## Frontend Domain
- `/Users/zhanghang/meican/planet-ops-frontend`
  - Planet 项目的 ops frontend。
  - 通过 `@fe/planet-sf-tools` SDK 在 DAPI 相关页面打开 SF Tools。
  - SFTools 入口锚点：
    - `/Users/zhanghang/meican/planet-ops-frontend/src_v3/components/common/sf-tools/index.js`
    - `/Users/zhanghang/meican/planet-ops-frontend/src/components/DAPI/v3.tsx`
    - `/Users/zhanghang/meican/planet-ops-frontend/src/components/DAPI/DevelopmentTeamDetail/v3.tsx`
- `/Users/zhanghang/meican/web-sdk-raven`
  - 包含 SF Tools 前端页面实现（本次仅纳入 sftools 范围）。
  - SFTools runtime 锚点：
    - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/main.js`
    - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/router.js`
    - `/Users/zhanghang/meican/web-sdk-raven/src/pages/sftools/const/api.js`
  - 部署锚点：
    - `/Users/zhanghang/meican/web-sdk-raven/package.json` (`deploy_prod` -> `s3://planet/planet-sdk-iframes`)
