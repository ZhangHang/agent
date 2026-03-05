# Development Deep Dive

## Scope
Detailed implementation practices for Go microservices and grpc-gateway projects.

## Preconditions
- Confirm service type: gRPC only / gRPC + gateway / HTTP + internal gRPC.
- Confirm target proto repository strategy.

## Procedure
1. Bootstrap service skeleton via app CLI (`/Users/zhanghang/go/bin/app new`).
2. Define config layout (`dev/sandbox/prod/autotest`).
3. Define API contract in proto with compatibility checks.
4. Implement provider/service/domain layering.
5. Register gRPC and (if needed) gateway handlers.
6. Add tests and CI service dependencies.
7. Add deployment manifests and infra impacts.

## Real Anchors
- Common structure:
  - `cmd/`
  - `config/{sandbox,dev,prod,autotest}`
  - `internal/domain`
  - `internal/net`
  - `internal/service`
- Required dependencies:
  - `go.planetmeican.com/easygo/gf/v2`
  - `github.com/gogf/gf/v2`
  - `github.com/samber/lo`

## Failure Modes
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
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/collect_context.sh`
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/trace_service_chain.sh`

## Change History
- 2026-02-24: initialized from backend standards and gateway playbooks.
- 2026-02-26: expanded backend delivery flow and easygo/gf test details.
