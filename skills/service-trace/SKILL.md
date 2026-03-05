---
name: service-trace
description: Trace service call-chain anchors by service and method using trace_service_chain helper.
---

# service-trace

## Trigger
Use when user asks to trace service method flow, upstream/downstream chain, or provider/service/domain anchors.

## Workflow
1. Read contract: `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/operations/scripts/trace-service-chain.md`.
2. Run script:
   - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/trace_service_chain.sh --service <service-path> --method <method-name> [--repo-root <path>] [--max-lines <n>]`
3. Output:
   - ordered chain anchors
   - facts vs inference split
   - unresolved gaps

## When Not To Use
- Do not use for incident context normalization; use `incident-context`.
