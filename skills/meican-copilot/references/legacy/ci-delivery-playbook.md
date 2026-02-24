# CI Delivery Playbook (Legacy Detailed)

## Scope
- Repos inspected:
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/.gitlab-ci.yml`
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/.gitlab-ci.yml`
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/.gitlab-ci.yml`
  - `/Users/zhanghang/go/src/go.planetmeican.com/titan/web-apps/logclick-fe/.gitlab-ci.yml`

## Pattern A: Go backend (template-driven)

### Core characteristics
1. Most backend projects include shared jobs from `meican-cd/ci-template`.
2. Repo-level `.gitlab-ci.yml` mainly sets variables and overrides test/terraform jobs.
3. Standard stages are:
   - `init -> lint_test -> report -> terraform -> build_branch -> commit_branch_yaml -> release -> build_release`

### Common variables
- `PROJECT_NAME`, `REPO_NAME`, `GROUP_NAME`, `APP_NAME`
- These drive build/release template jobs and image naming.

### Test jobs
- Usually custom per project:
  - minimal unit test (`planet`)
  - integration-like test with containers (`dapi-be`, `nation-client/client`)
- `nation-client/client` starts `postgres/mysql/redis/dynamodb` in CI services and prepares schema/data before `go test`.

### Terraform jobs in app repo CI
- `terraform_sandbox` and `terraform_meican2` are manual.
- They run `terraform destroy && terraform apply` under `doc/terraform` in app repo.
- High-risk behavior: destructive before apply.

### `nation-client/client`: Grafana dashboard auto-provision
- CI file:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/.gitlab-ci.yml`
- In terraform jobs, CI loads Grafana credentials then applies Terraform:
  - `source $SANDBOX_GRAFANA_ENV_FILE` or `source $PRODUCTION_GRAFANA_ENV_FILE`
  - exports `GRAFANA_URL`, `GRAFANA_AUTH`
  - runs `terraform destroy/apply` in `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform`
- Terraform content provisions dashboards and alerts:
  - dashboard resource: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform/dashboard.tf`
  - alert rules: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform/alert_rule_group.tf`
  - provider/backend: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform/main.tf`
  - UID/folder and panel assembly: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform/locals.tf`
  - panel templates: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform/panels/*.json`
- Operational implication:
  - Dashboard/alert definition is IaC and recreated by CI terraform stage.
  - Stable `FOLDER_UID` and `DASHBOARD_UID` in `locals.tf` prevent accidental duplication.
  - Because job runs `destroy` first, manual edits in Grafana UI are not durable.

## Pattern B: Frontend (pipeline-defined in repo)

### `logclick-fe` flow
- stages:
  - `prepare -> lint -> build -> upload -> dockerize`
- both environments are handled in one pipeline with rules:
  - production: `main`/`release/*`/tag
  - sandbox: non-main branches (manual by default, auto when commit message contains `[deploy]`)
- artifacts uploaded to S3, then image built by Kaniko.

## Practical checklists

### New backend service CI checklist
1. Set `PROJECT_NAME/GROUP_NAME/APP_NAME` correctly.
2. Keep template includes aligned with project language/runtime.
3. Provide project-specific `test:go_test` if DB/Redis/mq fixtures are required.
4. Validate terraform job safety (avoid destroy/apply unless explicitly intended).
5. Ensure release jobs map to target env (`sandbox`, `prod`).

### New frontend service CI checklist
1. Separate sandbox/prod rules and runner tags.
2. Define S3 cache-control strategy for static assets.
3. Ensure Kaniko auth and ECR path by env.
4. Keep version/tag format deterministic.

## CI-to-CD boundary
- CI builds artifacts/images.
- ArgoCD repo handles deployment manifests and rollout strategy.
- Coupling must be validated:
  - image path/tag
  - env branch rules
  - argocd manifest update mechanism (template `commit_branch_yaml` jobs for Go repos).
