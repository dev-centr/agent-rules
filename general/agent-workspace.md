# Agent workspace (machine-local tree)

<!---
Portable policy: one folder on the workstation for agent-facing utilities and temp.
Paths: $CODE_ROOT/harness.md → AGENT_WORKSPACE_ROOT, AGENT_TEMP_ROOT, AGENT_UTILITIES_ROOT.
Detail for scratch/spill: general/agent-temp.md. Skill agent-temp.
--->

## Purpose

**Agent workspace** = this machine’s **agent-operated** files: utilities the harness runs on your behalf, plus disposable scratch/temp. It is **not** the code hive (`CODE_ROOT`), **not** harness spill (`.cursor/…/agent-tools`), and **not** a substitute for committed project files.

## Resolve paths

Read from **`$CODE_ROOT/harness.md`**:

| Variable | Role |
| --- | --- |
| **`AGENT_WORKSPACE_ROOT`** | Root of the tree |
| **`AGENT_TEMP_ROOT`** | Temp subfolder (`$AGENT_WORKSPACE_ROOT/temp`) — scratch + optional spill registry |
| **`AGENT_UTILITIES_ROOT`** | Utilities subfolder (`$AGENT_WORKSPACE_ROOT/utilities`) — scripts/tools agents invoke |
| **`AGENT_WORKSPACE_LINK`** (optional) | Discoverability path under home — junction (Windows) or symlink (Linux/macOS) to **`AGENT_WORKSPACE_ROOT`** |

| OS | Default **canonical** root when unset |
| --- | --- |
| Windows | `%LOCALAPPDATA%\AgentWorkspace` |
| Linux / macOS | `$XDG_STATE_HOME/AgentWorkspace` or `~/.local/state/AgentWorkspace` |

**Discoverability:** keep canonical data under AppData / XDG state (clean profile). Add **`AGENT_WORKSPACE_LINK`** so users and docs can use **`%USERPROFILE%\AgentWorkspace`** or **`~/AgentWorkspace`** without duplicating the tree.

| OS | Link path (typical) | Mechanism |
| --- | --- | --- |
| Windows | `%USERPROFILE%\AgentWorkspace` | Directory **junction** → canonical root |
| Linux / macOS | `$HOME/AgentWorkspace` | **Symlink** → canonical root |

Create the link only after the canonical tree exists; if home already has a **real** folder at the link path, run **`agent-workspace-migrate`** first. Skill **`agent-workspace-global`** covers new machine-global tools and link setup.

Record concrete paths in **`harness.md` only**.

## Layout

```text
AGENT_WORKSPACE_ROOT/
  README.md                     # machine-local index (this tree)
  utilities/                    # agent-invoked scripts (Bitwarden entry, helpers, …)
    <topic>/                    # e.g. bitwarden/
  temp/                         # AGENT_TEMP_ROOT — see general/agent-temp.md
    README.md
    harness-registry.json5      # optional: one spill root per harness
    scratch/YYYY-MM-DD/
```

**Do not** put platform spill under this tree. **Do not** commit secrets into `utilities/` — use local secret files gitignored on the machine.

## Moving profile utilities

When scripts at **`$env:USERPROFILE`** exist only for agents (unlock helpers, probes, session stores), prefer **`AGENT_UTILITIES_ROOT/<topic>/`** and point **`harness.md`** entries (e.g. `BITWARDEN_AGENT_ENTRY`) at the new path. Update machine **`LOCAL_RULES_DIR`** overlays; keep user shortcuts (`.lnk`) in the profile if they are for you, not the agent.

**New** machine-global agent tools: skill **`agent-workspace-global`** — intercept profile-root sprawl unless the user explicitly opts out.

## Migration and cleanup

Legacy profile clutter, flat **`AgentTemp`**, or utilities still in **`$HOME`** / profile root: skill **`agent-workspace-migrate`** (`general/agent-workspace-migrate.md`). Requires user-visible **plan**, **safety probes**, and confirmation that **no parallel agents** are touching the same paths. No shared cleanup scripts in this repo.

## Harness obligation

Document **`AGENT_WORKSPACE_ROOT`**, **`AGENT_TEMP_ROOT`**, and utility entry paths in **`harness.md`**. Skill **`harness-setup`** records them on probe; if layout is legacy, point the user at **`agent-workspace-migrate`**.
