# Istio Egress: Sidecar + ServiceEntry Playbook (Legacy Detailed)

## Scope
- This playbook explains how to design and troubleshoot outbound access in mesh with `Sidecar` + `ServiceEntry`.
- Evidence is from:
  - `dapi-be` and `app-constraint` in both `argocd-sandbox` and `argocd-prod`.

## Model
- `Sidecar` controls which hosts workload can egress to (`spec.egress.hosts`).
- `ServiceEntry` defines external hosts/ports/protocols for Envoy service registry.
- In practice:
  - `Sidecar` = allowlist boundary.
  - `ServiceEntry` = endpoint/port declaration.

## Patterns Found

### Pattern A: `ALLOW_ANY` + explicit allowlist (`dapi-be`)
- `outboundTrafficPolicy.mode: ALLOW_ANY`.
- Still keeps explicit internal/external host list for control and clarity.
- ServiceEntry splits by port group:
  - web/https
  - postgres 5432
  - mysql 3306
  - redis 6379
  - custom grpc 10240.

### Pattern B: `REGISTRY_ONLY` strict mode (`app-constraint`)
- `outboundTrafficPolicy.mode: REGISTRY_ONLY`.
- Requires all outbound dependencies to exist in registry and allowlist.
- ServiceEntry includes aws domains + internal kong hostnames + db ports.

## Change Procedure (Add New Dependency)
1. Add host to `sidecar.yaml` under the service namespace prefix (`<namespace>/<host>` style).
2. Add/update `serviceentry.yaml` with exact host + port + protocol.
3. Keep env-specific hostnames separated (`sandbox`, `production`, `prod`).
4. If using `REGISTRY_ONLY`, treat `ServiceEntry` as mandatory for every new external endpoint.
5. Deploy and verify app logs and upstream reachability.

## Common Failure Signals
- timeout or 503 calling external host:
  - likely missing sidecar allowlist or missing ServiceEntry port.
- one env broken only:
  - likely hostname/account mismatch between `meican1` and `meican2`.
- DB reachable locally but not in cluster:
  - likely mesh egress objects missing.
