---
name: jixiangos-release-notes
description: Use when preparing JixiangOS update notices, changelogs, release notes, team announcements, policy change summaries, product update briefs, SOP change notices, or department-specific rollout messages for sales, finance, customer success, operations, or leadership.
---

# JixiangOS Release Notes

## Overview

Use this skill to turn JixiangOS changes into team-ready update notes. Focus on what changed, who is affected, when it takes effect, what action is required, and what evidence or owner confirms the change.

## Inputs To Gather

Prefer concrete sources before drafting:

- Changed policy, SOP, PRD, spreadsheet, code, or knowledge-base file
- Chat screenshots or meeting notes that caused the change
- Effective date and version/month
- Target audience: sales, finance, customer success, operations, product, leadership, or all staff
- Desired tone: formal policy notice, concise team announcement, product release note, or executive summary

If source material is messy, use `jixiangos-context-pack` first.

## Workflow

1. Identify the audience and purpose.
2. Compare old and new material when possible. Use file paths, dates, and headings to anchor the change.
3. Classify each change:
   - Added
   - Changed
   - Removed
   - Clarified
   - Effective-date change
   - Owner or evidence requirement change
4. Write for action, not decoration. Each note should make clear what the team must do differently.
5. Add a confirmation section when rules affect money, commissions, customer ownership, delivery responsibility, or finance settlement.

## Standard Output

Use this shape for internal policy and SOP changes:

```markdown
# [JixiangOS] [Month/Version] Update Notice

Effective date: [date]
Audience: [team/role]
Owner: [person/team if known]

## Summary
- [One-line high-impact change]

## What Changed
- [Added/Changed/Removed/Clarified]: [specific change]

## Who Is Affected
- [role/team/customer type]

## What To Do Now
- [action sales/customer success/finance/ops must take]

## Examples
- [formula, scenario, or before/after]

## Evidence Required
- [chat record/payment record/approval/customer source/etc.]

## Open Questions
- [only include if unresolved]
```

## Audience Variants

### Sales Notice

Emphasize:

- Customer source and ownership
- Performance amount and formula
- Non-duplication rules
- Required chat/payment/invitation evidence
- Effective date and transition handling for old customers

### Finance Notice

Emphasize:

- Settlement formula
- Payment channel and receipt evidence
- Approval owner
- Excluded cases
- Audit trail

### Customer Success / Operations Notice

Emphasize:

- Handoff responsibility
- Service checkpoints
- Customer group or CRM records to update
- What screenshots or records prove completion

### Product / JixiangOS Software Notice

Emphasize:

- New capability
- Changed workflow
- User-visible impact
- Migration or data cleanup needs
- Known limitations

## Style Rules

- Write in clear Chinese unless the user requests English.
- Keep the opening short; put the operational details in bullets.
- Use exact dates, amounts, formulas, owners, and affected roles.
- Avoid marketing language for internal制度/SOP notices.
- If a change is not confirmed, label it as "待确认" instead of presenting it as final.
- For monthly policies, preserve the month/version in the title.

## Common Scenarios

### Monthly Commission Update

Use when a sales or finance rule changes.

Minimum sections:

- 生效时间
- 适用对象
- 核算口径
- 示例
- 不重复计算规则
- 所需凭证
- 待确认事项

### Weekly JixiangOS Product Update

Use when summarizing product or system changes.

Minimum sections:

- 本周新增
- 本周调整
- 对团队的影响
- 需要跟进
- 下周风险

### Leadership Summary

Use when the user wants a short decision memo.

Minimum sections:

- 本次变化
- 为什么改
- 影响范围
- 需要拍板的问题
- 建议决策

## Common Mistakes

- Do not list file changes without explaining operational impact.
- Do not hide unresolved questions in polished language.
- Do not mix old and new versions without an effective date.
- Do not say "统一按新规则" when transition customers need separate handling.
