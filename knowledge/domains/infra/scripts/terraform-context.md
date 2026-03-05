# terraform_context.sh Contract

## Purpose
根据环境和应用名定位 Terraform root 与候选目录。

## Status
active

## Required Args
- `--env <sandbox|production|prod>`
- `--app <app_name>`

## Safety Constraints
- read-only filesystem lookup

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/infra/terraform_context.sh \
  --env production --app planet
```

## Expected Output Shape
- `terraform_root=<path>`
- multiple `candidate=<path>` lines
