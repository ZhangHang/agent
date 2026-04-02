# VerifyDineInOrder Debug Reference

## Scope
`planet.ops.v1.InternalService/VerifyDineInOrder` 的日志排查、proto 对照、下游调用链定位。

重点场景：
- 给定 `user_id` / `client_member_id` 排查为什么能或不能到店下单
- 给定卡号、卡类型、读卡器排查卡身份如何被解析
- 从 `ops` 请求一路追到 `client` / `member` / `id-card`
- 从 `x-otel-trace-id` 提供给人工继续看 trace

## Preconditions
- 可用 `logclick query run --env prod`
- 可用 `jq`
- 可读 proto：
  - `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs`
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client-proto`
- 需要至少一个锚点：
  - `user_id`
  - `client_member_id`
  - 卡号 / reader
  - `x-otel-trace-id`
  - 大致时间窗

## Procedure
1. 先查 `ops` 的 `VerifyDineInOrder`，拿到 `req` / `reply` / `x-otel-trace-id`。
2. 再用同一个 `x-otel-trace-id` 横向查 `ops` / `client` / `member` / `id-card`，看下游发生了什么。
3. 如果请求里是 `identity.userId` / `identity.clientMemberId`：
   - 重点关注 `client` 的可用餐别查询
   - 重点关注 `member` 的下单校验
4. 如果请求里是 `identity.card`：
   - 重点关注 `id-card` 的卡类型校验和身份解析
   - 再看是否落到 legacy 路径还是新身份路径
5. 最后按 `method` 去 proto 和代码里对照 request/response 字段。

### Faster analysis pattern
优先按“1-2 轮查询 + 本地缓存”做，而不是围绕同一个 trace 反复打很多小查询。

推荐节奏：
1. 第 1 轮只查入口：
   - 目标是拿到 `req` / `reply` / `x-otel-trace-id`
2. 第 2 轮按 trace 一次性查全链路：
   - `ops` / `client` / `member` / `id-card`
   - 字段至少带 `time, app, method, req, reply, raw`
3. 结果直接落到本地 JSON：
   - `/tmp/verify-dine-in-order-<trace>.json`
4. 后续尽量用本地 `jq` 分析：
   - 抽方法
   - 抽 trace
   - 找筛选日志
   - 找具体 card / user / mealplan 字段
5. 只有在本地缓存缺字段或时间窗错了时，才重新打线上查询

### Step 1: 先查 ops 入口
默认查询：

```bash
logclick query run --env prod --json "SELECT time, app, x-otel-trace-id, method, req, reply FROM logs WHERE app = 'ops' AND method = '/planet.ops.v1.InternalService/VerifyDineInOrder' LIMIT 20 SINCE 30m" \
  | jq '.data.hits[] | {time, trace: .["x-otel-trace-id"], req, reply}'
```

按 user/client_member 缩小：

```bash
logclick query run --env prod --json "SELECT time, app, x-otel-trace-id, method, req, reply FROM logs WHERE app = 'ops' AND method = '/planet.ops.v1.InternalService/VerifyDineInOrder' AND CONTAINS ('119929045743370307') LIMIT 20 SINCE 30m"
```

按卡号缩小：

```bash
logclick query run --env prod --json "SELECT time, app, x-otel-trace-id, method, req, reply FROM logs WHERE app = 'ops' AND method = '/planet.ops.v1.InternalService/VerifyDineInOrder' AND CONTAINS ('E474166778743493756') LIMIT 20 SINCE 30m"
```

### Step 2: 用 trace id 横向查下游
拿到 trace id 后，查询相关 app：

```bash
logclick query run --env prod --json "SELECT time, app, method, req, reply FROM logs WHERE app IN ('ops', 'client', 'member', 'id-card') AND x-otel-trace-id = '<trace-id>' AND method EXISTS LIMIT 50 SINCE 30m" \
  | jq '.data.hits[] | {time, app, method, req, reply}'
```

建议直接缓存一份完整 trace：

```bash
logclick query run --env prod --json "SELECT time, app, method, req, reply, raw FROM logs WHERE x-otel-trace-id = '<trace-id>' LIMIT 100 SINCE 30m" \
  > /tmp/verify-dine-in-order-<trace-id>.json
