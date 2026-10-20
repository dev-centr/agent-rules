---
name: agent-workspace-global
description: >-
  Use when creating machine-global agent tools, profile root agent scripts,
  home directory agent utilities, install agent helper globally, put script
  in USERPROFILE, dot-source from profile, machine-wide agent script, global
  agentic tool, agent PATH utility, unless user says override workspace policy
  or keep in profile root explicitly.
---

# Agent workspace global tools

**Default:** machine-global **agent-operated** tools belong in the **agent workspace**, not scattered at **`$HOME`** / profile root. Load this skill **before** creating or installing such tools unless the user **explicitly opts out** (see below).

Read **`general/agent-workspace.md`**. Scratch/temp: skill **`agent-temp`**. Migration: skill **`agent-workspace-migrate`**.

## Where new tools go

| Kind | Location |
| --- | --- |
| Scripts, unlock helpers, probes, CLI wrappers agents run | **`AGENT_UTILITIES_ROOT/<topic>/`** |
| Disposable output, plans, manifests | **`AGENT_TEMP_ROOT/scratch/YYYY-MM-DD/`** |
| Harness spill (`agent-tools`, …) | **Native harness paths only** — never workspace |

Record entry paths in **`$CODE_ROOT/harness.md`** (e.g. `BITWARDEN_AGENT_ENTRY`). Update **`LOCAL_RULES_DIR`** overlays to cite full paths.

## Discoverability link (canonical vs easy path)

**Canonical data** lives at **`AGENT_WORKSPACE_ROOT`** (see harness). Humans and docs may use a **short path** under home:

| OS | Mechanism | Typical link path | Canonical root (default) |
| --- | --- | --- | --- |
| Windows | **Directory junction** | `%USERPROFILE%\AgentWorkspace` | `%LOCALAPPDATA%\AgentWorkspace` |
| Linux / macOS | **Symlink** | `$HOME/AgentWorkspace` | `$XDG_STATE_HOME/AgentWorkspace` or `~/.local/state/AgentWorkspace` |

Document in **`harness.md`**: **`AGENT_WORKSPACE_LINK`** = link path (optional). Agents may use either link or canonical path if both resolve to the same tree.

**Create link (after canonical tree exists):**

```powershell
# Windows — junction; fails if profile path already exists as a real folder
cmd /c mklink /J "%USERPROFILE%\AgentWorkspace" "%LOCALAPPDATA%\AgentWorkspace"
```

```bash
# Linux / macOS — symlink; remove empty wrong target first
ln -snf "${XDG_STATE_HOME:-$HOME/.local/state}/AgentWorkspace" "$HOME/AgentWorkspace"
```

Do not replace an existing **directory with files** — migrate first (**`agent-workspace-migrate`**), then link.

## User override (do not intercept)

Honor explicit opt-out, e.g. **“put it in profile root anyway”**, **“ignore agent workspace policy”**, **“this must live in `/usr/local/bin`”**. Confirm once, then follow the user; do not scatter **multiple** agent utilities at profile root without their intent.

## Anti-patterns

- New `.ps1` / `.sh` at profile root “for the agent” without a topic folder under **`utilities/`**
- Adding agent temp under `$HOME` outside **`temp/scratch/`**
- Mirroring spill into the workspace
- Skipping **`harness.md`** when adding a new global entry point
