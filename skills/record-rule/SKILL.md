---
name: record-rule
description: >-
  Use when the user says make that a rule, save this rule, record a rule,
  add a rule, create a rule, write a rule, persist this preference,
  remember this, add to agent-rules, .cursor/rules, AGENTS.md rule,
  RULES.md update, or wants to persist an instruction across sessions.
---

# Record a rule

When the user says "make that a rule" (or similar), persist the instruction so it survives across sessions and works for any team member's AI agent.

## Where rules go

Rules land in up to three places depending on scope:

| Scope | Where | Format |
| --- | --- | --- |
| **Portable** (all coding work, all orgs) | `agent-rules/RULES.md` (one-liner) + `agent-rules/general/<slug>.md` (detail) | Markdown |
| **Org** (one org's repos) | `agent-rules/AGENTS.md` or `agent-rules/agents/<topic>.md` | Markdown |
| **Project** (one repo) | `<repo>/AGENTS.md` | Markdown |
| **Cursor-specific** (IDE rule) | `<repo>/.cursor/rules/<slug>.mdc` | `.mdc` (YAML frontmatter + markdown) |

Pick the narrowest scope that covers the intent. If the user doesn't specify, ask.

## Steps

1. **Identify the rule.** Pull the instruction from chat context. State it back to the user in one sentence to confirm.
2. **Determine scope.** Portable, org, project, or Cursor-specific? If unclear, ask using AskQuestion.
3. **Write the rule file(s).**
   - For portable: add a one-line summary to `RULES.md` under the right section, and create `general/<slug>.md` with the full text.
   - For org: add to the org `AGENTS.md` or create `agents/<topic>.md`.
   - For project: add to `<repo>/AGENTS.md`.
   - For Cursor: create `.cursor/rules/<slug>.mdc` with proper frontmatter (`description`, `alwaysApply`, optional `globs`).
4. **Cross-post when useful.** If the rule is portable *and* the current repo benefits from a Cursor `.mdc` version, create both.
5. **Commit and push** if the user has been committing/pushing in this session. Otherwise, leave unstaged and tell them what was written where.

## Junction to ~/.cursor/skills

After creating or updating this skill in `agent-rules/skills/record-rule/`, junction it:

```powershell
cmd /c mklink /J "$env:USERPROFILE\.cursor\skills\record-rule" "$env:code\github.com\dev-centr\agent-rules\skills\record-rule"
```

## Do not

- Do not paste the full rule body into `RULES.md` or `AGENTS.md` — those are summaries with pointers to detail files.
- Do not create duplicate rules. Search existing `general/*.md`, `agents/*.md`, and `.cursor/rules/*.mdc` first.
- Do not record machine-specific paths as rules. Those go in `MEMORIES.md`.
