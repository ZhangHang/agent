# Common Failure Patterns

## dapi-be Gateway-First Failures
Typical middleware order before business logic:
1. response type
2. rate
3. authorization/sign
4. endpoint permission

Typical signals:
- `429`: rate-limit path.
- `401`: sign verification/auth.
- `403`: endpoint permission.
- `404` with route mismatch: method meta/proto annotation mismatch.

## Business Chain Anchors
- `planet` permission query chain: gateway -> grpc provider -> permission service.
- `dapi-be` subscription chain: gateway metadata resolution -> provider -> service.

## Recovery Pattern
1. identify failing gate
2. validate metadata/headers/config
3. rerun request with minimal reproducible payload
4. only then inspect business service logic
