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
- Added full user-provided project registry:
  - `architecture/project-inventory.md`
  - linked from `INDEX.md` and `architecture/service-catalog.md`
- Refined domain semantics from user:
  - `nation-client/client`: client entity with many plans/config.
  - `nation-client/area`: area data provider.
  - `planet`: internal management BE and microservice aggregator.
  - common interface classes: `admin` / `biz` / `internal` with distinct meta requirements.
  - `regulation`: privacy/agreement service.
  - `idmapping`: legacy ID to snowflake ID mapping role.
- Added detailed dine-in order verification dependency chain:
  - `planet/ops` `VerifyDineInOrder` orchestration anchors.
  - downstream service relations: `member`, `id-card`, `idmapping`.
  - conditional `id-card` -> `id-card-adapter` adapter-card path.
  - Mermaid sequence diagram and failure hotspots.
  - updated routing in `capabilities/scenario-index.md` and root `INDEX.md`.
- Upgraded `meican-copilot` core behavior and workflow guidance:
  - added `trace` mode in `SKILL.md`.
  - added `admin` / `biz` / `internal` service-interface class guidance.
  - added branch/commit convention (`chore/*` branch + `fix:` commit).
  - added lightweight no-ticket trace intake in `operations/incident-workflow.md`.
  - added `scripts/context/trace_service_chain.sh` and script index docs.
  - added common chain index in `architecture/project-inventory.md`.
- Completed full skill knowledge-base cleanup and consistency updates across docs and scripts.

## Update Workflow
1. Add new finding here first with date + source anchors.
2. During weekly review, merge into target domain docs.
3. Keep routing, scripts, and examples consistent after each merge.

## 2026-03-05
- Added frontend integration chain knowledge for Planet SFTools:
  - host: `/Users/zhanghang/meican/planet-ops-frontend`
  - embedded implementation: `/Users/zhanghang/meican/web-sdk-raven` (`sftools` only)
  - designed flow: `planet-ops-frontend -> @fe/planet-sf-tools -> web-sdk-raven/sftools -> planet backend`
- Updated knowledge anchors:
  - `domains/architecture/project-inventory.md`
  - `domains/capabilities/dependency-map.md`
  - `domains/capabilities/scenario-index.md`
  - `domains/operations/common-failure-patterns.md`

## 2026-04-01
- Added a real prod-verified debug reference for `planet.ops.v1.InternalService/VerifyDineInOrder`:
  - `domains/operations/verify-dine-in-order-debug.md`
  - linked from `knowledge/index.md`, `domains/operations/overview.md`, and `domains/operations/log-query-playbook.md`
- Verified two production call-path shapes with `logclick query run`:
  - user/client_member path: `ops -> member -> client v2 -> member`
  - card path: `ops -> id-card -> client`
- Refined `logclick-debug` to route to the new knowledge doc instead of duplicating the workflow.

## 2026-04-02
- Added a concrete prod card case for `VerifyDineInOrder`:
  - card: `E560824523262219788`
  - trace: `000000000000000061756a40409d61cb`
  - report: `knowledge/inbox/verify-dine-in-order-card-e560824523262219788-analysis-2026-04-02.md`
- Updated `domains/operations/verify-dine-in-order-debug.md` with:
  - confirmed downstream chain for the card path
  - final returned mealplan
  - directly observed `restaurant limited` filtered corp IDs
- Refined `logclick-debug` to make card-based trace pivots explicit.
- Added a faster investigation pattern:
  - query in 1-2 rounds
  - save full trace JSON locally
  - prefer local `jq` analysis before re-querying prod

## 2026-04-02

- Reorganized the shared agent knowledge base toward a dual-axis structure:
  - object axis: project map, platform relationships, observability entry, standards index
  - task axis: debug workflow, case writing, long-term knowledge maintenance
- Added new working entry pages:
  - `domains/architecture/project-map.md`
  - `domains/infra/platform-relationships.md`
  - `domains/infra/observability-entry.md`
  - `domains/development/standards-index.md`
  - `domains/operations/debug-workflow.md`
- Rewrote `knowledge/index.md` and all five domain overviews to act as stable entry pages instead of mixed-detail documents.
- Tightened `meican-copilot` routing guidance so it explicitly stays knowledge-first and uses micro skills only for repeatable execution.
- Added second-phase concrete anchors:
  - `domains/architecture/project-cards.md`
  - confirmed `planet-api` as a local historical HTTP API repo with `gin` route setup
  - confirmed a real `nacos://...` rollout config shape from app manifests
  - added stable `ops` observability anchors for `service-monitor.yaml` and `pagerduty.yaml`
