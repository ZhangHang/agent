# Codebase Roots

## Primary Roots
- `/Users/zhanghang/go/src/go.planetmeican.com`
- `/Users/zhanghang/meican`

## Notes
- If user provides `go.planetmiecan.com`, treat as likely typo and verify `go.planetmeican.com`.
- Start repository discovery from these roots before broader filesystem search.

## Suggested Discovery Commands
```bash
ls -la /Users/zhanghang/go/src/go.planetmeican.com
ls -la /Users/zhanghang/meican
rg --files /Users/zhanghang/go/src/go.planetmeican.com | head -n 50
rg --files /Users/zhanghang/meican | head -n 50
```
