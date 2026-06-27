---
name: superpowers
description: Software development execution workflow for planning, implementing, validating, reviewing, and shipping code changes. Use when the user asks Codex to build features, fix bugs, refactor code, run tests, review a codebase, prepare commits, or manage complex multi-step development tasks.
---

# Superpowers

Use this skill to keep development work disciplined from idea to verified result.

## Workflow

1. Inspect the codebase before deciding.
2. Identify the relevant files, scripts, app framework, and test commands.
3. Make a short plan for substantial work.
4. Implement the smallest coherent change.
5. Run the most relevant verification:
   - type check
   - lint
   - unit test
   - build
   - browser check
6. Summarize what changed, what passed, and what still needs attention.

## Code Review Mode

When the user asks for review, prioritize:

- Bugs
- Regressions
- Data loss
- Security or permission mistakes
- Missing tests
- Risky assumptions

Give file and line references when possible.

## CRM/Internal System Checks

When changing CRM or admin systems, always consider:

- Role and permission impact
- Data ownership and handoff
- Status synchronization
- Audit logging
- Empty states and edge cases
- Import/export behavior
- Production vs test data safety

## Shipping Discipline

- Avoid unrelated refactors.
- Preserve existing patterns unless there is a strong reason.
- Do not claim success without verification.
- If verification cannot run, clearly explain why.

