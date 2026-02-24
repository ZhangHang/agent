---
title: 排查 CleanMemberCleaner 失效问题
tags: [work, incident]
---

# 排查 CleanMemberCleaner 失效问题

```
write failed: write tcp 10.119.167.103:34324->10.128.0.219:5439: write: broken pipe; write failed: write tcp 10.119.167.103:34324->10.128.0.219:5439: write: broken pipe
```

```yaml
- "app-planet/production-planet-client-member-cleaner-aurora-postgres.cluster-cvz9rmnxmlpq.rds.cn-northwest-1.amazonaws.com.cn"
- "app-planet/bi-prod-hc.c5whpuwq7rpp.cn-northwest-1.redshift.amazonaws.com.cn"
```

```nacos
[custom.ownPg]
    Dsn = "postgres://app_client_member_cleaner_rw:7c06N3wTL2M9841Hdzy5@production-planet-client-member-cleaner-aurora-postgres.cluster-cvz9rmnxmlpq.rds.cn-northwest-1.amazonaws.com.cn:5432/client_member_cleaner?sslmode=disable"
    ShowLog = false
[custom.mateBiQueryPg]
    Dsn = "postgres://service_user:LdQpAdPmGaLmnmxXnFsi2JAn@bi-prod-hc.c5whpuwq7rpp.cn-northwest-1.redshift.amazonaws.com.cn:5439/prod"
    ShowLog = false  
```
