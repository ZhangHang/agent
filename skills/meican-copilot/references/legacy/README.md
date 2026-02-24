# Legacy Detailed References

This folder keeps detailed historical documents during migration.

## Deletion Gate (strict)
Delete a legacy file only when all checks pass:
1. key procedures are preserved in new docs.
2. commands/path anchors are preserved.
3. failure modes and recovery are preserved.
4. at least one concrete example anchor is preserved.
5. `references/INDEX.md` routes to the new destination.
6. migration status is updated in `MIGRATION_MAP.md`.

## Rule
- Migrate one legacy file at a time.
- Prefer preserving detail over summarizing.
