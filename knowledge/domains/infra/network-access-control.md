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
- `dapi-be` gRPC chain includes `errors -> validator -> meta -> grant`.
- `rate` interceptor exists in code but is not wired in unary chain.

## Change Procedure (Method + Caller)
1. Confirm gRPC full path (`/package.Service/Method`).
2. Update `AuthorizationPolicy` caller principal + method path.
3. Verify issuer/jwks per env.
4. If app-layer grant exists, update grant extraction/check rules.
5. Canary-validate allowed and denied calls.

## Egress Control Model
- `Sidecar`: egress allowlist boundary.
- `ServiceEntry`: host/port/protocol declaration.

Observed patterns:
- `dapi-be`: `ALLOW_ANY` + explicit host allowlist.
- `app-constraint`: `REGISTRY_ONLY` strict mode.

## Egress Dependency Change Checklist
1. Add host to `sidecar.yaml` allowlist.
2. Add host/port/protocol to `serviceentry.yaml`.
3. Separate env-specific hostnames (`sandbox`, `production`, `prod`).
4. In `REGISTRY_ONLY` mode, require `ServiceEntry` for every new external dependency.

## Common Failure Signals
- Timeout or 503 to external host: missing sidecar allowlist or missing ServiceEntry port.
- One environment broken only: host/account mismatch across `meican1` and `meican2`.
- DB reachable outside mesh but not in cluster: missing mesh egress objects.
