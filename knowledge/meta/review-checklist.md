# Weekly Review Checklist

## Daily Flow
1. Append new findings to `../inbox/changelog.md`.
2. Include date, scope, and at least one concrete anchor.

## Weekly Merge Flow
1. Group inbox entries by domain.
2. Merge stable items into `../domains/*` docs.
3. Update `../index.md` when routing changes.
4. Validate script contracts and active/inactive status.
5. Prune merged inbox entries and keep unresolved items.
6. Check new durable docs against `../domains/development/code-distillation-method.md`.

## Quality Gate
Run:

```bash
bash /Users/zhanghang/repo/obsidian/shared/agent/scripts/knowledge/check.sh
```

Expected result:
- all deep-dive files contain required sections
- no broken local links/path references in `knowledge/`
- no stale index routes in `knowledge/index.md`
- no orphan markdown docs unreachable from `knowledge/index.md`
