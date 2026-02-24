# WebApp MQ/Pulsar Playbook (Legacy Detailed)

## Scope
- ArgoCD `WebApp` manifests under `argocd-sandbox/argocd-production/argocd-prod`.
- Representative files include `dapi-be`, `devices`, `order20`, `bi-pulsar-consumer` webapp manifests.

## `WebApp` MQ schema used in manifests
```yaml
spec:
  mq:
    namespace: <mq-namespace>
    tenant: public
    topics:
      - name: <topic-name>
        partitions: <int>
        subjects:
          - subject: <app-subject>
            actions:
              - Consume
              - Produce
```

## Field semantics
1. `mq.namespace`:
- business namespace in MQ domain (not k8s namespace).
2. `tenant`:
- usually `public`.
3. `topics[].name` + `partitions`:
- declarative topic creation/shape.
4. `subjects[].subject` + `actions`:
- declarative ACL-like permission grants (`Produce`/`Consume`).

## Confirmed from examples
1. Topic-only declaration exists (`DLQ/RLQ/RETRY` often without subjects).
2. Cross-app consume/produce grants are explicit.
3. Same topic can grant multiple subjects with different actions.

## Practical rules for changes
1. Add only required topics; keep naming stable (`*-DLQ`, `*-RLQ`, `*-RETRY`).
2. Add `subjects` for all producing/consuming apps explicitly.
3. Keep `partitions` aligned with throughput/order requirements.
4. Keep env manifests consistent unless intentionally different.
5. Review cross-team subjects carefully (integration contract).
