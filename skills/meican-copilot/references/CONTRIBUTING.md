# CONTRIBUTING

## Writing Rules
1. Use standard Markdown only.
2. Avoid Obsidian-only syntax and features.
3. Prefer absolute file path anchors when citing code/config.
4. Keep Chinese as primary narrative language; keep technical terms/commands in English.

## Document Layers
Each domain should maintain:
1. `overview.md`: navigation and key decisions.
2. `deep-dive.md`: detailed procedure and operational details.

## Deep-Dive Required Sections
1. Scope
2. Preconditions
3. Step-by-step Procedure
4. Real Examples (with absolute path anchors)
5. Failure Modes + Recovery
6. Validation Checklist
7. Linked Scripts
8. Change History

## Legacy Migration Rules
1. Migrate one legacy file at a time.
2. Preserve all valuable details.
3. Update `legacy/MIGRATION_MAP.md` with destination anchors.
4. Delete the legacy file only after migration checklist passes.

## Script Rules
1. Scripts are read-only by default.
2. Production DB mode prints SQL suggestions only.
3. All scripts should support `--help` and return non-zero on invalid inputs.
