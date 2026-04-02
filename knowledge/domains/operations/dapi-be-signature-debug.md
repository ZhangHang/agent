# dapi-be Signature Debug Reference

## Scope
这个页面用于排查 `dapi-be` 的签名校验失败，重点覆盖：
- v1 / v2 两套签名规则
- 给定 `developer-id`、`DeveloperRn`、部分日志、`x-otel-trace-id` 时怎么查
- 应该让调用方对比什么 payload
- 当前日志能直接支持什么，缺什么

典型输入：
- `Meican-Developer-Id`
- `DeveloperRn`
- 某个失败时间窗
- 一段网关或调用方日志
- 一条 `dapi-be` 日志

## Preconditions
- 可用 `logclick query run --env prod`
- 可用 `jq`
- 可读 `dapi-be` 代码：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be`
- 可读 developer proto：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`

## Facts From Code

### 签名版本如何判定
`dapi-be` 的 HTTP 入口在 grpc-gateway middleware 里按下面顺序判定签名版本：

1. 如果请求头里有 `Meican-Developer-Id`，直接按 **v2**
2. 否则，如果请求 path 命中某个 proto service 的 `sign_version = V2` 且 `http_base_path` 前缀匹配，也按 **v2**
3. 其他情况按 **v1**

代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/authorization.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto/option/v1/option.proto`

这意味着两个很重要的结论：
- **v2 endpoint 不能拿 v1 签名去打**
- **即使 endpoint 本来是 v1，只要请求头里带了 `Meican-Developer-Id`，也会被强制按 v2 走**

### v1 请求签名 payload
v1 实际参与验签的字符串是：

```text
DeveloperRN + Timestamp + Nonce
```

格式要求：
- Header `DeveloperRn` 必须存在
- Header `Signature` 必须存在
- Header `Timestamp` 必须存在
- Header `Nonce` 必须存在，且长度必须是 **12**
- `Timestamp` 用的是 **毫秒时间戳**，代码和测试里都是 13 位

代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/infra/signature/v1.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/infra/signature/v1_test.go`

### v2 请求签名 payload
v2 实际参与验签的字符串是：

```text
HTTPMethod + "\n" +
URL + "\n" +
Timestamp + "\n" +
Nonce + "\n" +
Body + "\n"
```

格式要求：
- Header `Meican-Developer-Id` 必须存在
- Header `Sign` 必须存在
- Header `Timestamp` 必须存在
- Header `Nonce` 必须存在，且长度必须是 **32**
- `Timestamp` 用的是 **秒时间戳**，测试里是 10 位

代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/infra/signature/v2.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/infra/signature/v2_test.go`

### v2 最容易踩坑的地方
v2 不会帮调用方做 JSON 规范化。它直接拿请求到达网关时的原始要素验签：
- `r.Method`
- `strings.TrimRight(r.URL.String(), "?")`
- `readRequestBody(r)` 读到的原始 body 字节

所以以下任何一点不一致，都会导致验签失败：
- HTTP method 大小写或实际 method 不一致
- URL path/query 不一致
- query string 顺序不一致
- 末尾多一个裸 `?`
- JSON body 空格、换行、字段顺序不同
- body 被调用方本地序列化成了另一种字节串

代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/v2.go`

## Known Endpoint Shape
从 proto 可以直接看哪些服务是 v1，哪些是 v2。

典型 v2：
- `/meican-pay-web/v1`
- `/meican-pay-web/v2`
- `/meican-pay-quick/v1`
- `/merchant/v1/cafeterias`
- `/client/v4`
- `/subsidy/v2`
- `/subscription/v4`
- `/report/v4`
- `/meal-point/v1`
- `/dinein/v1`

典型 v1：
- `/v3/subscription`
- `/v3/redirect`
- `/v3/client/member`
- `/v2/user`
- `/legacy/user`
- `/legacy/redirect`
- `/legacy/groupdeliveryorder`
- `/legacy/mealplan`
- `/legacy/dineinorder`

