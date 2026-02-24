# gRPC and gRPC-Gateway Standard

## Scope
Detailed standard for defining, exposing, and validating gRPC + HTTP gateway APIs.

## Preconditions
- Access to target app repository.
- Access to target proto repository.

## Step-by-step Procedure
1. Define HTTP mapping in proto using `google.api.http`.
2. Generate gateway code (`*.pb.gw.go`).
3. Register handlers through `Register*HandlerFromEndpoint`.
4. Ensure gRPC providers are registered in server register path.
5. Keep authorization/grant logic in gRPC interceptors, not in gateway transport layer.
6. Validate end-to-end path: `HTTP -> gateway -> gRPC -> provider -> service -> domain`.

## Real Examples
- `planet` style:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpcgateway/register.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/internal/net/grpc/register.go`
- `dapi-be` style (dynamic metadata + middleware-heavy):
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/register.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/service/proto/proto.go`

## Failure Modes + Recovery
- New RPC not exposed via HTTP:
  - Check proto annotation + gateway register list.
- Header/context missing in downstream service:
  - Check incoming/outgoing header matcher and metadata injection.
- Early failures before business logic in `dapi-be`:
  - Check sign/rate/authorization/endpoint middlewares first.

## Validation Checklist
- Proto annotation complete.
- Generated gateway code exists.
- Gateway register and gRPC register both updated.
- Auth/grant chain validated.
- One integration call verified end-to-end.

## Linked Scripts
- `../../scripts/context/collect_context.sh`
- `../../scripts/log/search_logs.sh`

## Change History
- 2026-02-24: migrated from legacy `grpc-gateway-playbook.md` and incident findings.
