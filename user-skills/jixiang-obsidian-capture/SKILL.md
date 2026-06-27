---
name: jixiang-obsidian-capture
description: Capture Codex conversations, project decisions, CRM/CMR product requirements, development summaries, UI design critique, business workflows, prompt patterns, and reusable lessons into the user's Obsidian vault at D:\N哥的知识库\极享AI知识库. Use when the user asks to 沉淀到 Obsidian, 总结到知识库, 写入极享AI知识库, 更新知识库总览, create an Obsidian note, or preserve project experience as linked markdown notes.
---

# 极享AI Obsidian Capture

Use this skill to turn conversations and project work into durable Obsidian notes.

Default vault:

```text
D:\N哥的知识库\极享AI知识库
```

## Routing

Choose the note location by content type:

| Content | Folder |
| --- | --- |
| CRM/CMR/product requirements, project summaries, system design | `项目/` |
| Codex usage, Skills, prompts, tool workflows | `工具/` |
| AI product factory, courses, offers, business models | `AI产品工厂/` |
| Raw transcripts or temporary content | root or an existing matching folder |

If the target folder does not exist, create it.

## Workflow

1. Identify the note type: project summary, product requirement, tool note, design critique, development log, or meeting/lesson summary.
2. Read `知识库总览.md` if it exists to understand current structure and link style.
3. Create or update a Markdown note with YAML frontmatter, a clear title, a one-sentence conclusion, structured sections, concrete decisions, next actions when useful, and Obsidian wiki links.
4. Update `知识库总览.md` when the new note should become an entry point.
5. Preserve existing notes and user edits. Do not rewrite unrelated content.

## Frontmatter

Use Chinese frontmatter by default:

```markdown
---
类型: 项目总结
状态: 已沉淀
创建时间: YYYY-MM-DD
来源: Codex 对话
tags:
  - Codex
  - 项目
---
```

Choose `类型` from:

```text
项目总结
产品需求
工具笔记
开发经验
设计评审
业务方法论
会议纪要
```

## Writing Style

- Write concise Chinese notes suitable for future retrieval.
- Prefer durable decisions over chat transcript style.
- Keep examples and commands when they are reusable.
- Use tables for comparisons, permission matrices, roles, fields, or Skill lists.
- Use code blocks for commands, paths, prompts, and fixed workflows.
- Use Obsidian links like `[[知识库总览]]`.

## Naming

Use stable descriptive filenames.

For dated project logs:

```text
YYYY-MM-DD 主题沉淀.md
```

For durable tool or requirement notes:

```text
主题名称.md
```

Examples:

```text
项目/2026-06-26 CRM权限模型沉淀.md
工具/Codex Skills 安装与使用体系.md
项目/内部CRM组织架构与权限设计.md
```

## Summary Shapes

For project/development summaries:

1. 一句话结论
2. 背景
3. 已完成内容
4. 关键决策
5. 风险与注意事项
6. 下一步
7. 关联笔记

For product requirements:

1. 一句话定位
2. 用户与角色
3. 核心流程
4. 页面结构
5. 字段与数据
6. 权限规则
7. 验收标准
8. MVP 范围
9. 后续版本
10. 关联笔记

For tool notes:

1. 一句话结论
2. 适用场景
3. 使用方法
4. 推荐组合
5. 常用提示词
6. 注意事项
7. 关联笔记

## Knowledge Index Updates

When updating `知识库总览.md`:

- Add the new note under the most relevant section.
- Use `### [[Note Name]]` as the entry heading.
- Add 1-3 short paragraphs or bullets explaining why the note matters.
- Do not remove existing entries unless explicitly asked.

## Safety

- Do not overwrite unrelated notes.
- If updating an existing note, preserve user content and append or surgically edit.
- If a note with the same title exists, update it only when it is clearly the same topic; otherwise create a dated sibling.
- Never store secrets, tokens, passwords, or private keys in Obsidian notes.
