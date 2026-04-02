# 负责项目常见模式

## 用途
这个页面把你当前最常接触的一组项目串成一张更贴近实际工作的图：

- `planet/ops`
- `planet/planet`
- `developer/dapi-be`
- `nation-client/client`
- `client-internal/member`
- `nation-client/id-card`
- `planet/idmapping`

目标不是穷举所有调用关系，而是回答：
- 这些项目各自更像什么角色
- 平时排查问题该先去哪
- 它们经常怎么串起来

## 一张工作地图

### 业务编排入口
- `planet/ops`
  - 更像业务编排服务
  - 高价值入口是就餐、下单、规则校验、client member 相关编排

### 内部大聚合 / 工具能力
- `planet/planet`
  - 更像内部管理端大聚合服务
  - 对外能力面宽，`/v1/planet/*` 和各种内部工具能力经常在这里收口

### 开放平台 / 外部网关
- `developer/dapi-be`
  - 更像对外网关和聚合入口
  - 先处理签名、鉴权、限流、endpoint，再分发到下游业务域

### 核心领域服务
- `nation-client/client`
  - client / plan / member 规则和筛选核心
- `client-internal/member`
  - client member / mealplan 管理和查询核心
- `nation-client/id-card`
  - 卡身份和卡关联核心
- `planet/idmapping`
  - legacy id / snowflake id 映射核心

## 你负责项目里最常见的链路

### `ops -> member -> id-card -> client -> idmapping`
这是最典型的一条业务调试链。

适用场景：
- 下单校验
- 卡号识别
- client member 绑定
- legacy / snowflake id 互转
- mealplan 可用性筛选

经验规则：
1. 如果问题是“某个业务动作为什么被放行/拒绝”，先从 `ops` 入口查。
2. 如果问题是“为什么这个人/这个 client member/这个 mealplan 状态不对”，先切到 `member` 或 `client`。
3. 如果问题是“卡为什么识别成这个人/为什么识别失败”，先切到 `id-card`。
4. 如果问题是“ID 看起来对不上”，先切到 `idmapping`。

### `planet-ops-frontend -> planet / planet-api / web-sdk-raven`
这是前端和工具能力的常见链路。

适用场景：
- `planet-ops-frontend` 页面问题
- SFTools
- `/v1/planet/*` 工具能力

经验规则：
1. 先看前端宿主入口。
2. 再看 `web-sdk-raven` 或 path 常量。
3. 再回 `planet` 或 `planet-api`。

### `外部调用 -> dapi-be -> 内部业务域`
这是开放平台与外部流量问题的常见链路。

适用场景：
- 签名不通过
- 权限/限流
- 外部接口调用没打到下游
- 网关层路由不一致

经验规则：
1. 先看 `dapi-be`。
2. 先怀疑前置中间层，而不是底层业务没实现。
3. 只有确认请求真的穿过网关后，再继续下游追踪。

## 怎么判断该先看哪个项目

### 先看 `ops`
当问题长这样：
- 为什么这次下单校验返回了这个结果
- 为什么这次请求走了 legacy / 新会员 / 卡路径
- 为什么上游看到的错误和下游不一致

### 先看 `client`
当问题长这样：
- mealplan 最终为什么可用 / 不可用
- 时间限制、餐厅限制、运营态、legacy/fan 逻辑
- `ListDinnerInInfoByUser` / 计划筛选

### 先看 `member`
当问题长这样：
- client member 不存在/绑定不对
- mealplan-member、verification、搜索和管理查询

### 先看 `id-card`
当问题长这样：
- 卡号识别失败
- 卡和人绑定关系不对
- 读卡器 / card type / external card 路径异常

### 先看 `idmapping`
当问题长这样：
- legacy id 和 snowflake id 对不上
- 上下游各自打印不同 id，怀疑映射链问题

### 先看 `planet`
当问题长这样：
- `/v1/planet/*` 接口问题
- 内部工具/运营后台能力问题
- 不确定真正后端能力是哪个内部域提供，但入口就在 `planet`

### 先看 `dapi-be`
当问题长这样：
- developer/open API 问题
- 签名、权限、rate limit、endpoint 路由
- 外部调用为什么没到内部业务服务

## 这组项目的共性代码模式

### 共性 1：都先看 `cmd/main.go`
这里能最快回答：
- 用的是 `nerds/app` v1 还是别的框架
- 挂了哪些 server
- boot 了哪些基础能力

### 共性 2：`internal/domain/*` 是依赖边界
这里最适合回答：
- 它依赖了哪些外部域
- 这个仓到底是核心领域，还是编排层，还是聚合层

### 共性 3：`internal/service/*` 才是业务规则
这里最适合回答：
- 真正的筛选、校验、转换、编排逻辑在哪
- 哪些文件是高语义入口，例如：
  - `dinein.go`
  - `client_member.go`
  - `fan.go`
  - `legacy_client.go`
  - `verification.go`

## 推荐阅读顺序

### 想建立整体感觉
1. `planet/ops`
2. `nation-client/client`
3. `client-internal/member`
4. `nation-client/id-card`
5. `planet/idmapping`
6. `planet/planet`
7. `developer/dapi-be`

### 想解决具体 debug
1. 从入口服务开始
2. 拿 trace / id / method
3. 再按上面的职责切到下游核心服务

## 相关文档
- `project-map.md`
- `project-cards.md`
- `../development/typical-go-service-patterns.md`
- `../operations/verify-dine-in-order-debug.md`
