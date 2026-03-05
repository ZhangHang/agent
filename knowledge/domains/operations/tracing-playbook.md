# Tracing Playbook

## Scope
Cross-service tracing workflow for incident debugging.

## Procedure
1. Start from request-id/order-id/user-id and time range.
2. Query gateway/service logs to extract trace id.
3. Expand upstream/downstream spans.
4. Confirm failure boundary and first-error service.
5. Correlate with deploy version and config in target environment.

## Validation Checklist
- Root span and failing span identified.
- At least one causal chain documented.
- Service hop sequence matches runtime architecture.

## Linked Scripts
- `../../scripts/trace/trace_lookup.sh`
- `../../scripts/context/collect_context.sh`
