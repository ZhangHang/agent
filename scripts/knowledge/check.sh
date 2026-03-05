#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
KNOWLEDGE_ROOT="$REPO_ROOT/knowledge"

if [[ ! -d "$KNOWLEDGE_ROOT" ]]; then
  echo "knowledge root not found: $KNOWLEDGE_ROOT" >&2
  exit 2
fi

python3 - "$KNOWLEDGE_ROOT" <<'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
errors = []

required_sections = [
    "Scope",
    "Preconditions",
    "Procedure",
    "Real Anchors",
    "Failure Modes",
    "Validation Checklist",
    "Linked Scripts",
    "Change History",
]

# 1) deep-dive required sections
deep_dives = sorted(root.glob("domains/*/deep-dive.md"))
for f in deep_dives:
    text = f.read_text(encoding="utf-8")
    for sec in required_sections:
        if re.search(rf"^##\s+{re.escape(sec)}\s*$", text, flags=re.M) is None:
            errors.append(f"missing section '{sec}' in {f}")

# 2) link/path extraction
md_files = sorted(root.rglob("*.md"))
md_set = {p.resolve() for p in md_files}

md_link_re = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
code_path_re = re.compile(r"`([^`\n]*/[^`\n]*\.(?:md|mmd))`")

adj = {p.resolve(): set() for p in md_files}

def resolve_path(src: Path, raw: str):
    target = raw.strip()
    if (
        not target
        or "*" in target
        or target.startswith(("http://", "https://", "mailto:", "#"))
    ):
        return None
    if target.startswith("knowledge/"):
        p = root.parent / target
        return p.resolve()
    if target.startswith("/"):
        p = Path(target)
    else:
        p = (src.parent / target)
    return p.resolve()

for f in md_files:
    if f.resolve() == (root / "inbox/changelog.md").resolve():
        continue
    txt = f.read_text(encoding="utf-8")
    refs = []
    refs.extend(md_link_re.findall(txt))
    refs.extend(code_path_re.findall(txt))
    for raw in refs:
        raw = raw.split("#", 1)[0]
        p = resolve_path(f, raw)
        if p is None:
            continue
        if not p.exists():
            errors.append(f"broken ref in {f}: {raw}")
            continue
        if p.suffix == ".md" and p in md_set:
            adj[f.resolve()].add(p)

# 3) stale routes in knowledge/index.md specifically
idx = (root / "index.md").resolve()
if idx not in md_set:
    errors.append("missing knowledge/index.md")

# 4) orphan markdown docs from knowledge/index.md reachability
if idx in md_set:
    seen = set()
    stack = [idx]
    while stack:
        cur = stack.pop()
        if cur in seen:
            continue
        seen.add(cur)
        stack.extend(adj.get(cur, []))

    # allowed standalone docs
    allow = {
        (root / "README.md").resolve(),
        (root / "inbox/changelog.md").resolve(),
    }
    orphans = sorted(str(p) for p in md_set - seen - allow)
    for o in orphans:
        errors.append(f"orphan doc (not reachable from knowledge/index.md): {o}")

if errors:
    print("[knowledge-check] FAILED")
    for e in errors:
        print(f"- {e}")
    sys.exit(1)

print("[knowledge-check] OK")
PY
