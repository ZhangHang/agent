# 工作区与贡献信号

## 用途
这个页面回答两个实际工作问题：

- 本地两个大根目录分别是什么性质
- 如何快速判断一个项目是否更可能是你负责、参与过、或者至少值得优先读

## 两个本地工作区根

### `/Users/zhanghang/go/src/go.planetmeican.com`
这里更偏：
- Go 后端服务
- proto
- infra / delivery
- 框架与平台

高频家族包括：
- `planet/*`
- `nation-client/*`
- `developer/*`
- `meican-cd/*`
- `nerds/*`
- `titan/*`
- `meican-pay/*`
- `client-internal/*`

### `/Users/zhanghang/meican`
这里更偏：
- 前端宿主
- Web SDK
- 小程序 / H5 / iOS
- 部分独立 Go/Node 服务
- 一些历史系统或多端项目

高频家族包括：
- `planet-ops-frontend`
- `web-sdk-raven`
- `planet-h5`
- `meican-mp`
- `meican-app-graphql`
- `fan`
- `doorkeeper-*`
- `logclick/*`
- `ios/*`

## 贡献信号的使用规则

### 强信号：本地 git 历史里作者名或邮箱包含 `zhanghang`
在本地仓里，如果 git 历史里作者名或邮箱只要包含 `zhanghang`，就可以把它当成：
- 你参与过
- 你更可能熟悉
- 值得优先纳入“你负责项目模式”的候选

但不要把它写死成：
- 你是唯一 owner
- 这个项目当前一定由你维护

更准确的表述应该是：
- **本地 git 历史显示你有贡献，是强信号，但不是唯一 ownership 证明。**

### 弱信号：本地 clone 了但没有 `zhanghang` 提交
这通常说明：
- 你会拿它当上下游或背景项目阅读
- 它对排查和理解仍然重要
- 但不适合直接写成“你负责”

典型例子：
- `client-internal/member`
- `titan/web-apps/logclick-fe`
- `meican-app-graphql`
- `meican-mp`

## 已确认的高价值“有贡献”项目族

以下项目在本地 git 历史里已确认存在 `zhanghang` 提交，可作为“你熟悉/参与过”的强信号：

### Planet / Nation Client / Developer
- `planet/ops`
- `planet/planet`
- `planet/planet-api`
- `planet/idmapping`
- `planet/operator`
- `planet/project`
- `nation-client/client`
- `nation-client/client-be`
- `nation-client/id-card`
- `nation-client/id-card-adapter`
- `developer/dapi-be`
- `developer/dapi-adapter`
- `api-center/protobufs`

### Delivery / Infra / Platform
- `meican-cd/argocd-sandbox`
- `meican-cd/argocd-production`
- `meican-cd/argocd-prod`
- `meican-cd/terraform-sandbox`
- `meican-cd/terraform-production`
- `meican-cd/terraform-prod`
- `titan/terraform-prod`

### Frontend / SDK / App
- `planet-ops-frontend`
- `web-sdk-raven`
- `planet-h5`
- `client-cli`
- `doorkeeper-api`
- `doorkeeper-fe`
- `fan`
- `meican-pay-checkout-bff`
- `logclick/logclick-cli`

### iOS / Device / Other
- `ios/planet-ios`
- `ios/meican-ios-swift`
- `ios/meican-code-ios`
- `ios/meican-checkout-ios-sdk`
- `ios/MeicanControllers`
- `intelligent-device`
- `iMeicanPay`

## 已确认的高价值“主要作上下游背景阅读”的项目

以下项目在本地存在，但当前抽样未看到 `zhanghang` 提交；它们更适合作为：
- 上下游参考
- 背景上下文
- 契约或前端 API 对照

典型包括：
- `client-internal/member`
- `titan/web-apps/logclick-fe`
- `meican-app-graphql`
- `meican-mp`
- `mutants/order20`
- `meican-pay/checkout`
- `nerds/app`
- `nerds/app-cli`

## 实际使用建议

### 想快速建立你的工作面
优先顺序：
1. 先看 [负责项目常见模式](owned-project-patterns.md)
2. 再看这里的“有贡献项目族”
3. 再回 [项目卡片](project-cards.md) 和 [项目地图](project-map.md)

### 想判断一个项目该不该优先读
顺序：
1. 它是不是当前问题的入口/下游
2. 你本地 git 历史里作者名或邮箱是否包含 `zhanghang`
3. 它属于哪一类：业务主项目 / 工具项目 / 上下游背景项目

### 想写知识库时怎么表述
推荐：
- “本地 git 历史显示该仓作者名或邮箱包含 `zhanghang`，可视为你有贡献的强信号”

不推荐：
- “这是你负责的项目”  
  除非有更直接的职责事实来源

## 相关文档
- `repo-family-map.md`
- `project-map.md`
- `project-cards.md`
- `owned-project-patterns.md`
