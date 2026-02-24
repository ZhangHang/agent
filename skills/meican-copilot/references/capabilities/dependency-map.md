# Dependency Map

## Cross-service Calls (Seed)
- `dapi-be` -> `nation-client/client` (internal grpc calls in selected methods).
- `planet` -> internal permission/role dependencies.
- multiple services -> infra dependencies (redis/rds/pulsar/aws APIs).

## Scenario Chains
- Permission query chain (`planet`).
- Subscription and middleware chain (`dapi-be`).

## Maintenance Rule
Each new chain entry must include:
1. trigger path
2. call sequence
3. dependency boundary
4. failure hotspots
