# Global agent temp location

<!---
Portable policy: one harness-neutral tree for temporary files.
Machine path: $CODE_ROOT/harness.md → AGENT_TEMP_ROOT.
Skill agent-temp loads for agent-chosen paths (not platform-hard-coded spill).
--->

## Two tracks (do not confuse them)

| Track | Who picks the path | Agent obligation |
| --- | --- | --- |
| **Platform temp** | The harness/IDE (hard-coded) | Do **not** invent alternate platform paths. On Windows + Cursor, run/maintain `scripts/link-cursor-agent-temp.ps1` so hard-coded `agent-tools` lands under `AGENT_TEMP_ROOT/cursor/…`. |
| **Agent temp** | **You** (every `Write`, redirect, `curl -o`, probe script, CSV dump, etc.) | **Always** place under `AGENT_TEMP_ROOT/manual/…` (or `harness/<name>/…`). This rule exists because agents otherwise panic and pick arbitrary locations. |

Platform overflow you did not author belongs in **`cursor/`**. Anything **you** create because output is large, awkward in chat, or “just for this step” belongs in **`manual/`** — not `$env:TEMP`, not profile root, not repo root, not `%userprofile%` literals.

## Resolve the root

When `$CODE_ROOT` is known, read **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md`.

| OS | Default when unset |
| --- | --- |
| Windows | `%LOCALAPPDATA%\AgentTemp` |
| Linux / macOS | `$XDG_STATE_HOME/AgentTemp` or `~/.local/state/AgentTemp` |

Record the concrete path in **`harness.md` only** — never in forkable templates.

**Legacy:** `AGENT_SPILL_ROOT` / `AgentSpill` → migrate to `AGENT_TEMP_ROOT` / `AgentTemp`.

## Layout

```text
AGENT_TEMP_ROOT/
  cursor/                   # platform-hard-coded (junction targets only)
    home/agent-tools/
    projects/<slug>/agent-tools/
  manual/                   # agent-chosen temp (organized)
    YYYY-MM-DD/
      <purpose>-<shortid>.<ext>
  harness/<harness-name>/   # non-Cursor harness agent temp
```

## Before any agent-chosen temp file

Load skill **`agent-temp`** when you are about to write scratch data outside a normal repo commit.

1. Resolve **`AGENT_TEMP_ROOT`** from `$HARNESS` (defaults above if missing).
2. Pick **`manual/YYYY-MM-DD/`** (today, UTC or local — be consistent within the run).
3. Name **`{purpose}-{optional-id}.{ext}`** — purpose is required (`tsc-errors-career-journey.txt`, not `out.txt`).
4. Use **absolute paths** built with `$env:USERPROFILE` / `$env:LOCALAPPDATA` in PowerShell — never `%userprofile%`.
5. Tell the user the **full path under `manual/`** when they need to open it.

## Anti-patterns (panic picks — do not use)

- `$env:TEMP`, `/tmp`, or OS temp for **agent scratch** (OS and installers only)
- `%USERPROFILE%\agent-tools` by hand (platform junction only)
- New folders under profile root (`C:\Users\…\something-scratch\`)
- Paths inside **`$CODE_ROOT`** or **git repos** unless the task is to **commit** that file
- Cmd-style **`%userprofile%`** in PowerShell (creates a literal `%userprofile%` directory)
- Copying repo source into temp “to edit safely” — use the repo or a git worktree instead

## Platform temp (Cursor on Windows)

Cursor writes oversized tool output to fixed **`agent-tools`** paths. Agents cannot reconfigure that in rules.

**Setup:** `$AGENT_RULES_PATH/scripts/link-cursor-agent-temp.ps1` after `AGENT_TEMP_ROOT` is set — junctions into `AGENT_TEMP_ROOT/cursor/…`, migrates legacy `AgentSpill`. Re-run when new `.cursor/projects/<slug>` workspaces appear.

## Harness obligation

Document **`AGENT_TEMP_ROOT`** in `$CODE_ROOT/harness.md`. Skill **`harness-setup`** records it on probe and mentions the link script for Cursor.

## Cleanup

Temp is disposable. Prune old `manual/` and `cursor/` captures when disk space matters. Never commit temp contents to git.
