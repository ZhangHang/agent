# CI/CD Playbook (Detailed)

## Scope
Detailed CI/CD patterns for backend/frontend services and app-level terraform stages.

## Base Image Source of Truth
- Base image repository root:
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/base-images`

## Backend Pattern
- Common stage chain:
  - `init -> lint_test -> report -> terraform -> build_branch -> commit_branch_yaml -> release -> build_release`
- Most services include templates from `meican-cd/ci-template`.

## Base Image Upgrade Workflow
1. Confirm target tags exist in `titan/base-images`.
2. Update build Dockerfiles first, then CI `test:go_test` image if needed.
3. If `with-db-clients` tag does not exist, use base tag and install required clients in `before_script`.
4. Keep DB/bootstrap scripts idempotent.
5. Validate with `make lint` and project test flow.

## Branch and Commit Rule
- Branch naming for campaign: `chore/*`
- Commit prefix for CI tagging requirement: `fix:`

## Test Service Patterns
- `dapi-be`: postgres + redis.
- `nation-client/client`: postgres + mysql + redis + dynamodb.
- `planet`: go test with autotest config.

## Terraform Stage Risk
- High-risk pattern: `terraform destroy && terraform apply`.
- Rollback pattern:
  1. restore previous manifest/config commit.
  2. reapply with validated env vars.
  3. run canary validation.

## nation-client/client Grafana IaC in CI
- Terraform under:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform`
- Resources include dashboard and alert rules.
- Stable dashboard/folder UIDs reduce duplication.
- UI manual edits are not source-of-truth when terraform manages these resources.

## Frontend Pattern (`logclick-fe`)
- Typical stages:
  - `prepare -> lint -> build -> upload -> dockerize`
- Branch/tag rules split sandbox and production behavior.
- S3 artifacts + Kaniko image build pattern.

## CI-to-CD Boundary
- CI builds artifacts/images.
- ArgoCD repo controls deployment manifests and rollout strategy.
- Validate coupling: image path/tag, env branch rules, manifest update mechanism.

## Lint Mismatch Troubleshooting
- CI lint may differ from local `make lint` due to shared template behavior.
- Keep `.golangci.yml` aligned with template checks.
- For callback closures, rename unused params to `_` to satisfy revive.
- For intentional test dot-imports, use scoped revive suppression in test files.
