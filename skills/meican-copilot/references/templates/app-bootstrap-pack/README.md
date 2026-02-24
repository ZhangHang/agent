# App Bootstrap Template Pack

Use this pack to bootstrap a new app with:
- Terraform minimal infra
- ArgoCD minimal runtime
- Optional extensions

## Folder
- `/Users/zhanghang/repo/obsidian/shared/agent/skills/meican-copilot/references/templates/app-bootstrap-pack`

## Placeholders to replace
- `{{SERVICE}}` -> group, e.g. `planet`, `developer`
- `{{APP}}` -> app name, e.g. `payment-adapter`
- `{{NAMESPACE}}` -> k8s namespace, e.g. `app-planet`
- `{{ENV}}` -> `sandbox` / `production` / `prod`
- `{{CONTEXT_MODULE}}` -> `common_data_sandbox` / `common_data_meican1` / `common_data_meican2`
- `{{CONTEXT_REF}}` -> module ref version
- `{{BACKEND_BUCKET}}` -> terraform state bucket per env
- `{{STATE_KEY}}` -> state key, e.g. `infrastructure/planet/payment-adapter/sandbox/terraform.tfstate`
- `{{HOST_BASE}}` -> route host base, e.g. `payment-adapter-grpc.app-planet.ntrnl-eks-fan2.meican`
- `{{IMAGE}}` -> ecr image full path + tag
- `{{GROUP}}` -> app group label
- `{{PROJECT}}` -> app project label
- `{{PORT_GRPC}}` -> grpc port
- `{{PORT_HTTP}}` -> http/grpc-gateway port (optional)
- `{{PORT_METRICS}}` -> metrics port

## Start order
1. Copy `terraform-minimal/*` to target env terraform folder.
2. Copy `argocd-minimal/*` to target env argocd app folder.
3. Replace placeholders.
4. Apply `coupling-checklist.md`.
5. Add optional files only when required.
