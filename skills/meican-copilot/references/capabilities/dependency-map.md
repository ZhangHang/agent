# Dependency Map

## Cross-service Calls
- `dapi-be` -> `nation-client/client` (selected internal grpc calls).
- `planet` -> internal permission/role dependencies.
- `planet/ops` verify flow -> `member` + `id-card` + `idmapping` (+ conditional `id-card-adapter`).
- multiple services -> infra dependencies (redis/rds/pulsar/aws APIs).

## Chain A: `planet` Permission Query
### Entry
- proto route in `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto/v1/planet_service.proto`
- method: `ListPermissions`

### Runtime Path
1. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/cmd/main.go`
2. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpcgateway/register.go`
3. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpc/register.go`
4. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpc/providerv1/planet.go`
5. `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/service/permission.go`

## Chain B: `dapi-be` Subscription v4
### Runtime Path
1. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/cmd/main.go`
2. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/service/proto/proto.go`
3. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/register.go`
4. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpc/register.go`
5. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpc/provider/subscription/v4.go`
6. `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/service/subscription/subscription_v4.go`

## Chain C: Dine-in Verify (`planet/ops`)
### Trigger
- gRPC `InternalService.VerifyDineInOrder`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/net/grpc/provider/internal.go:21`

### Call Sequence
1. `provider` -> `service.DineIn.UnionVerify`
2. `PrepareIdentity` -> `idmapping.GetCombineID` + `member.MustGetClientMember`
3. card path -> `id-card.GetIDCardDetails` / `id-card.GetElectricCardIdentity`
4. verify stage -> `member.IsAllowOrder`
5. conditional adapter card source -> `id-card-adapter.ListIdentities`

### Key Anchors
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/service/dinein.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/member/member.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/idmapping/idmapping.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/id_card/id_card.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card/internal/application/card/impl_card/adapter_card/adapter_card.go`

## Maintenance Rule
Each new chain entry must include:
1. trigger path
2. call sequence
3. dependency boundary
4. failure hotspots
