# Platform Architecture

## Runtime and Deployment
- Primary runtime: EKS across environments.
- Deploy management: ArgoCD projects per environment.
- Cloud infrastructure: Terraform per environment.

## Service Communication
- Internal service communication: gRPC.
- External communication: HTTP.

## Traffic Layers
- In-cluster gateway: Kong.
- Edge proxy: Nginx/OpenResty.

## Legacy Paths
- Java legacy monolith: `fan`.
- Legacy runtime includes ECS and Lambda.
- ECS path commonly involves Route53 then OpenResty.
- Lambda path commonly involves API Gateway.

## Codebase Stack
- Primary backend: Golang microservices.
- Legacy backend: Java (`fan`).
- Frontend: mainly React, sometimes Vue.

## Investigation Ordering
1. Determine request path and runtime (EKS/ECS/Lambda).
2. Locate gateway/proxy logs first.
3. Correlate with service logs and traces.
4. Verify behavior in code and deploy config.
