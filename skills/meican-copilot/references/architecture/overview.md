# Architecture Overview

## Scope
This section explains runtime architecture, deployment topology, and environment boundaries.

## Core Facts
- Primary runtime: EKS.
- Internal communication: gRPC.
- External communication: HTTP.
- Primary edge path on EKS: `nginx/openresty -> kong -> service`.
- Legacy routes still exist:
  - ECS: `route53 -> openresty -> ecs`
  - Lambda: `apigateway -> lambda`

## Environments
- `sandbox`: development/testing.
- `production` (`meican1`): existing production.
- `prod` (`meican2`): new production.

## Entry Points
- Deep details: `deep-dive.md`
- Topology diagram source: `topology.mmd`
- Key services: `service-catalog.md`
