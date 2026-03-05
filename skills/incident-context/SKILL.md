---
name: incident-context
description: Build normalized incident/debug context and output contract using the collect_context helper.
---

# incident-context

## Trigger
Use when user needs incident context normalization before investigation.

## Workflow
1. Read contract: `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/operations/scripts/collect-context.md`.
2. Run script:
   - `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/collect_context.sh --env <sandbox|production|prod> --service <name> [--id <value>] [--from <ISO>] [--to <ISO>]`
3. Return result in incident output contract sections:
   - Summary
   - Scope and assumptions
   - Findings
   - Evidence anchors
   - Recommendation

## When Not To Use
- Do not use for service call-chain expansion; use `service-trace` instead.
