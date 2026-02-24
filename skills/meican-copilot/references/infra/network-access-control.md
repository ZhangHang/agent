# Network and Access Control (Detailed)

## Scope
gRPC method/caller authorization and Istio egress controls.

## gRPC Access Model
Layer 1 (mesh):
- `RequestAuthentication` + `AuthorizationPolicy`.
- Method allow by `to.operation.paths`.
- Caller allow by `from.source.requestPrincipals`.

Layer 2 (app):
- gRPC interceptors enforce business/resource grants.

## Important Findings
- `dapi-be` gRPC chain currently includes `errors -> validator -> meta -> grant`.
- `rate` interceptor exists in code but is not wired in unary chain.

## Egress Control Model
- `Sidecar`: egress allowlist boundary.
- `ServiceEntry`: host/port/protocol declaration.

Observed patterns:
- `dapi-be`: `ALLOW_ANY` + explicit host allowlist.
- `app-constraint`: `REGISTRY_ONLY` strict mode.

## Change Checklist
1. Add/adjust caller principal and method path in authorization policy.
2. Verify env-specific issuer/jwks and cluster suffix.
3. Add host to `sidecar.yaml`.
4. Add host+port to `serviceentry.yaml`.
5. Validate allowed and denied paths with canary tests.
