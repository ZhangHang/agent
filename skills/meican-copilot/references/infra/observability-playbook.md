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

## Operational Notes
1. Keep topic names stable and explicit.
2. Declare cross-app subject permissions explicitly.
3. Keep dashboard UID/folder UID stable to avoid duplicates.
4. Treat UI manual edits as non-source-of-truth if Terraform manages dashboards.
