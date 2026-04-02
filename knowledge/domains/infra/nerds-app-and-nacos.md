# nerds/app 与 Nacos

## 用途
这个页面只回答一件事：

- 公司项目里，配置中心/Nacos 通常是怎么接进应用的
- 排查一个服务的配置、credentials、watch、运行时参数时，应该先去哪看

## 核心结论

### Nacos 不是业务源码仓入口
在日常项目理解里，不应该把 Nacos 当成“先去找某个 Nacos 业务仓”的问题。

更准确的理解是：
- Nacos 是配置中心
- 业务项目通常通过应用 bootstrap 框架接入它
- 这个框架默认先看 `nerds/app` v1
- 少量项目或新链路会用 `nerds/app/v2`

### 默认先按 `nerds/app` v1 理解
当前本地项目抽样结果显示：
- 大多数真实业务项目仍然直接引用 `go.planetmeican.com/nerds/app`
- `nerds/app/v2` 更常出现在框架自身、脚手架链路、以及少量新代码

所以排查顺序默认应为：
1. 先看项目是否使用 `go.planetmeican.com/nerds/app`
2. 只有明确 import `.../v2` 时，再切到 `nerds/app/v2`

## 关键代码锚点

### `nerds/app` v1
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/README.md`
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/app.go`
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/pkg/conf/datasource/datasource.go`

已确认事实：
- README 明确写明支持从 `file` / `nacos` / `tower` 拉配置
- 同时支持从 `file` / `nacos` / `tower` 拉 credentials
- `app.go` 定义了：
  - `APP_CONFIG`
  - `APP_CREDENTIALS`
  - 与 `nerds.k8s.meican.com/inject: true` 相关的自动注入 env
- `datasource.go` 明确把 `nacos` 作为标准 datasource scheme

### `nerds/app/v2`
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2/README.md`
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app/v2/pkg/conf/datasource/nacos/nacos.go`

已确认事实：
- `v2` 直接内置 Nacos datasource provider
- 有更清晰的 component/container 语义
- 但当前不是大多数业务仓的默认形态

## 运行时 manifest 的稳定模式

在多个真实项目里，都能看到下面这组组合反复出现：

- `nerds.k8s.meican.com/inject: "true"`
- `--config nacos://...`
- `--watch true`

真实例子：
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client/argo-sandbox/helm/templates/rollout.yaml`
- `/Users/zhanghang/go/src/go.planetmeican.com/client-internal/member/argo-sandbox/rollout.yaml`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/payment/argo-sandbox/helm/templates/rollout.yaml`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/checkout/argo-sandbox/helm/templates/rollout.yaml`
- `/Users/zhanghang/go/src/go.planetmeican.com/nerds/app-cli/internal/packer/templates/argo-sandbox/rollout.yaml.tpl`

常见 DSN 形态：

```text
nacos://http:nacos-hs.nacos:8848/<namespace>?dataid=config.toml&group=<project>
```

这意味着一个服务的配置中心接入，通常要同时看三层：
1. 框架：`nerds/app`
2. manifest：`rollout.yaml` / `helm/templates/rollout.yaml`
3. 项目自己的 config / credentials 消费逻辑

## 排查配置问题的标准顺序

### 1. 先看项目属于哪种启动模式
- `nerds/app` v1
- `nerds/app/v2`
- 还是更老的非 `nerds/app` 模式

### 2. 再看运行时参数
优先看：
- `rollout.yaml`
- `helm/templates/rollout.yaml`
- 容器 args/env

确认：
- 是否有 `--config nacos://...`
- 是否有 `--watch true`
- 是否依赖 `APP_CONFIG` / `APP_CREDENTIALS`
- 是否有 `nerds.k8s.meican.com/inject: "true"`

### 3. 再看项目代码如何消费配置
常见问题：
- 是直接 `application.Config.UnmarshalKey(...)`
- 还是 `Config.OnChange(...)`
- 是否会把 credentials 再合并进业务 config

### 4. 最后再回平台资源
只有当前三层都确认后，再去看：
- Nacos 平台资源目录
- Terraform 里的相关平台资源

## 典型项目形态

### 典型 `nerds/app` v1 项目
- `/Users/zhanghang/go/src/go.planetmeican.com/nation-client/client`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/planet`
- `/Users/zhanghang/go/src/go.planetmeican.com/planet/ops`
- `/Users/zhanghang/go/src/go.planetmeican.com/meican-pay/payment`
- `/Users/zhanghang/go/src/go.planetmeican.com/kiwi/sso`

### 需要单独判断的非典型项目
- `kiwi/baseinfo`
- `kiwi/cafeteria`
- `kiwi/order-system`

这些项目很多带更老的单体/工具箱痕迹，不适合默认按 `nerds/app` 新服务模式理解。

## 常见误区
- 误区：先去找“Nacos 项目源码”
  - 更合理：先看项目是否通过 `nerds/app` 接了 Nacos
- 误区：所有服务都用 `nerds/app/v2`
  - 更合理：默认先按 v1，再按项目事实纠正
- 误区：只看业务代码，不看 rollout args/env
  - 更合理：配置中心问题通常要同时看框架 + manifest + 项目消费逻辑

## 相关文档
- `platform-relationships.md`
- `observability-entry.md`
- `../architecture/project-map.md`
- `../architecture/project-cards.md`
