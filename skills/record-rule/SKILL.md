---
name: record-rule
description: >-
  Use when the user says make that a rule, save this rule, record a rule,
  add a rule, create a rule, write a rule, persist this preference,
  remember this, add to agent-rules, AGENTS.md rule, user.md update,
  update AI rules, update agent skills, sync harness and template,
  harness boundary, harness.md, or wants to persist an instruction across sessions.
---

# Record a rule

When the user says "make that a rule" (or similar), persist the instruction so it survives across sessions.

Read `general/harness-boundary.md` first.

## Where rules go

| Scope | Where | Format |
| --- | --- | --- |
| **Portable** (all coding work, all orgs) | `agent-rules/user.md` (one-liner) + `agent-rules/general/<slug>.md` (detail) | Markdown |
| **Org** (one org's repos) | `agent-rules/AGENTS.md` or `agent-rules/agents/<topic>.md` | Markdown |
| **Project** (one repo) | `<repo>/AGENTS.md` | Markdown |
| **Harness-local IDE** | `$LOCAL_RULES_DIR` or `<repo>/.cursor/rules/*.mdc` per `IDE_PROJECT_RULES` in `$HARNESS` | per harness |
| **Workstation fact** | `$CODE_ROOT/machine.md` | Markdown |
| **GitHub access cache** (identity, per-repo permission/route) | `$CODE_ROOT/machine.md` (`<!-- github-access:begin -->` block) | Markdown — skill `github-repo-access` |
| **Harness config** | `$CODE_ROOT/harness.md` | Markdown |

Pick the narrowest scope. If unclear, ask.

## Steps

1. **Identify the rule.** State it back in one sentence.
2. **Determine scope.** Portable, org, project, harness-local, workstation, or harness config?
3. **Write the file(s).** Never put machine paths in forkable templates.
4. **Cross-post when useful.** Portable detail + harness-local summary in `$LOCAL_RULES_DIR` when the harness supports it.
5. **Commit and push** if the user has been committing in this session.

## Do not

- Paste full rule bodies into `user.md` or `AGENTS.md`
- Record machine paths in forkable templates — use `machine.md` or `harness.md`
- Duplicate without searching `general/*.md`, `agents/*.md`, and harness-local overlays first
