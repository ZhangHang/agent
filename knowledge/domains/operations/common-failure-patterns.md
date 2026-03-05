# Common Failure Patterns

## dapi-be Gateway-First Failures
Typical middleware order before business logic:
1. response type
2. rate
3. authorization/sign
4. endpoint permission

Typical signals and first checks:
1. `429` / rate-limit
- `internal/net/grpcgateway/middleware/rate/rate.go`
- validate method type match, developer identity extraction, limiter key, env quota config.
2. `401` / sign verification
- `internal/net/grpcgateway/middleware/authorization/*`
- validate sign version, timestamp skew, nonce replay, signed payload bytes.
3. `403` / endpoint permission
- `internal/net/grpcgateway/middleware/endpoint/endpoint.go`
- validate endpoint mapping and developer/team permission grant.
4. `404` / route not matched
- validate proto HTTP annotation and runtime mapping metadata.

## Business Chain Anchors
- `planet` permission query chain:
  - proto route -> gateway register -> grpc register -> provider -> service.
- `dapi-be` subscription chain:
  - gateway metadata resolution -> middleware gates -> provider -> service.
- `planet/ops` verify dine-in chain:
  - `VerifyDineInOrder` -> identity prep -> `member`/`idmapping`/`id-card` (conditional `id-card-adapter`).

## Recovery Pattern
1. Identify failing gate or chain node.
2. Validate metadata/headers/config first.
3. Rerun with minimal reproducible payload.
4. Only then inspect deeper business service logic.

## Evidence Collection Order
1. Fix environment and absolute time window.
2. Capture request path + response code + response message.
3. Capture relevant headers (redact secrets).
4. Confirm fail point in middleware/registration/business layer.
5. Correlate with logs and traces.
