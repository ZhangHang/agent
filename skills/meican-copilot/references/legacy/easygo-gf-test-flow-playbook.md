# easygo/gf App Test Flow Playbook (Legacy Detailed)

## Scope
- This playbook describes how test execution is wired for easygo/gf-based Go services.
- Evidence projects:
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`

## Standard `make test` Contract
- Core convention:
  - `GF_GCFG_PATH=$(PWD)/config/autotest`
- Common env vars:
  - `LOG_HANDLER=console`
  - optional `APP_CREDENTIALS` and `APP_CONFIG`
  - optional `AWS_LOCALSTACK` for dynamodb/sqs mocking.

## Required Test Config Files
- `config/autotest/config.toml`
- `config/autotest/credentials.toml`
- Expected content types:
  - app std components (`app.std.grpc`, `app.std.telemetry`, `app.std.tracer`)
  - dependency endpoints (`database`, `redis`, `dynamodb`, `queue`)
  - `osenv` test overrides.

## Test Data Bootstrap Pattern
- Recommended target: `testdata` in Makefile, then `test: testdata`.
- Typical actions:
  - load postgres schema
  - load mysql legacy schema/test data if needed
  - initialize localstack/dynamodb tables if used.

## CI Service Mapping

### `dapi-be`
- CI file: `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/.gitlab-ci.yml`
- Services:
  - postgres (`pg`)
  - redis (`redis`)
- Test command exports:
  - `GF_GCFG_PATH`, `APP_CREDENTIALS`, `APP_CONFIG`.

### `nation-client/client`
- CI file: `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/.gitlab-ci.yml`
- Services:
  - postgres (`pgsql`)
  - mysql (`mysql`)
  - redis (`redis`)
  - dynamodb (`dynamodb`)
- CI rewrites `doc/localstack/ddb.sh` to use endpoint-url and executes it.

### `planet/planet`
- CI file: `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet/.gitlab-ci.yml`
- No DB service dependency in current CI test job.
- Uses `GF_GCFG_PATH` + `go test` directly.

## Known Drift/Risk
- In `dapi-be`, `Makefile` references `doc/localstack/ddb.sh`, but that path is currently missing in repository tree.
- Recommendation:
  - either add script and localstack dependency explicitly
  - or remove stale call from `testdata` to avoid false failures.

## Practical Rule
- Keep local `make test` and CI `test:go_test` bootstrap steps equivalent.
- If CI passes only because of extra hidden setup, move that setup into `Makefile testdata`.
