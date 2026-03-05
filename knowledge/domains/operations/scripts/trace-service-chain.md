# trace_service_chain.sh Contract

## Purpose
按 `service + method` 快速定位 provider/service/domain 以及配置锚点，输出候选调用链。

## Status
active

## Required Args
- `--service <service-path>`
- `--method <method-name>`

## Safety Constraints
- read-only
- only searches local repos with `rg`

## Example
```bash
/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/scripts/context/trace_service_chain.sh \
  --service planet/ops --method VerifyDineInOrder
```

## Expected Output Shape
sections:
- `=== Trace Inputs ===`
- `=== Entrypoint Candidates ===`
- `=== Service/Domain Candidates ===`
- `=== RPC Config Anchors ===`
- `=== Proto Anchors (if any) ===`
