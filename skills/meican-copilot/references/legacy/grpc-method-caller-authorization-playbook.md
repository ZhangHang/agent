# gRPC Authorization: Method + Caller Playbook (Legacy Detailed)

## Scope
- This playbook defines the layered authorization model for internal gRPC calls.
- Evidence comes from:
  - Istio policies in `meican-cd/argocd-*`
  - app interceptors in `dapi-be` and `planet`

## Layered Model

### Layer 1: Mesh authorization (caller identity + method path)
- `RequestAuthentication` validates JWT and maps `requestPrincipal`.
- `AuthorizationPolicy` allows specific caller principals to specific gRPC paths.
- Typical rule structure:
  - `from.source.requestPrincipals`: caller identity (`issuer/service@cluster`)
  - `to.operation.paths`: allowed gRPC methods (`/package.Service/Method`)

### Layer 2: Application authorization (business permission)
- `dapi-be` interceptor chain:
  - `errors -> validator -> meta -> grant`
- `meta` extracts caller/developer metadata and injects operator context.
- `grant` enforces resource-level permission based on request payload fields.

## Important Finding
- `dapi-be` has a `rate` interceptor implementation but it is not currently wired in unary interceptor chain.
- Impact: rate-limit logic exists in code but is not active unless added to chain.

## Planet-Specific Grant Mode
- `planet` performs method-level grant via proto extension `pb.E_Grant`.
- Permission contract can be attached directly to method descriptor in proto options.

## Change Procedure (Add/Adjust Caller Access)
1. Confirm target gRPC full method path (`/package.Service/Method`).
2. Update `AuthorizationPolicy` rule:
   - add caller principal under `from`
   - add method under `to.operation.paths`.
3. Confirm `RequestAuthentication` issuer/jwks for target env.
4. If service has app-layer grant:
   - update request resource extraction or grant checks as needed.
5. Validate with canary caller:
   - expected success on allowed method
   - expected `PermissionDenied` on disallowed method.

## Common Pitfalls
- Method path typo (missing leading `/`, wrong service name, wrong package version).
- Principal copied from wrong environment cluster suffix.
- Mesh policy opened, but app grant still denies.
- App grant opened, but mesh policy still blocks before reaching app code.
