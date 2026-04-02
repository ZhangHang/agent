# Service Catalog (Working Set)

## Purpose
Maintain high-value service list and role summary for investigation routing.
For full user-provided repository coverage, see:
- `project-inventory.md`

## Core Services
- `planet/planet`: internal large aggregator, simultaneously exposes grpc, grpc-gateway, and http surfaces.
- `planet/project`: project domain service, useful when the issue is about project / place / organization adjacency rather than pure ops orchestration.
- `developer/dapi-be`: complex gateway middleware app (sign, rate, authorization, endpoint checks) with grpc + grpc-gateway entrypoints.
- `developer/dapi-adapter`: developer domain adapter service, part of current base-image upgrade batch.
- `nation-client/client`: domain-core service for client / plan / member logic, with heavy business filtering in `internal/service/*`.
- `client-internal/member`: management/query service for client member and mealplan state.
- `nation-client/area`: nation-client area domain service, part of current base-image upgrade batch.
- `be-meican-app/payment-adapter`: payment domain adapter service, part of current base-image upgrade batch.
- `fan` (legacy Java): still used in major legacy business flows.

## Frontend-Adjacent APIs / BFF / Tooling
- `meican-pay-checkout-bff`: checkout-facing BFF / aggregation layer.
- `user-management`: third-party developer internal query API, more query-service shaped than domain-core.
- `bi-api`: older BI/reporting gRPC API with hand-wired config + redshift/postgres setup.
- `bi-api-app`: newer BI service using `nerds/app` v1, gRPC, cron, and data-source integration.
- `logclick/logclick-fe`: newer LogClick frontend, useful when the issue is search UX, query state, or table/chart behavior rather than backend logs only.
- `planet-ops-frontend` + `web-sdk-raven`: treat as a paired host-FE + embedded-SDK path when the issue touches SFTools or `/v1/planet/*` UI flows.
- `awesome-sdk`: FE/SDK toolkit monorepo; useful when the issue is shared widget/SDK behavior rather than a single host FE.
- `meican-api-doc`: Gatsby-based developer API docs portal, useful for doc publishing and API-doc presentation paths.
- `meican-tui`: local TUI/CLI + GraphQL client, useful as an internal tooling/example app rather than production backend.
- `aws-nginx-web` / `planet-nginx-v2`: front-door / nginx config repos for host, route, and proxy-layer issues.
- `bi-dbt`: dbt/data-model project family; useful when the issue is analytics modeling rather than online request handling.

## Pattern References
- For “how these Go services are usually structured”, start from:
  - `../development/typical-go-service-patterns.md`
  - `topology-from-domain-dirs.md`
- The three best pattern anchors are:
  - `nation-client/client`
  - `developer/dapi-be`
  - `planet/planet`
- For frontend / BFF / SDK reading patterns, start from:
  - `../development/frontend-bff-sdk-patterns.md`

## Supporting Infra Systems
- `titan/logclick`: log query platform frontend/backend.
- `titan/base-images`: base image source of truth for Docker/CI image upgrades and security remediation.
- `api-center/protobufs`: default proto source of truth when method/message exists there.
- ArgoCD repos under `meican-cd/argocd-*`.
- Terraform repos under `meican-cd/terraform-*`.

## Maintenance Rule
Update this catalog when a new service becomes critical in:
1. Delivery path.
2. Incident frequency.
3. Cross-service dependency fan-out.
