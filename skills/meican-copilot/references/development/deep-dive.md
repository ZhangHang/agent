# Development Deep Dive

## Scope
Detailed implementation practices for Go microservices and grpc-gateway projects.

## Preconditions
- Confirm service type: gRPC only / gRPC + gateway / HTTP + internal gRPC.
- Confirm target proto repository strategy.

## Step-by-step Procedure
1. Bootstrap service skeleton via app CLI.
2. Define config layout (`dev/sandbox/prod/autotest`).
3. Define API contract in proto with compatibility checks.
4. Implement provider/service/domain layering.
5. Register gRPC and (if needed) gateway handlers.
6. Add tests and CI service dependencies.
7. Add deployment manifests and infra impacts.

## Real Examples
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`

## Failure Modes + Recovery
- Contract drift (proto vs implementation): regenerate and verify registry links.
- Missing gateway registration: verify `Register*HandlerFromEndpoint` paths.
- Business logic leaking into transport layer: move logic down to service/domain.

## Validation Checklist
- API contract verified.
- Interceptors/authorization impact checked.
- Provider/service/domain boundaries respected.
- CI test dependencies consistent with runtime dependencies.

## Linked Scripts
- `../../scripts/context/collect_context.sh`

## Change History
- 2026-02-24: initialized from legacy standards and gateway playbooks.
