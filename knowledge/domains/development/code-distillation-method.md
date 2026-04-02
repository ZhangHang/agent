# 代码蒸馏方法

## 用途
这个页面定义“怎么把本地代码工作区里的事实蒸馏成 shared agent 知识”的统一方法。

目标：
- 让新增知识遵守同一条提炼顺序
- 避免文档风格漂移
- 避免把主观 ownership、模糊印象写成知识事实

## 固定蒸馏顺序

1. **先定 repo family**
- 它属于 `planet/*`、`nation-client/*`、`developer/*`、`meican-pay/*`、`kiwi/*`、`bi/*`，还是 `/Users/zhanghang/meican` 前端/BFF/SDK 族
- 先带上正确的阅读心智，再进代码

2. **看入口**
- Go 服务优先：
  - `cmd/main.go`
  - 根目录 `main.go`
- 前端优先：
  - route / page / feature 入口
- SDK / monorepo 优先：
  - root `package.json`
  - `packages/*`
  - `projects/*`

3. **看 `boot.go` 或启动拼装层**
- 对很多 Go 服务，`boot.go` 或 `domain.Boot()` 是最快的拓扑入口
- 可以直接看出：
  - 下游依赖
  - net 层
  - jobs / consumers
  - config/bootstrap 方式

4. **看 `internal/domain/*`**
- 很多服务的 `internal/domain/*` 本身就是“下游依赖清单”
- 需要优先找：
  - 域名
  - RPC/GRPC 客户端初始化
  - 外部 service provider
  - adapter / gateway

5. **看 proto import**
- 先看代码实际 import 了哪个 proto 仓
- 默认可以先去 `api-center/protobufs`
- 但最终以业务代码 import 为准

6. **看 runtime manifests / platform config**
- 当问题涉及：
  - env
  - rollout
  - Nacos
  - dashboard / alert
  - service-monitor
- 再回：
  - `meican-cd/argocd-*`
  - `meican-cd/terraform-*`
  - `nerds/app`
  - 相关 `doc/terraform`

7. **最后才写文档**
- 先收事实锚点
- 再收方法
- 最后再决定写成：
  - project card
  - family map
  - topology reference
  - debug case
  - skill 默认行为

## 写法规则

### 事实
- 只写来自：
  - 代码
  - proto
  - manifest
  - README
  - 真实日志 / trace
- 能给路径就给路径
- 能给入口文件就给入口文件

### 方法
- 明确告诉 agent：
  - 同类问题下次先看哪
  - 先查哪层，再查哪层
- 方法应可复用，而不是只解释这一次

### 例子
- 每页最多保留 1-2 个高价值例子
- 例子应该服务于方法，不要让文档退化成流水账

## 不要写的东西
- 凭印象的 ownership 结论
- 没有本地锚点支撑的组织关系
- 过度细碎的 case 噪音
- 把 skill 正文和知识正文重复一遍

## 适合写到哪里

### 写成 `project-cards.md`
- 仓本身重要
- 需要固定“它是什么、从哪进、上下游是谁”

### 写成 family / pattern 文档
- 同类仓有共同阅读心智
- 需要告诉 agent “这一类应该怎么读”

### 写成 durable reference
- 高频业务链
- 多次复用的 debug 结果
- 已经有稳定 code + trace + log anchors

### 写成 inbox case
- 一次真实排查
- 还没证明足够稳定可长期复用

## 相关文档
- `repo-family-patterns.md`
- `typical-go-service-patterns.md`
- `frontend-bff-sdk-patterns.md`
- `../architecture/topology-from-domain-dirs.md`
- `../operations/debug-workflow.md`
