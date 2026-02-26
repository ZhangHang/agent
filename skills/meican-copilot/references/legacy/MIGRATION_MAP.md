# MIGRATION MAP (Legacy -> New Domains)

Status legend:
- `done`: migrated with detailed content in new docs.
- `in-progress`: partially merged, keep legacy as source backup.
- `todo`: not merged yet.

Tracking:
- execution checklist and current queue: `TODO.md`

## Wave 1
- `logclick-fe-api-playbook.md` -> `../operations/log-query-playbook.md` (`done`)
- `grpc-gateway-playbook.md` -> `../development/grpc-gateway-standard.md` (`done`)
- `grpc-method-caller-authorization-playbook.md` -> `../infra/network-access-control.md` (`done`)
- `ci-delivery-playbook.md` -> `../infra/ci-cd-playbook.md` (`done`)
- `easygo-gf-test-flow-playbook.md` -> `../infra/ci-cd-playbook.md` (`done`)
- `webapp-mq-pulsar-playbook.md` -> `../infra/observability-playbook.md` (`done`)

## Wave 2
- `app-bootstrap-terraform-argocd-playbook.md` -> `../infra/terraform-playbook.md`, `../infra/argocd-playbook.md`, `../templates/app/bootstrap-checklist.md` (`in-progress`)
- `business-chains.md` -> `../capabilities/dependency-map.md`, `../operations/common-failure-patterns.md` (`in-progress`)
- `dapi-be-gateway-failure-playbook.md` -> `../operations/common-failure-patterns.md` (`in-progress`)

## Wave 3
- `environments.md` -> `../infra/environments.md` (`done`)
- `platform-architecture.md` -> `../architecture/overview.md`, `../architecture/deep-dive.md` (`done`)
- `codebase-roots.md` -> `../architecture/deep-dive.md` (`done`)
- `deploy-infra-roots.md` -> `../architecture/deep-dive.md`, `../infra/environments.md` (`done`)
- `backend-project-standards.md` -> `../development/deep-dive.md` (`in-progress`)
- `engineering-delivery-playbook.md` -> `../development/deep-dive.md` (`in-progress`)
- `proto-strategy.md` -> `../development/proto-strategy.md` (`done`)


## Additional Legacy Preserved
- `database-policy.md` -> `../operations/db-query-policy.md` (`done`)
- `ticket-template.md` -> `../templates/incident/ticket-template.md` (`done`)
- `work-modes.md` -> merged into `../../SKILL.md` execution sections (`in-progress`)
- `knowledge-growth.md` -> planned for domain update workflow in `../CONTRIBUTING.md` + `../CHANGELOG.md` (`in-progress`)