```

之后优先本地分析：

```bash
jq '.data.hits[] | {time, app, method, req, reply}' /tmp/verify-dine-in-order-<trace-id>.json
```

```bash
jq '.data.hits[] | select(.app == "client") | {time, raw}' /tmp/verify-dine-in-order-<trace-id>.json
```

### Step 3: user / client_member 路径怎么理解
如果 `req.identity` 里直接带：
- `userId`
- `clientMemberId`

优先看这几个 method：
- `ops`:
  - `/planet.ops.v1.InternalService/VerifyDineInOrder`
- `member`:
  - `/client_internal.member.v1.client_service.InternalService/GetClientMember`
  - `/client_internal.member.v1.client_service.InternalService/BatchGetClientMembers`
  - `/client_internal.member.v1.client_service.InternalService/IsAllowOrder`
- `client`:
  - `/client_service.InternalService/GetClient`
  - `/nation_client.client.v2.InternalService/ListClientMemberAvailablePlans`
  - 可能还会有 `/client_service.InternalService/BatchGetMealplans`

判断重点：
- `GetClientMember` / `BatchGetClientMembers`：客户成员是否存在、状态是否正常
- `GetClient`：客户是否在线、支付类型是什么
- `ListClientMemberAvailablePlans`：在目标时间和食堂下是否有可用餐别
- `IsAllowOrder`：member 规则是否允许下单

### Step 4: 卡路径怎么理解
如果 `req.identity.card` 里带：
- `type`
- `code`
- `reader`

优先看这几个 method：
- `ops`:
  - `/planet.ops.v1.InternalService/VerifyDineInOrder`
- `id-card`:
  - `/nation_client.id_card.v2.InternalService/ListIdCardByMerchant`
  - `/nation_client.id_card.v2.InternalService/GetIdCardDetails`
  - legacy 情况下可能出现 `/nation_client.id_card.v2.InternalService/GetElectricCardIdentity`
- `client`:
  - `/client_service.InternalService/ListDinnerInInfoByUser`

判断重点：
- `ListIdCardByMerchant`：商户/食堂是否支持这个卡类型
- `GetIdCardDetails`：卡号是否能解析出身份，reader 是否生效
- `GetElectricCardIdentity`：是否进入 legacy user 路径
- `ListDinnerInInfoByUser`：legacy 下按 user 查询到店餐别和 client 信息

## Real Anchors

### Proto
- OPS service:
  - `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs/planet/ops/v1/internal_service.proto`
  - `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs/planet/ops/v1/internal_message.proto`
- ID card internal service:
  - `/Users/zhanghang/go/src/go.planetmeican.com/api-center/protobufs/nation-client/id-card/v2/internal_service.proto`

### Code
- OPS gRPC provider:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/net/grpc/provider/internal.go`
- OPS verify orchestration:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/service/dinein.go`
- OPS id-card RPC client:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/id_card/id_card.go`
- OPS client RPC clients:
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/client/client.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/domain/clientv2/client.go`
- id-card provider:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card/internal/net/grpc/provider/v2/v2_internal.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/id-card/internal/handler/internal.go`

### Facts from prod logs
已在 `prod` 验证过两条典型链路：

1. user / client_member 路径
- `ops /planet.ops.v1.InternalService/VerifyDineInOrder`
- `member GetClientMember`
- `client GetClient`
- `member BatchGetClientMembers`
- `client ListClientMemberAvailablePlans`
- `member IsAllowOrder`

2. card 路径
- `ops /planet.ops.v1.InternalService/VerifyDineInOrder`
- `id-card ListIdCardByMerchant`
- `id-card GetIdCardDetails`
- `client ListDinnerInInfoByUser`

### Card case: `E560824523262219788`
已在 `prod` 验证过一条完整卡路径案例，适合作为“给定卡号如何分析”的基线。

- 时间：
  - `2026-04-01T08:38:18.298675Z`
- trace：
  - `000000000000000061756a40409d61cb`