- Expanded project-map/project-cards with broader workspace understanding:
  - clarified the role split between `/Users/zhanghang/go/src/go.planetmeican.com` and `/Users/zhanghang/meican`
  - added `developer/dapi-be` and `titan/web-apps/logclick-fe` as first-class cards
  - documented the repeated `nerds.k8s.meican.com/inject` + `nacos://...` runtime pattern across multiple repos
- Continued the second-phase expansion with more `/Users/zhanghang/meican` and support-service anchors:
  - added `planet-h5`, `meican-mp`, `meican-app-graphql`, and `client-cli` into project-map / project-cards
  - added `client-internal/member`, `planet/operator`, and `nation-client/client-be` as explicit backend/support cards
  - documented the `meican-app-graphql -> meican-bff` GraphQL/tooling relationship
  - expanded code-entry guidance for frontend + GraphQL/BFF style repos
- Corrected the Nacos/platform model with verified framework anchors:
  - Nacos should not be treated as a standalone business source-code repo in day-to-day project lookup
  - documented `nerds/app` and `nerds/app/v2` as the real bootstrap/config-center integration layer
  - added `nerds/app` and `nerds/app/v2` into project-map / project-cards
  - refined platform/observability docs to explain `--config nacos://...`, `--watch true`, and `nerds.k8s.meican.com/inject: true` via the framework path
- Tightened the default framework assumption:
  - local import sampling shows most business projects still depend on `go.planetmeican.com/nerds/app` v1
  - updated docs so agents default to v1 first, then only switch to `nerds/app/v2` when a concrete project clearly uses it
- Added a dedicated pattern reference for typical Go services:
  - `domains/development/typical-go-service-patterns.md`
  - distilled common structure from `nation-client/client`, `developer/dapi-be`, and `planet/planet`
  - documented the shared startup shape (`cmd/main.go -> nerds/app v1 -> easygo/gf boot -> domain/service/net`)
  - clarified the difference between domain-core services, gateway-like services, and large internal aggregators
- Added a more role-specific working map for your frequent projects:
  - `domains/architecture/owned-project-patterns.md`
  - connected `ops / planet / dapi-be / client / member / id-card / idmapping` into one practical reading/debug map
- Expanded second-batch project cards:
  - `fan`
  - `doorkeeper-fe`
  - `doorkeeper-api`
  - `meican-pay-checkout-bff`
  - enriched `ops`, `member`, and `id-card` cards with more structural hints
- Added a workspace-level contribution signal rule:
  - `domains/architecture/workspace-and-contribution-signals.md`
  - use “author name or email contains zhanghang” as the practical local git signal
  - explicitly treat it as a strong contribution/familiarity hint, not sole ownership proof
- Added a repo-family level entry page:
  - `domains/architecture/repo-family-map.md`
  - groups local company repos by family, role, and `zhanghang` contribution signal
- Expanded architecture cards and routing with more durable anchors:
  - added cards for `planet/project`, `api-center/protobufs`, `nation-client/client-proto`, `meican-cd/argocd-*`, `meican-cd/terraform-*`, and `nerds/app-cli`
  - updated `service-catalog.md`, `project-map.md`, and `knowledge/index.md` to make repo-family, proto-root, and platform-repo entry easier to find
- Added a dedicated `nerds/app + nacos` reference:
  - `domains/infra/nerds-app-and-nacos.md`
  - explains the default `nerds/app` v1 assumption, manifest patterns, and the standard config/debug reading order
- Expanded second-layer project coverage for payment and kiwi families:
  - added cards for `meican-pay/payment`, `meican-pay/subsidy`, `meican-pay/checkout`
  - added cards for `kiwi/baseinfo`, `kiwi/cafeteria`, `kiwi/order-system`, `kiwi/sso`
  - updated `repo-family-map.md`, `project-map.md`, and observability/platform docs to reflect their older/legacy service patterns
- Added `domains/development/repo-family-patterns.md` to distinguish how to read:
  - modern `planet/nation-client/developer` services
  - payment-domain services
  - older `kiwi/*` core systems
  - `bi/*` data/reporting repos
- Expanded BI coverage in `project-cards.md` with cards for:
  - `bi/mbi`
  - `bi/report`
  - `bi/export-report-job`
  - `bi/report-customizer`
  - `bi/data-management`
  - `bi/transformer`
  - `bi/redshift-management`
