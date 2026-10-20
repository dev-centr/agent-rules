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

| OS | Default workspace root when unset |
| --- | --- |
| Windows | `%LOCALAPPDATA%\AgentWorkspace` |
| Linux / macOS | `$XDG_STATE_HOME/AgentWorkspace` or `~/.local/state/AgentWorkspace` |

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

## Harness obligation

Document **`AGENT_WORKSPACE_ROOT`**, **`AGENT_TEMP_ROOT`**, and utility entry paths in **`harness.md`**. Skill **`harness-setup`** records them on probe.
