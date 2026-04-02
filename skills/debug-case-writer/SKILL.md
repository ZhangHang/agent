---
name: debug-case-writer
description: Turn a real debugging round into a reusable markdown case with commands, evidence, facts, inference, and next-step guidance.
---

# debug-case-writer

## Trigger
Use when the task is to turn a real debug session into a reusable markdown case, especially when:
- prod or sandbox logs were queried for a concrete incident
- a trace was followed across services
- a card, user, method, or order case should be documented
- future agents should be able to replay the investigation quickly

## Goal
Produce a case note that helps future debugging, not a narrative dump.

## Core Structure
Write the case in Markdown with these sections:
1. scope
2. recommended query path
3. key identifiers
4. facts from logs
5. downstream flow
6. code anchors
7. confirmed filtering / failure reasons
8. inference and open gaps
9. next reuse notes

## Required Content

### Scope
State:
- what was investigated
- time window
- environment
- why the case matters

### Recommended query path
Prefer a 1-2 round pattern:
- round 1: entry query to find the trace or key request
- round 2: full trace query with the fields needed for analysis

If helpful, include a local cache command such as:
- `logclick query run --json ... > /tmp/<case>.json`
- then `jq` on the saved file

### Key identifiers
Capture the fields a future agent can pivot on:
- trace id
- card code
- user id
- client member id
- method
- mealplan id
- order id

### Facts from logs
List only directly observed facts:
- request fields
- reply fields
- methods called
- services involved
- explicit error or filter logs

### Downstream flow
Show the ordered service/method chain.
Prefer deriving the first draft from:
- `internal/domain/*`
- `boot.go`
- proto imports
before turning it into a final verified chain from logs/trace.
If the path crosses frontend/BFF/SDK repos, also consult:
- `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/development/frontend-bff-sdk-patterns.md`

### Code anchors
Point to the service/proto/code files that explain the behavior.
Prefer including:
- provider/service entry
- one or two `internal/domain/*` clients that expose the topology
- the proto file family actually used by the code

### Confirmed reasons
Only put a reason here if it is directly supported by logs or code behavior for this path.

### Inference and open gaps
Explicitly label what is inferred rather than observed.

## Style Rules
- Facts first, inference second.
- Keep command examples copyable.
- Prefer `logclick query run` examples over prose.
- Prefer exact method names.
- Prefer exact trace ids and ids if the case is about one concrete run.
- Do not hide uncertainty.

## Good Case Outcomes
A future agent should be able to:
- rerun the same queries quickly
- understand what happened upstream and downstream
- know which facts are already confirmed
- know where to look next in code or proto

## Optional Follow-Up
If the case changed the preferred workflow, ask whether the durable reference or a micro skill should also be updated.
