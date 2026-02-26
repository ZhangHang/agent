# Incident Workflow

## Intake Template
- Ticket ID:
- Environment:
- Time window (absolute time):
- Identifiers:
- Symptom:
- Expected behavior:

## Quick Trace Intake (No Ticket)
- Target service/repo:
- Method name:
- Known downstream services:
- Environment:
- Time window (absolute time):
- One concrete identifier:

## Execution Order
1. Confirm impact and blast radius.
2. Gather logs.
3. Gather traces.
4. Check data state.
5. Verify code and config path.
6. Prepare mitigation and rollback options.
7. Publish evidence-backed summary.

## Trace-only Execution Order
1. Locate entrypoint by method name.
2. Expand provider -> service -> domain chain.
3. Confirm RPC target keys in config.
4. Verify at least one runtime evidence anchor (log/trace/config).
5. Output ordered call chain with facts/inference tags.
