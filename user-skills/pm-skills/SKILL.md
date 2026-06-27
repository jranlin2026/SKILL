---
name: pm-skills
description: Product management workflows for PRDs, feature specs, user stories, acceptance criteria, roadmap planning, prioritization, CRM/SaaS requirement design, stakeholder analysis, and product review. Use when the user asks for a product plan, PRD, requirements document, MVP scope, version plan, acceptance criteria, business process design, or product manager style analysis.
---

# PM Skills

Use this skill to turn product ideas into structured product work.

## Core Outputs

Choose the smallest useful output for the request:

- Product brief
- PRD
- MVP scope
- Version roadmap
- User stories
- Acceptance criteria
- Permission matrix
- Data model notes
- Page structure
- Test scenarios

## PRD Structure

For CRM/CMR/internal tools, prefer:

1. Background and goal
2. Users and roles
3. Core workflow
4. Page structure
5. Data fields
6. Permissions and data scope
7. Edge cases
8. Acceptance criteria
9. Non-goals
10. Version plan

## Acceptance Criteria Pattern

Write acceptance criteria as observable behavior:

- Given a user role and data state
- When the user performs an action
- Then the system shows, changes, records, or blocks something

Example:

```text
Given 销售只能查看本人客户
When 销售进入客户列表
Then 系统只展示 owner_user_id 为当前用户的客户
```

## CRM Product Checks

Before considering a CRM requirement complete, check:

- Who owns the data?
- Who can see it?
- Who can change it?
- What status changes?
- What audit log is required?
- What happens after employee transfer or resignation?
- What report or metric depends on it?