- ops 入口请求：
  - `cafeteriaId = 142540474650003480`
  - `identity.card.type = MEICAN_ELECTRIC_CARD`
  - `identity.card.code = E560824523262219788`
  - `identity.card.reader = 10H10D`
  - `supportedPaymentTypes = [PAYMENT_TYPE_LEGACY]`
- ops 入口响应：
  - `paymentType = PAYMENT_TYPE_LEGACY`
  - `legacyUserSnowflakeId = 112507323021821001`
  - `legacyUserId = 14271160`
  - `cardOutsideNumber = 917081979`

这条 trace 下实际发生的下游调用：
- `id-card /nation_client.id_card.v2.InternalService/ListIdCardByMerchant`
- `id-card /nation_client.id_card.v2.InternalService/GetIdCardDetails`
- `member /client_internal.member.v1.client_service.InternalService/ListClientMembersByUserID`
- `idmapping /idmapping.IDMappingService/GetByID`
- `idmapping /idmapping.IDMappingService/ListByLegacyIDs`
- `client /client_service.InternalService/ListDinnerInInfoByUser`

`client` 侧最终返回的可用餐别只有 1 个：
- `mealplan.id = 79648456069122129`
- `clientId = 79732832735889477`
- 名称：`河南科技大学第一附属医院周围社会餐厅`

这一轮能从日志里直接确认的筛选原因：
- 以下 legacy corp / mealplan 被 `client` 明确打日志筛掉：
  - `55408`
  - `56490`
  - `56491`
  - `58973`
  - `58974`
  - `82155`
- 对应日志都是：
  - `Service.Fan.filterAvailableCorps restaurant limited`
  - `restaurant_id = 400482`
  - `restaurant_city_id = 226`

这一轮没有看到：
- `not match target time`
- `Service.PlanMember.filterAvailablePlans ...`

所以这次更像是：
- 大部分候选先在 fan `corp_member` 交集阶段被排掉
- 进入后续筛选的一小部分里，至少有 6 个因为 `restaurant limited` 被排掉
- 最终只剩 1 个 legacy 到店餐别映射成返回的 snowflake mealplan

### How code maps to logs
- `provider.Internal.VerifyDineInOrder` 把 proto request 转成 dto，再调 `service.DineIn.UnionVerify`
- `UnionVerify`：
  - 卡场景先校验商户支持的卡类型
  - 然后 `PrepareIdentity`
  - legacy 身份走 `LegacyVerify`
  - 新身份走 `Verify`
- `PrepareIdentity`：
  - 卡场景走 `prepareCardIdentity`
  - user/client_member 场景走 `prepareUserIdentity` + `prepareClientMemberIdentity`
- `Verify` 新身份路径：
  - `verifyPaymentType`
  - `verifyCard`
  - `verifyIdentity`
  - `verifyClient`
  - `verifyClientMemberOrder`

## Failure Modes
- `ops` 只有入口日志，没有下游：
  - trace id 可能没打透
  - 或下游 method 日志未按相同 trace 输出
- 卡请求没有 `id-card` 下游：
  - 先确认是否真的走了卡身份，而不是 user/client_member 身份
- `id-card GetIdCardDetails` 有，但 `client ListDinnerInInfoByUser` 没有：
  - 可能在卡解析或身份转换阶段被过滤
- `client ListClientMemberAvailablePlans` 空结果：
  - 目标时间 / 食堂 / 餐别限制不匹配
- `member IsAllowOrder` 返回 `allow=false`：
  - 看 `notAllowedReason`

## Validation Checklist
- 已拿到 `ops` 的 `VerifyDineInOrder` 请求和响应
- 已拿到至少一个 `x-otel-trace-id`
- 已确认这是：
  - user/client_member 路径，还是
  - card 路径
- 已看到至少一个下游 method
- 已用 proto 对照 `req` / `reply`
- 已明确最终失败点在：
  - 身份解析
  - 餐别可用性
  - member 下单规则
  - legacy/new 路径分流

## Linked Scripts
- `scripts/trace/trace_lookup.sh`
- `skills/logclick-debug/SKILL.md`

## Change History
- 2026-04-01: added real prod-verified `VerifyDineInOrder` debug flow across ops/client/member/id-card.
