---
name: harness-setup
description: >-
  Use when setting up agent rules on a new machine or harness, probing harness
  capabilities, populating harness.md, harness-neutral setup, discovering
  SKILLS_DISCOVERY_ROOT, LOCAL_RULES_DIR, ALWAYS_ON_RULES, first-time
  agent-rules install, polyglot harness, Cursor Claude Hermes T3code,
  template vs machine boundary, or before editing templates with machine paths.
---

# Harness setup

Probe **this workstation's active harness**, populate **`$CODE_ROOT/harness.md`**, and respect the **template vs machine-local** division in `general/harness-boundary.md`.

## When to run

- First clone of `agent-rules` on a machine
- User switches harness (Cursor → Claude Code, etc.)
- Agent is about to edit templates and machine paths are not yet recorded
- `$CODE_ROOT/harness.md` is missing or clearly stale

## Step 1 — Resolve CODE_ROOT

Read the active machine profile in the user's fork (`profiles/<machine>.md`) or probe:

- Windows: `$env:code`, `$env:CODE_ROOT`
- Else: common hive roots the user mentions

If unknown, ask once; then record in the fork profile **and** reference from `harness.md` — not in upstream templates.

## Step 2 — Discover harness capabilities

Best-effort probe (use whatever the harness exposes):

| Question | Record as |
| --- | --- |
| What harness is running? | `HARNESS_NAME` |
| Where are always-on rules injected? | `ALWAYS_ON_RULES` |
| Is there a skill discovery directory? | `SKILLS_DISCOVERY_ROOT` |
| Machine-local rules overlay path? | `LOCAL_RULES_DIR` |
| How to link canonical skills? | `SKILLS_INSTALL` |
| File links in chat? | `CHAT_FILE_LINKS` |
| Line-range code citations? | `CODE_CITATION` |
| In-repo IDE rules format? | `IDE_PROJECT_RULES` |
| Context7 MCP available? | `MCP_CONTEXT7` |
| Token provenance emit/consume? | `TOKEN_PROVENANCE` (`emit-spans`, `consume-spans`, `off`) |

**Cursor-like harnesses** often expose: User Rules, `~/.cursor/skills`, `~/.cursor/rules`, `.mdc` project rules, markdown workspace links, line-range citation fences.

**Other harnesses** may load skills only by direct file read — set `SKILLS_DISCOVERY_ROOT = none` and document that in `harness.md`.

Do not assume Cursor. Discover and record.

## Step 3 — Write `$CODE_ROOT/harness.md`

Create or update from `harness.example.md` at `$AGENT_RULES_PATH`. Use concrete paths on **this machine only**.

Never write these values into `user.md`, `AGENTS.md`, `general/*`, `agents/*`, or upstream `profiles/*` templates.

## Step 4 — Install skills (if applicable)

When `SKILLS_DISCOVERY_ROOT` is set and `SKILLS_INSTALL` supports linking:

1. Read `skills/CATALOG.md` for team skills needed.
2. Link `$AGENT_RULES_PATH/skills/<name>/` → discovery root per `harness.md`.
3. Follow `skills/BOOTSTRAP.md` for house conventions.

Ongoing drift (missing links, behind origin, stale `AGENT_RULES_SYNCED_SHA`): skill **`sync-agent-rules`**.

## Step 5 — Verify boundary awareness

Confirm the agent will:

- Load `general/harness.md` + `general/harness-boundary.md` during MAIN assembly
- Route workstation facts → `$CODE_ROOT/machine.md`
- Route harness config → `$CODE_ROOT/harness.md`
- Load skills from `$AGENT_RULES_PATH/skills/<name>/` on demand when discovery is unavailable

## Editing templates — stop checklist

Before committing changes under `$AGENT_RULES_PATH`:

- [ ] No concrete paths, usernames, or harness names in forkable files (unless placeholder)
- [ ] Harness-specific install steps live in `harness.md` or harness-local overlay, not in skill policy bodies
- [ ] New always-on content is a one-line pointer, not a skill body dump

## Do not

- Paste `harness.md` into always-on rules — at most one line: “Read `$CODE_ROOT/harness.md` when harness behavior matters.”
- Commit `$CODE_ROOT/harness.md` or `$CODE_ROOT/machine.md`
- Hardcode Cursor paths in upstream PRs
