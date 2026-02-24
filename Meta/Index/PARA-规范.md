---
title: PARA 规范
tags: [meta, para]
---

# PARA 规范

## 定义

- Projects：有明确目标与截止点的事项
- Areas：需要长期维护的责任领域
- Resources：参考资料与主题知识
- Archives：已完成或不活跃内容
- Meta：索引、模板、复盘与愿望清单等系统性文件

## 归类规则

- **优先级顺序**：Projects > Areas > Resources > Archives
- **可执行且有结束点**：放 `Projects/`
- **长期维护、无明确结束点**：放 `Areas/`
- **参考资料/摘录/工具文档**：放 `Resources/`
- **阶段结束或暂停**：移动到 `Archives/`
- **系统级索引与模板**：放 `Meta/`

## 命名规范

- 文件名尽量可检索，中文为主
- 项目与复盘类建议使用时间前缀：
  - 周报：`YYYY-Www`
  - 月报：`YYYY-MM`
  - 季报：`YYYY-Qn`

## 迁移规则

- Projects 结束 → `Archives/Projects/`
- Areas 结构性调整 → 保留原目录，新增归档说明
- Resources 无明确价值 → 清理或归档

## 维护习惯

- 每周至少一次复盘，输出到 `Meta/Review/Weekly/`
- 关键决策、阶段总结应写入对应项目
- 有长期目标变化时更新 `Meta/Index/长期计划.md`
