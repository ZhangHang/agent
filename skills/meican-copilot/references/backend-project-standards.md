# Backend Project Standards

## Purpose
Define practical standards for creating and maintaining backend services in Meican projects.

## Project Bootstrap Standard
Use app CLI scaffold first:

```bash
/Users/zhanghang/go/bin/app new
```

CLI capability summary:
- `new`: initialize project skeleton
- `protoc`: compile protobuf
- `doc`: generate swagger json
- `run`: local hot-compile-like run
- `sqlgen`: generate dao

## Required Core Dependencies
For new Go backend services, prefer:
- `go.planetmeican.com/easygo/gf/v2`
- `github.com/gogf/gf/v2` and related drivers
- `github.com/samber/lo`

Common in existing services:
- gRPC middleware
- OpenTelemetry / tracing integration

## Standard Repository Layout
Observed common structure in `client`, `dapi-be`, `planet`, `app-constraint`:

- `cmd/` entrypoint
- `config/{sandbox,dev,prod,autotest}`
- `internal/`
- `internal/domain`
- `internal/dto`
- `internal/infra`
- `internal/model`
- `internal/net`
- `internal/service`
- `doc/`
- `docker/`
- `argo-sandbox/helm`
- `tests/`

Optional by project:
- `build/`
- `deployments/`
- `internal/job` or `internal/jobs`
- `internal/vo`

## Network Mode Standards
- Internal service communication: gRPC first.
- External API: HTTP, often via grpc-gateway in gateway projects.
- Route and gateway context should be explicit in docs:
  - `nginx/openresty` and `kong` for EKS path
  - Route53/OpenResty/ECS and API Gateway/Lambda for legacy path

## New Service Checklist
1. Create scaffold with `app new`.
2. Define config directories for all environments.
3. Set up CI/lint (`.golangci.yml`, `.gitlab-ci.yml`).
4. Add tracing and logging baseline.
5. Add API/proto and doc generation flow.
6. Add tests (`tests/sql`, mocks, testdata as needed).
7. Add deployment files (`argo-sandbox`, docker).

## Sample Repositories
- gRPC structure and heavy `lo` + `easygo/gf`:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`
- HTTP backend variant with proto project:
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`
- grpc-gateway style with standalone proto:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet-proto`
- Service using central protobuf:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/app-constraint`
  - `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`
