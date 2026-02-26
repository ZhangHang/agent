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

## Base Image Upgrade Workflow
1. Confirm target tags exist in:
   - `/Users/zhanghang/go/src/go.planetmeican.com/titan/base-images`
2. Update build Dockerfiles first (`docker/Dockerfile_*`), then CI `test:go_test` image.
3. If `with-db-clients` tag does not exist, switch to non-db tag and install required clients in `before_script`:
   - `postgresql-client` for `psql`
   - `mysql-client` for `mysql`
4. Keep DB/bootstrap scripts idempotent:
   - `DROP TABLE IF EXISTS ...`
   - ignore `delete-table` not-found for local dynamodb init
5. Validate:
   - `make lint`
   - project test command (or CI equivalent)
   - checkstyle/revive output alignment

## Branch and Commit Rule
- Branch naming for this campaign:
  - `chore/upgrade-base-image`
- Commit message prefix requirement (CI tagging rule):
  - use `fix:` instead of `chore:`

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

## Lint Mismatch Troubleshooting
- Symptom:
  - CI `checkstyle`/`revive` reports differ from local `make lint`.
- Root causes:
  - `lint` job behavior comes from shared template (`meican-cd/ci-template`), not always identical to local `Makefile`.
  - Some template checks are stricter for callback parameters and test imports.
- Fix pattern:
  1. Verify what CI lint actually runs from included template files.
  2. Keep local `.golangci.yml` aligned with CI expectations.
  3. For callback closures (for example `boot.NewOption`), rename unused parameters to `_` to satisfy `revive` `unused-parameter`.
  4. If tests intentionally use dot imports (`ginkgo/gomega`), scope suppression explicitly in test files with:
     - `//revive:disable:dot-imports`
     - `//revive:enable:dot-imports`
  5. Run formatter before lint:
     - `golangci-lint fmt ./...`