快速锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`

## Recommended Query Path

### Round 1: 先拿到入口日志
如果用户只给了 `developer-id`、`DeveloperRn`、某个 path 片段或大概时间窗，不要先猜原因。先拉 `dapi-be` 最近日志到本地。

推荐：

```bash
logclick query run --env prod --json "SELECT time, app, level, method, x-otel-trace-id, req, reply, raw FROM logs WHERE app = 'dapi-be' LIMIT 200 SINCE 30m" > /tmp/dapi-be-signature-debug.json
```

然后本地筛：

```bash
jq -r '.data.hits[] | [.time, (.method // ""), (."x-otel-trace-id" // ""), (.raw // "")] | @tsv' /tmp/dapi-be-signature-debug.json | rg 'developerid|developerrn|authorization verify err|values.ValidateFormat err|developer not found|no developer id|验签'
```

如果用户给的是 developer id：

```bash
jq -r '.data.hits[] | [.time, (.method // ""), (."x-otel-trace-id" // ""), (.raw // "")] | @tsv' /tmp/dapi-be-signature-debug.json | rg 'Meican-Developer-Id|developerid|123456'
```

如果用户给的是 `DeveloperRn`：

```bash
jq -r '.data.hits[] | [.time, (.method // ""), (."x-otel-trace-id" // ""), (.raw // "")] | @tsv' /tmp/dapi-be-signature-debug.json | rg 'DeveloperRn|developerrn|rn:developmentteam'
```

如果已经有 trace id，直接 pivot：

```bash
logclick query run --env prod --json "SELECT time, app, level, method, req, reply, raw FROM logs WHERE x-otel-trace-id = '<trace-id>' LIMIT 100 SINCE 30m" > /tmp/dapi-be-<trace-id>.json
```

### Round 2: 只围绕一个失败样本分析
拿到失败样本后，优先确认这几件事：
- 实际走的是 v1 还是 v2
- endpoint 本来要求的是 v1 还是 v2
- 请求头里到底带了哪些签名字段
- `Timestamp` / `Nonce` 长度是否对
- 如果是 v2，实际参与验签的 `method + url + body` 是什么

## What To Ask The Caller
让调用方一次性补齐这些信息，能大幅减少来回：

### v1 需要对比
- `DeveloperRn`
- `Timestamp`
- `Nonce`
- `Signature`
- 实际请求 path

### v2 需要对比
- `Meican-Developer-Id`
- `Timestamp`
- `Nonce`
- `Sign`
- 实际 HTTP method
- 实际 path + query string
- 参与签名的原始 body 字节串

对调用方最关键的一句话：

> 请给出你们实际参与签名的原始 payload，而不是语义等价的 JSON。  
> 对 v2 来说，body 的空格、换行、字段顺序、query string 顺序都会影响签名。

## Common Failure Modes

### 1. 用错签名版本
最常见的两种：
- v2 path 还在用 v1 头
- v1 path 上误带 `Meican-Developer-Id`，导致被强制按 v2 校验

已由代码和测试确认：
- `/meican-pay-quick/v1/*` 这类 v2 endpoint 用 v1 签名会直接 401

测试锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/server_test.go`

### 2. Header 缺失或格式不对
直接由 `ValidateFormat()` 拦截：
- v1 缺 `Signature` / `DeveloperRn` / `Timestamp` / `Nonce`
- v1 `Nonce` 不是 12 位
- v2 缺 `Sign` / `Timestamp` / `Nonce`
- v2 `Nonce` 不是 32 位
- v2 缺 `Meican-Developer-Id`

### 3. 时间戳超时
两套签名都会校验 timestamp，新旧测试都覆盖了 timeout。

如果报：
- `请携带当前时间的 Timestamp 进行请求`

优先怀疑：
- 客户端机器时间漂移
- 秒 / 毫秒单位用错

### 4. Nonce 重复
如果报：
- `header 中 Nonce 已使用`

优先怀疑：
- 重试复用了同一个 nonce
- 并发请求复用了 nonce

### 5. developer 查不到
两条路径：
- v1：按 `DeveloperRn` 查 legacy developer
- v2：按 `Meican-Developer-Id` 查 developer

如果 developer 查不到，`dapi-be` 会直接返回认证失败，不会进入后续业务。

### 6. v2 payload 不一致
这类最隐蔽，也最常见：
- body 在调用方签名前后被重新序列化
- query string 顺序变了
- path 后面带了一个裸 `?`
- 本地签名用的是 pretty JSON，发出的却是 compact JSON

排查时一定要拿用户“实际参与签名的原始字符串”对比，而不是只看 JSON 结构。

## Current Logging Coverage

### 已经有的
当前认证失败日志已经会打出：
- `values.ValidateFormat err`
- `developer query err`
- `developer not found`
- `no developer id`
- `authorization verify err`

并且会带：
- `values`
- `header`
- `developerID` 或 `developerRN`

代码锚点：
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/v1.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/v2.go`

对 v2 来说，`values` 理论上已经包含：
- `HTTPMethod`
- `URL`
- `Body`
- `Timestamp`
- `Nonce`
- `Signature`

所以**单次失败样本**通常是够查的。

### 还不够好的地方
当前日志仍然有几个问题：
- 失败原因主要塞在 `raw` 里，本地 grep 成本高
- 没显式打“这次为什么走 v1 / v2”
- 没显式打“endpoint 要求的 sign version”
- 没显式打 canonical URL
- 没显式打 body hash / body length
- path 级摘要和签名字段没有统一成结构化字段

## Suggested MR If Logs Keep Causing Pain
如果这类问题持续高频，建议给 `authorization` middleware 提一个小 MR，只补结构化日志，不改业务逻辑。

建议新增这些字段：
- `sign_version_used`
- `required_sign_version`
- `developer_id`
- `developer_rn`
- `http_method`
- `request_path`
- `request_url_for_sign`
- `pattern`
- `timestamp`
- `nonce`
- `nonce_len`
- `body_len`
- `body_sha256`
- `verify_reason`

建议原则：
- 不必长期打完整 body
- 但至少打 `body_len + body_sha256`
- 如需短期强排查，可在 error 日志里加受控截断后的 body preview

## Evidence From This Round
- 已读代码并确认 v1 / v2 验签入口、header 规则、payload 规则
- 已读 `server_test.go`，确认：
  - v2 endpoint 用 v1 签名会失败
  - v1 / v2 都有稳定测试样本
- 已拉取 `prod` 最近 6 小时 `dapi-be` 400 条日志做本地筛查
- 这轮**没有抓到一个新鲜的签名失败样本**，所以这份 guidance 主要来自：
  - 代码
  - 测试
  - 日志结构

## Code Anchors
- 签名版本选择：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/authorization.go`
- v1 校验：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/v1.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/infra/signature/v1.go`
- v2 校验：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/middleware/authorization/v2.go`
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/infra/signature/v2.go`
- proto service meta：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/proto`
- 网关测试：
  - `/Users/zhanghang/go/src/go.planetmeican.com/developer/dapi-be/internal/net/grpcgateway/server_test.go`

## Reuse Notes
以后遇到 `dapi-be` 验签失败，默认按这个顺序做：
1. 先判断 v1 还是 v2
2. 再确认 endpoint 本来要求什么版本
3. 再对比 header 格式
4. 如果是 v2，必须让调用方提供“实际参与签名的 method + url + body”
5. 最后再决定是不是需要补 `dapi-be` 的日志
