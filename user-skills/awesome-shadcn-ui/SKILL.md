---
name: awesome-shadcn-ui
description: Design and implementation guidance for React interfaces using shadcn/ui, Tailwind CSS, Radix-style components, dashboard layouts, admin systems, forms, tables, sidebars, dialogs, and component composition. Use when the user asks to build or redesign a UI with shadcn/ui, choose components, create a modern SaaS/admin interface, or translate a product requirement into shadcn-style React components.
---

# Awesome Shadcn UI

Use this skill when a project uses or should use shadcn/ui-style components.

## Component Selection

Prefer familiar shadcn patterns:

- Sidebar: app navigation and module switching
- Table: CRM lists, account ledgers, orders, logs
- Sheet: right-side detail panels
- Dialog: create/edit forms
- Tabs: views and sub-sections
- Command: global search and quick actions
- Dropdown menu: row actions and account menu
- Badge: status, role, risk, lifecycle
- Card: compact repeated summary units only
- Form: validated create/edit workflows
- Toast: lightweight action feedback

## Admin UI Pattern

For CRM/CMR/internal management systems:

```text
Left sidebar
Top search / command bar
Main dense work area
Right detail or AI assistant panel
```

Avoid landing-page composition for operational tools.

## Styling Guidance

- Use restrained spacing and small radius.
- Prefer light borders over heavy shadows.
- Keep tables dense but readable.
- Use status colors sparingly and consistently.
- Avoid one-note purple/blue gradients and decorative blobs.

## Implementation Notes

Before adding a component:

1. Check whether the project already has a component system.
2. Reuse local components first.
3. Match existing Tailwind tokens and layout patterns.
4. Keep forms, tables, filters, pagination, and empty states complete.

