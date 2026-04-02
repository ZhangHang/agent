---
name: knowledge-maintainer
description: Turn a real investigation or delivery round into stable knowledge-base updates, minimal skill updates, and changelog entries.
---

# knowledge-maintainer

## Trigger
Use when the task is to update shared work knowledge after real execution, for example:
- a prod debug round produced reusable facts
- a new workflow or command pattern should be documented
- a domain reference should be expanded
- a micro skill should be tightened after repeated usage
- the inbox changelog should record a meaningful knowledge update

## Goal
Convert one real round of work into durable shared knowledge without turning the knowledge base into a raw work log.

## Workflow
1. Start from the existing domain entry:
   - `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/index.md`
   - then the relevant domain overview under `knowledge/domains/.../overview.md`
   - when the update comes from code reading, follow `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/domains/development/code-distillation-method.md`
2. Separate output into three layers:
   - stable domain knowledge
   - repeatable execution workflow
   - one-off case evidence
3. Update the smallest correct set of artifacts:
   - domain reference in `knowledge/domains/...`
   - a micro skill in `skills/...` only if execution guidance changed
   - `knowledge/inbox/changelog.md`
4. Keep facts and inference separate.
5. Only write what a future agent can reuse.
6. Prefer knowledge docs over skill expansion; keep skills thin.

## Write Targets

### 1. Domain knowledge
Put durable facts in `knowledge/domains/...`:
- service flow
- query pattern
- code anchor
- protocol or data model anchor
- stable failure mode
- stable debug strategy

Good fits:
- playbooks
- debug references
- overviews

Do not dump raw investigation timelines here unless they teach a reusable pattern.

### 2. Skill updates
Update a skill only when the execution behavior changed, for example:
- the preferred query template changed
- a new default field set is now standard
- a 1-2 round query pattern proved better
- a new proto lookup order is now standard

Keep skills thin:
- trigger
- workflow
- defaults
- output style

Do not duplicate long reference content inside a skill.

### 3. Case artifacts
Put one-off but useful case writeups in:
- `/Users/zhanghang/repo/obsidian/shared/agent/knowledge/inbox/`

Use them for:
- concrete prod investigations
- a specific card / user / trace / method case
- evidence-heavy reports

Then link or summarize them from the durable domain reference if the case teaches a reusable pattern.

## Update Rules
- Prefer updating an existing reference before creating a new top-level document.
- Create a new case note only when the concrete example is worth reusing.
- Update the skill only if a future agent should execute differently.
- Always add a short entry to `knowledge/inbox/changelog.md`.
- Do not include TUI or unrelated product guidance in a CLI/debug skill update.

## Output Shape
When using this skill, aim to produce:
1. one durable domain update
2. one minimal skill update if needed
3. one inbox case note if the concrete run matters
4. one changelog entry

## Quality Bar
The result should let a future agent answer:
- what happened
- what is reusable
- what command/query pattern should be preferred next time
- where to find the concrete evidence
