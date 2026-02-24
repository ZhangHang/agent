# Engineering Delivery Playbook

## Purpose
Define how to develop like an on-project engineer: follow structure, respect contracts, and proactively control risk.

## Development Flow Standard
1. Confirm target environment (`sandbox` / `meican1` / `meican2`) and deployment path.
2. Confirm service type:
- gRPC only
- gRPC + grpc-gateway
- HTTP + internal gRPC integration
3. Confirm proto strategy:
- default central proto (`api-center/protobufs`)
- exception standalone proto (`planet-proto`, `developer/proto`)
4. Implement with layering:
- provider -> service -> domain
5. Verify deployment/infra impact:
- ArgoCD repo by env
- Terraform repo by env
6. Run validation checklist before merge.

## File Structure Expectations
From `planet`, `dapi-be`, `nation-client`:
- `cmd/main.go`: startup + boot + server composition
- `internal/net/grpc/*`: server, interceptors, provider register
- `internal/net/grpcgateway/*`: gateway setup and register (if gateway project)
- `internal/service/*`: business use-case orchestration
- `internal/domain/*`: external dependency integration
- `config/{sandbox,dev,prod,autotest}`
- `docker/`, `argo-sandbox/`, `tests/`

## Business Logic Discovery Checklist
For any unfamiliar service, inspect in order:
1. `cmd/main.go`
2. `internal/net/grpc/server.go` and `register.go`
3. `internal/net/grpcgateway/server.go` and `register.go` (if exists)
4. key provider file under `internal/net/grpc/provider*`
5. corresponding service file in `internal/service`
6. corresponding domain dependencies in `internal/domain`

## Risk Patterns and Mitigation
1. Contract drift between proto and implementation
- Mitigation: regenerate proto artifacts and verify register tables.

2. Permission/auth regression
- Mitigation: check gRPC interceptor chain and method grant rules.

3. Env-specific deployment mismatch
- Mitigation: inspect ArgoCD repo for target env and confirm chart/value mapping.

4. Legacy route confusion (EKS vs ECS/Lambda)
- Mitigation: map request path first (`kong/nginx` vs `route53/openresty` vs `api gateway`).

5. Data-level false conclusions
- Mitigation: require at least two evidence sources (logs + trace, trace + DB, etc.).

## What To Do When Automation Is Missing
When no direct API/CLI is available:
1. Provide manual runbook steps with exact commands.
2. Provide production-safe SQL suggestions with reasons and expected output.
3. Ask user to execute and return evidence.
4. Continue analysis with returned results.

## PR Readiness Checklist
1. Interface contract checked (proto/http path/result code).
2. Interceptor and permission impact checked.
3. Gateway registration checked.
4. Backward compatibility and legacy paths considered.
5. Deploy target repos identified (ArgoCD/Terraform).
6. Rollback strategy documented.
