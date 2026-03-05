# Observability Playbook (Detailed)

## Scope
Dashboard/alert/probe setup and MQ declaration conventions.

## Dashboard and Alert (Terraform)
- Example app:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/doc/terraform`
- Key files:
  - `dashboard.tf`
  - `alert_rule_group.tf`
  - `locals.tf`
  - `panels/*.json`

## WebApp MQ/Pulsar Convention
In `webapp.yaml`, `spec.mq` defines namespace/tenant/topics/subject actions.

Sample schema:
```yaml
spec:
  mq:
    namespace: xxx
    tenant: public
    topics:
      - name: topic-name
        partitions: 1
        subjects:
          - subject: app-a
            actions: [Produce, Consume]
```

## MQ Field Semantics
1. `mq.namespace`: MQ business namespace (not k8s namespace).
2. `tenant`: usually `public`.
3. `topics`: declarative topic shape.
4. `subjects/actions`: declarative produce/consume authorization intent.

## Practical Rules
1. Add only required topics and keep naming stable (`*-DLQ`, `*-RLQ`, `*-RETRY`).
2. Declare producers/consumers explicitly by subject.
3. Keep `partitions` aligned with throughput and ordering needs.
4. Keep env manifests consistent unless intentionally different.
5. Keep dashboard UID/folder UID stable to avoid duplicates.
