# gRPC Gateway Playbook

## Purpose
Provide implementation standards for Meican grpc-gateway services based on existing projects (`planet`, `dapi-be`, related proto repos).

## Canonical Implementation Pattern
1. Define HTTP mapping in proto via `google.api.http`.
2. Generate gateway code (`*.pb.gw.go`) from proto repo.
3. Register handlers in gateway server with `Register*HandlerFromEndpoint`.
4. Route HTTP to local gRPC service address.
5. Keep auth/permission logic on gRPC side; gateway handles transport, headers, response formatting, and middleware.

## Proto-Side Requirements
- Import:
  - `google/api/annotations.proto`
  - `protoc-gen-openapiv2/options/annotations.proto`
- Add per-method HTTP mapping:
```proto
option (google.api.http) = {
  post: "/v1/xxx"
  body: "*"
};
```
- Add swagger/openapi operation metadata where needed.

## Server Wiring Pattern
Observed in `planet` and `dapi-be`:
- `cmd/main.go` starts:
  - gRPC server
  - grpc-gateway server
  - optional http server and jobs
- `internal/net/grpc/register.go` registers providers.
- `internal/net/grpcgateway/register.go` registers generated gateway handlers.

## Gateway Middleware Responsibilities
Common responsibilities:
- CORS
- OTel tracing and carrier propagation (`x-mc-carrier`)
- health endpoint exposure (`/health-check`)
- incoming/outgoing header mapping
- custom error shape conversion
- optional authorization/rate-limit/response-shape middleware (`dapi-be`)

## Two Styles In Current Repos

### `planet` style
- Explicit handler registration list in `internal/net/grpcgateway/register.go`
- Centralized error conversion using API code and grpc status
- Header whitelist mapping and trace carrier injection

### `dapi-be` style
- Dynamic registration via `internal/service/proto` metadata service
- Service/Method metadata (sign version, response type, method type) extracted from proto options
- Middleware chain includes response naming mode, rate-limit, authorization, endpoint routing
- Pre-business failure points are common: sign verification, rate-limit, auth and metadata parsing often fail before provider/service logic

## `planet` vs `dapi-be` Debug Priority
- `planet`: usually start from provider/service/domain behavior and permission data.
- `dapi-be`: first clear gateway/middleware gates, then enter business logic.
- Detailed quick triage for `dapi-be`:
  - `references/dapi-be-gateway-failure-playbook.md`

Recommended order for `dapi-be`:
1. Confirm route -> proto metadata mapping is correct.
2. Check sign verification result and required headers/fields.
3. Check rate-limit decision (key, quota, window).
4. Check authorization/method policy.
5. Only then inspect provider -> service -> domain logic.

## Business Logic Layering Rule
- Provider (`internal/net/grpc/provider*`): transport adaptation only.
- Service (`internal/service/*`): business orchestration.
- Domain (`internal/domain/*`): external system and data access abstraction.
- Do not put business rules in gateway layer.

## Common Pitfalls and Fixes
1. New RPC not exposed via HTTP
- Cause: missing `google.api.http` or missing `Register*HandlerFromEndpoint`.
- Fix: update proto annotations, regenerate code, ensure register list includes service.

2. HTTP response code/body mismatch
- Cause: gateway error handler/response modifier not aligned.
- Fix: standardize `WithErrorHandler` and response schema mapping.

3. Header-based auth/context lost
- Cause: header matcher not whitelisting required headers.
- Fix: update incoming/outgoing header matcher whitelist.

4. Traces disconnected between HTTP and gRPC
- Cause: missing carrier propagation or metadata injection.
- Fix: inject/extract carrier (`x-mc-carrier`) and keep otel middleware enabled.

5. gRPC interceptors not taking effect in gateway direct mode
- Cause: generated warning scenario when not using endpoint registration correctly.
- Fix: use `Register*HandlerFromEndpoint` and middleware on ServeMux as needed.

6. `dapi-be` sign verification failure
- Cause: missing/incorrect sign headers, timestamp drift, wrong sign version config.
- Fix: verify proto method sign meta + request canonicalization + gateway sign middleware config.

7. `dapi-be` rate-limit rejection
- Cause: wrong key extraction, environment-specific quota mismatch, shared key hot spot.
- Fix: verify middleware key strategy and limit config in target environment before touching business code.

## Validation Checklist (Before Merge)
1. Proto has HTTP annotations and passes compile/lint.
2. Gateway handler registered.
3. gRPC provider registered.
4. Auth/grant path covered in gRPC interceptors.
5. Error codes match expected API contract.
6. Health endpoint works.
7. One integration call validated end-to-end (HTTP -> gateway -> gRPC -> service/domain).
