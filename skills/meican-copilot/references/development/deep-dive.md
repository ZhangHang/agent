# Development Deep Dive

## Scope
Detailed implementation practices for Go microservices and grpc-gateway projects.

## Preconditions
- Confirm service type: gRPC only / gRPC + gateway / HTTP + internal gRPC.
- Confirm target proto repository strategy.

## Step-by-step Procedure
1. Bootstrap service skeleton via app CLI (`/Users/zhanghang/go/bin/app new`).
2. Define config layout (`dev/sandbox/prod/autotest`).
3. Define API contract in proto with compatibility checks.
4. Implement provider/service/domain layering.
5. Register gRPC and (if needed) gateway handlers.
6. Add tests and CI service dependencies.
7. Add deployment manifests and infra impacts.

## Required Dependencies (Go backend default)
- `go.planetmeican.com/easygo/gf/v2`
- `github.com/gogf/gf/v2`
- `github.com/samber/lo`

## Common Structure
- `cmd/`
- `config/{sandbox,dev,prod,autotest}`
- `internal/domain`
- `internal/dto`
- `internal/infra`
- `internal/model`
- `internal/net`
- `internal/service`
- `tests/`, `docker/`

## Discovery Checklist for Unfamiliar Service
1. `cmd/main.go`
2. `internal/net/grpc/server.go` + `register.go`
3. `internal/net/grpcgateway/*` (if exists)
4. provider under `internal/net/grpc/provider*`
5. related service in `internal/service`
6. related domains in `internal/domain`

## Test Flow (easygo/gf apps)
- Standard test contract: `GF_GCFG_PATH=$(PWD)/config/autotest`.
- Typical testdata bootstrap: postgres/mysql schema and local dependencies init.
- Keep local `make test` and CI `test:go_test` bootstrap equivalent.

## CI Service Mapping Examples
- `dapi-be`: postgres + redis.
- `nation-client/client`: postgres + mysql + redis + dynamodb.
- `planet/planet`: mostly config-driven go test.

## Known Drift/Risk
- Stale test bootstrap scripts in Makefile can diverge from repo reality.
- Fix by converging hidden CI setup into explicit Makefile/testdata steps.

## Failure Modes + Recovery
- Contract drift (proto vs implementation): regenerate and verify registry links.
- Missing gateway registration: verify `Register*HandlerFromEndpoint` paths.
- Business logic leaking into transport layer: move logic down to service/domain.

## Validation Checklist
- API contract verified.
- Interceptors/authorization impact checked.
- Provider/service/domain boundaries respected.
- CI test dependencies consistent with runtime dependencies.
- Deploy target repos identified (ArgoCD/Terraform).

## Linked Scripts
- `../../scripts/context/collect_context.sh`
- `../../scripts/context/trace_service_chain.sh`

## Change History
- 2026-02-24: initialized from backend standards and gateway playbooks.
- 2026-02-26: expanded backend delivery flow and easygo/gf test details.