- Added `domains/architecture/topology-from-domain-dirs.md`:
  - captures the practical rule that many services expose cross-service topology directly via `internal/domain/*`
  - uses `planet/ops`, `planet/planet`, `developer/dapi-be`, `nation-client/id-card`, `client-internal/member`, and `planet/operator` as verified anchors
- Enriched key project cards with explicit domain-topology hints for:
  - `planet/ops`
  - `planet/planet`
  - `developer/dapi-be`
  - `nation-client/id-card`
  - `client-internal/member`
  - `planet/operator`
- Added `domains/development/proto-family-map.md`:
  - explains when to default to `api-center/protobufs`
  - and when to fall back to `nation-client/client-proto`, `planet-proto`, `project-proto`, `idmapping-proto`, `developer/proto`, etc.
- Expanded project cards with more explicit proto-repo anchors:
  - `planet/planet-proto`
  - `planet/project-proto`
  - `planet/idmapping-proto`
  - `developer/proto`
# 2026-04-02

- Continued the knowledge-base distillation work with a stronger `/Users/zhanghang/meican` frontend/BFF/SDK branch:
  - added `domains/development/frontend-bff-sdk-patterns.md`
  - documented how to read host FE, embedded SDK monorepos, GraphQL/codegen repos, frontend-adjacent Go APIs/BFF, and standalone observability UIs
  - anchored the guidance with verified local repos: `awesome-sdk`, `meican-app-graphql`, `user-management`, `bi-api`, `bi-api-app`, `solomon-fe`, and `logclick/logclick-fe`
- Expanded project coverage and navigation:
  - added project cards for `awesome-sdk`, `user-management`, `bi-api`, `bi-api-app`, `solomon-fe`, and `logclick/logclick-fe`
  - updated `project-map.md` so `/Users/zhanghang/meican` now includes frontend-adjacent Go APIs/BFF and more SDK/tooling repos
  - updated `repo-family-map.md` with additional `/Users/zhanghang/meican` high-value repos and explicit reading heuristics for FE/SDK/GraphQL/BFF categories
- Added a stable method doc for future knowledge growth:
  - `domains/development/code-distillation-method.md`
  - defines the canonical distillation order: repo family -> entrypoint -> `boot.go` -> `internal/domain/*` -> proto import -> manifests/platform config -> documentation
  - clarifies the writing split between facts, method, and examples
- Wired the new method back into the maintenance layer:
  - updated `domains/development/standards-index.md`
  - updated `knowledge/index.md`
  - updated `meta/contributing.md`
  - updated `meta/review-checklist.md`
- Continued expanding `/Users/zhanghang/meican` into a more complete working map:
  - added project cards for `meican-api-doc`, `meican-tui`, `iMeicanPay`, `aws-nginx-web`, `planet-nginx-v2`, and `bi-dbt`
  - expanded `project-map.md` with frontend-adjacent Go APIs/BFF, edge/nginx repos, data-modeling repos, and more `/Users/zhanghang/meican` anchors
  - expanded `repo-family-map.md` so these repos are visible in the `/Users/zhanghang/meican` family and carry the right reading heuristics
- Added a dedicated frontend/service topology page:
  - `domains/architecture/frontend-service-topology.md`
  - captures stable paths such as:
    - `planet-ops-frontend -> web-sdk-raven -> /v1/planet/*`
    - `宿主前端 -> meican-app-graphql -> meican-bff -> backend`
    - `logclick/logclick-fe -> log backend/contracts`
    - `aws-nginx-web / planet-nginx-v2` as edge/front-door layers
- Expanded `service-catalog.md` so the working set now includes:
  - FE/SDK toolkit (`awesome-sdk`)
  - developer docs portal (`meican-api-doc`)
  - internal TUI/CLI tooling (`meican-tui`)
  - edge/nginx repos (`aws-nginx-web`, `planet-nginx-v2`)
  - dbt/data-modeling family (`bi-dbt`)
- Added a durable `dapi-be` signature-debug reference:
  - `domains/operations/dapi-be-signature-debug.md`
  - captures v1/v2 sign-version selection, exact request payload rules, common failure modes, recommended `logclick` query path, and a suggested logging-improvement MR checklist
  - linked from `knowledge/index.md` and `domains/operations/overview.md`
  - also tightened `skills/logclick-debug/SKILL.md` so `dapi-be` signature failures default to “broad query -> local JSON cache -> `jq`/`rg`” instead of trying to filter nested raw fields in SQL first
