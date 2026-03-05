# Service Catalog (Working Set)

## Purpose
Maintain high-value service list and role summary for investigation routing.
For full user-provided repository coverage, see:
- `project-inventory.md`

## Core Services
- `planet/planet`: grpc-gateway style app, permission and customer-tool related capabilities.
- `developer/dapi-be`: complex gateway middleware app (sign, rate, authorization, endpoint checks).
- `developer/dapi-adapter`: developer domain adapter service, part of current base-image upgrade batch.
- `nation-client/client`: core nation-client capabilities, CI includes multi-DB + dynamodb setup.
- `nation-client/area`: nation-client area domain service, part of current base-image upgrade batch.
- `be-meican-app/payment-adapter`: payment domain adapter service, part of current base-image upgrade batch.
- `fan` (legacy Java): still used in major legacy business flows.

## Supporting Infra Systems
- `titan/logclick`: log query platform frontend/backend.
- `titan/base-images`: base image source of truth for Docker/CI image upgrades and security remediation.
- ArgoCD repos under `meican-cd/argocd-*`.
- Terraform repos under `meican-cd/terraform-*`.

## Maintenance Rule
Update this catalog when a new service becomes critical in:
1. Delivery path.
2. Incident frequency.
3. Cross-service dependency fan-out.
