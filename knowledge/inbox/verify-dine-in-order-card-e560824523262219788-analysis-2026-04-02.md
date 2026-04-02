# VerifyDineInOrder Card Analysis: `E560824523262219788`

## Scope
分析 `planet.ops.v1.InternalService/VerifyDineInOrder` 在 `prod` 中针对卡号 `E560824523262219788` 的一次真实下单校验，说明入口请求、下游调用链、最终结果，以及已确认的餐别筛选原因。

## Facts
- 时间：
  - `2026-04-01T08:38:18.298675Z`
- trace：
  - `000000000000000061756a40409d61cb`
- ops 请求：
  - `cafeteriaId = 142540474650003480`
  - `card.type = MEICAN_ELECTRIC_CARD`
  - `card.code = E560824523262219788`
  - `card.reader = 10H10D`
  - `supportedPaymentTypes = [PAYMENT_TYPE_LEGACY]`
- ops 响应：
  - `paymentType = PAYMENT_TYPE_LEGACY`
  - `legacyUserSnowflakeId = 112507323021821001`
  - `legacyUserId = 14271160`
  - `cardOutsideNumber = 917081979`

## Timeline
1. `ops` 接收 `VerifyDineInOrder` 请求。
2. `id-card` 执行：
   - `ListIdCardByMerchant`
   - `GetIdCardDetails`
3. `id-card` 记录了明确的 decode 成功日志：
   - `decodedCode = E560824523262219788`
   - `reader = 10H10D`
4. `member` 执行：
   - `ListClientMembersByUserID`
5. `idmapping` 执行：
   - `GetByID(USER)`，将 snowflake user 映射到 legacy user
   - `ListByLegacyIDs(CLIENT_MEMBER)`，将一批 legacy client member 映射到 snowflake
6. `client` 执行：
   - `ListDinnerInInfoByUser`
7. `ops` 返回 legacy 校验成功结果。

## Downstream Calls
- `ops /planet.ops.v1.InternalService/VerifyDineInOrder`
- `id-card /nation_client.id_card.v2.InternalService/ListIdCardByMerchant`
- `id-card /nation_client.id_card.v2.InternalService/GetIdCardDetails`
- `member /client_internal.member.v1.client_service.InternalService/ListClientMembersByUserID`
- `idmapping /idmapping.IDMappingService/GetByID`
- `idmapping /idmapping.IDMappingService/ListByLegacyIDs`
- `client /client_service.InternalService/ListDinnerInInfoByUser`

## Final Available Mealplan
`client` 最终只返回了 1 个可用 mealplan：

- `mealplan.id = 79648456069122129`
- `clientId = 79732832735889477`
- 名称：`河南科技大学第一附属医院周围社会餐厅`
- `operationState = OPERATION_STATE_RUNNING`
- `businessType = BUSINESS_TYPE_DINNER_IN`

## Candidate Mealplans Sent To Client
`ops` 传给 `client ListDinnerInInfoByUser` 的候选 `mealplanIds` 一共 25 个：

`55408, 55409, 55461, 56943, 56944, 57079, 58973, 58974, 56490, 56491, 86607, 86608, 86609, 56492, 57076, 57077, 57078, 57080, 57081, 58830, 58831, 82155, 83472, 83473, 83474`

## Confirmed Filtering Reasons
这轮能从日志里直接确认的筛选原因只有一类：`restaurant limited`。

以下 corp / legacy mealplan 被 `client` 明确记录为：
- `Service.Fan.filterAvailableCorps restaurant limited`

对应 ID：
- `55408`
- `56490`
- `56491`
- `58973`
- `58974`
- `82155`

对应上下文：
- `restaurant_id = 400482`
- `restaurant_city_id = 226`

## What Was Not Observed
这条 trace 里没有看到：
- `not match target time`
- `Service.PlanMember.filterAvailablePlans ...`

这意味着：
- 本次没有走 `PlanMember` 标准筛选链路
- 也没有证据表明某个候选是因为时间窗不匹配而被排掉

## Most Likely Overall Filtering Logic
结合 `client` 代码和日志，这次筛选更可能是：

1. 先用 fan `corp_member` 找出这个用户实际绑定的 corp
2. 与 25 个候选 `mealplanIds` 做交集
3. 进入 `filterAvailableCorps`
4. 其中至少 6 个因为 `restaurant limited` 被排掉
5. 最终只剩 1 个 legacy 到店餐别，再映射成返回的 snowflake mealplan

所以：
- 有些候选并不是“进了后续筛选再失败”
- 更可能是在“用户绑定 corp 交集”阶段就没进入后面的可用性筛选

## Code Anchors
- `client` provider:
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/internal/net/grpc/provider/v1/internal.go`
- `fan` 逻辑：
  - `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/internal/service/fan.go`
- `VerifyDineInOrder` 入口：
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/net/grpc/provider/internal.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops/internal/service/dinein.go`

## Recommended Reuse
以后再碰到“给定卡号，为什么 VerifyDineInOrder 只剩一个或没有 mealplan”的问题，优先复用这套步骤：
1. 先查 `ops VerifyDineInOrder`
2. 拿 trace
3. 一次性缓存完整 trace 到本地 JSON
4. 再从本地文件横向分析 `id-card / member / idmapping / client`
5. 在 `client` 里补查：
   - `restaurant limited`
   - `not match target time`
6. 最后再对照 `fan.go` 的 `listUserAvailableDinnerInPlan / filterAvailableCorps`

推荐缓存命令：

```bash
logclick query run --env prod --json "SELECT time, app, method, req, reply, raw FROM logs WHERE x-otel-trace-id = '000000000000000061756a40409d61cb' LIMIT 100 SINCE 30m" \
  > /tmp/verify-dine-in-order-000000000000000061756a40409d61cb.json
```
