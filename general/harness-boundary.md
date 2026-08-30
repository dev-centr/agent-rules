# Template vs machine-local boundary

<!---
BOUNDARY MANIFEST — what agents may edit in forkable templates vs machine-only files.
Load before any edit under $AGENT_RULES_PATH when the change might embed workstation facts.
--->

## The division

**Layered geography:** `$AGENT_RULES_PATH` is the **shared reference** (team clone — skills + portable/org templates). A **personal fork** is an optional **overlay** (`profiles/<machine>.md`, personal tweaks, personal-only skills) — not a full mirror that must stay at HEAD parity with the template. Machine facts stay outside both. Illustrated: docs `harness-neutral.adoc` (`rules-geography.svg`).

```text
┌─────────────────────────────────────────────────────────────────┐
│  SHARED REFERENCE ($AGENT_RULES_PATH — PR upstream)             │
│  user.md · AGENTS.md · general/* · agents/* · skills/* bodies  │
│  profiles/*-template.md · profiles/team-default.md · *.example  │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ never write machine values here
                              │
┌─────────────────────────────────────────────────────────────────┐
│  PERSONAL OVERLAY (optional fork — deltas only)                 │
│  profiles/<machine>.md · personal user.md tweaks · solo skills │
└─────────────────────────────────────────────────────────────────┘
                              ▲
┌─────────────────────────────────────────────────────────────────┐
│  MACHINE-LOCAL (this user's machine; gitignored at CODE_ROOT)   │
│  $CODE_ROOT/harness.md · $CODE_ROOT/machine.md                 │
│  LOCAL_RULES_DIR overlay                                        │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ project facts go to repo AGENTS.md + docs
                              │
┌─────────────────────────────────────────────────────────────────┐
│  PROJECT (committed in the repo being edited)                   │
│  <repo>/AGENTS.md · README · docs · STYLE.adoc (thin pointer)   │
└─────────────────────────────────────────────────────────────────┘
```

## Never put in forkable templates

- Concrete `CODE_ROOT`, drive letters, usernames, hostnames
- `HARNESS_NAME`, skill discovery paths, always-on injection paths
- Tool install locations, PATH gaps, hardware quirks
- Secret values (even in examples — use placeholders)
- Personal identity (“Treat the user as …”) — belongs in `LOCAL_RULES_DIR` overlay

## Always use placeholders in upstream examples

| Bad (committed template) | Good |
| --- | --- |
| `Z:\code\github.com\AMDphreak\.issues` | `$ISSUES_REPO` or `<path-to-.issues-repo>` |
| `~/.cursor/skills/` | `$SKILLS_DISCOVERY_ROOT` or “per `harness.md`” |
| `Cursor Settings User Rules` | `$ALWAYS_ON_RULES` or “always-on rules slot” |
| `amdphreak` | `<your-github-username>` or `$GITHUB_USER` |

## When the user asks to “save a rule”

Use skill **`record-rule`**. Pick scope:

| Scope | Where |
| --- | --- |
| Portable | `user.md` one-liner + `general/<slug>.md` |
| Org | `AGENTS.md` or `agents/<topic>.md` |
| Project | `<repo>/AGENTS.md` |
| Harness-local IDE | `$LOCAL_RULES_DIR` or `<repo>/.cursor/rules/*.mdc` per `IDE_PROJECT_RULES` |
| Workstation fact | `$CODE_ROOT/machine.md` |
| Harness config | `$CODE_ROOT/harness.md` |

## Before editing agent-rules

1. Read `$CODE_ROOT/harness.md` and `$CODE_ROOT/machine.md`.
2. Ask: “Is this forkable policy or this machine only?”
3. If machine-only → write the machine file, **not** the template.
4. If unsure → ask the user; default to narrowest scope.

## Setup missing?

Run skill **`harness-setup`** to probe the active harness and create/update `$CODE_ROOT/harness.md`.
