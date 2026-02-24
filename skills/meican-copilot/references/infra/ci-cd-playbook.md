# CI/CD Playbook (Detailed)

## Scope
Detailed CI/CD patterns for backend/frontend services and app-level terraform stages.

## Base Image Source of Truth
- Base image repository root:
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/base-images`
- Use this repo to:
  - verify available image tags
  - trace image Dockerfile and dependency updates
  - align service Dockerfiles and CI images with security baseline

## Backend Pattern
- Common stage chain:
  - `init -> lint_test -> report -> terraform -> build_branch -> commit_branch_yaml -> release -> build_release`
- Most services include templates from `meican-cd/ci-template`.

## Test Service Patterns
- `dapi-be`: postgres + redis.
- `nation-client/client`: postgres + mysql + redis + dynamodb.
- `planet`: go test with autotest config, no extra DB service currently.

## `nation-client/client` Grafana IaC in CI
- CI terraform jobs load:
  - `SANDBOX_GRAFANA_ENV_FILE` or `PRODUCTION_GRAFANA_ENV_FILE`
  - `GRAFANA_URL`, `GRAFANA_AUTH`
- Then run terraform under:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform`
- Managed resources include:
  - `grafana_dashboard`
  - `grafana_rule_group`

## Frontend Pattern (`logclick-fe`)
- Typical stages:
  - `prepare -> lint -> build -> upload -> dockerize`
- Branch/tag rules split sandbox and production behavior.

## Risk and Rollback
- High-risk pattern: `terraform destroy && terraform apply`.
- Recommended rollback:
  1. Restore last known manifest/config commit.
  2. Reapply terraform with validated vars.
  3. Re-run canary validation.
