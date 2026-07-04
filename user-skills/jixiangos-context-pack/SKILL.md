---
name: jixiangos-context-pack
description: Use when organizing JixiangOS project materials, WPS/Obsidian knowledge-base notes, chat screenshots, sales or finance policies, PRDs, SOPs, meeting notes, or scattered decisions into a clear context pack before drafting, editing, planning, or implementing.
---

# JixiangOS Context Pack

## Overview

Use this skill to turn scattered JixiangOS materials into a decision-ready context pack. Preserve source evidence, separate confirmed rules from assumptions, and surface conflicts before writing final documents.

Default project roots to check when the user mentions JixiangOS, 极享OS, 极享公司OS, or the company knowledge base:

- `C:\Users\jranl\WPSDrive\196914891\WPS云盘\林恩光的知识库\02_JXOS_极享公司OS`
- `C:\Users\jranl\WPSDrive\196914891\WPS云盘\林恩光的知识库`

If these paths are unavailable, ask for the current project path or use files provided in the thread.

## Workflow

1. Identify the user's target: policy draft, PRD, SOP, project map, decision summary, issue list, or implementation brief.
2. Gather sources from explicit files, screenshots, pasted chat, and relevant project folders. Prefer `rg` for text search and preserve exact file paths.
3. Extract evidence as dated facts. Use absolute dates when available; do not rely on "today", "this month", or "last time" without resolving them.
4. Classify each item:
   - Confirmed decision
   - Draft proposal
   - Open question
   - Conflict with older material
   - Action item
5. Produce a context pack first when source material is messy. Only edit policy/PRD/SOP files after the context pack makes the intended change clear.

## Output Shape

Use this structure unless the user asks for another format:

```markdown
## Context Pack

### Goal
[What the user is trying to decide or produce]

### Sources Checked
- [absolute file path or screenshot name] - [why it matters]

### Confirmed Facts
- [fact] (source: [file/path or chat image])

### Current Rules / Current State
- [existing policy, workflow, or product behavior]

### New Decisions To Apply
- [decision] - effective from [date if known]

### Conflicts / Risks
- [conflict between versions, owners, amounts, dates, formulas, or department responsibilities]

### Open Questions
- [question that must be confirmed by Lin / owner / finance / sales]

### Recommended Next Edit
- [exact document and section to update]
```

## JixiangOS Domain Rules

- Treat "JXOS", "JixiangOS", "极享OS", and "极享公司OS" as the same project unless the user distinguishes them.
- For制度, finance, sales commission, customer success, and operations materials, keep wording suitable for internal Chinese company documents.
- Do not overwrite historical monthly policies unless asked. Prefer creating a new dated or monthly revision, then update the new version.
- When formulas or money amounts appear, show the formula and result. Example: `9800 - 2980 = 6820`.
- Separate customer source, customer owner, deal closer, service owner, and finance confirmation. These often decide commissions.
- If evidence is a screenshot, summarize the relevant message and refer to it by image name; avoid inventing missing surrounding context.

## Common Scenarios

### Commission Policy

Use when the user asks how to add a chat decision into a sales, finance, or commission document.

Checklist:

- Identify the month/version affected.
- Identify customer type and source channel.
- Identify who gets performance credit and what amount counts.
- State exclusions and non-duplication rules.
- Add evidence requirements: chat record, payment record, invitation record, approval owner.

### PRD Or SOP

Use when the user asks to turn scattered ideas into a PRD, workflow, or team SOP.

Checklist:

- State the business problem.
- Name the roles involved.
- Convert chat language into stable requirements.
- Add acceptance criteria or operating checkpoints.
- List unresolved owner/date/metric questions.

### Knowledge Base Cleanup

Use when the user asks what a folder contains or whether documents conflict.

Checklist:

- Build a module map.
- Identify canonical docs versus old drafts.
- Flag duplicate or conflicting rules.
- Recommend which document should become the source of truth.

## Common Mistakes

- Do not merge old and new policies without preserving effective dates.
- Do not treat "discussed" as "approved" unless the source clearly says it is approved.
- Do not bury conflicts in a polished draft; show them before making final edits.
- Do not use generic wording when numbers, dates, owners, and evidence requirements are the real decision.
