# Global agent temp location

<!---
Portable policy: one harness-neutral tree for agent and platform temporary files.
Machine path lives in $CODE_ROOT/harness.md as AGENT_TEMP_ROOT.
--->

## Goal

Keep **all agentic temp files** under one **global** root so you can compare sources (Cursor platform vs agent-written vs other harnesses) without littering the profile, `%userprofile%` mistakes, or git repos.

## Resolve the root

On session start (when `$CODE_ROOT` is known), read **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md`.

| OS | Default when unset |
| --- | --- |
| Windows | `%LOCALAPPDATA%\AgentTemp` |
| Linux / macOS | `$XDG_STATE_HOME/AgentTemp` or `~/.local/state/AgentTemp` |

Record the concrete path in **`harness.md` only** — never in forkable templates.

**Legacy name:** `AGENT_SPILL_ROOT` / `AgentSpill` — same role; migrate to `AGENT_TEMP_ROOT` / `AgentTemp` when updating `harness.md`.

## Layout

```text
AGENT_TEMP_ROOT/
  README.md                 # machine-local index (optional)
  cursor/                   # Cursor platform temp (junction targets)
    home/agent-tools/       # home / empty-window workspace
    projects/<slug>/agent-tools/
  manual/                   # agent-authored temp (you control naming)
    YYYY-MM-DD/
      <purpose>-<shortid>.<ext>
  harness/<harness-name>/   # optional temp from non-Cursor harnesses
```

| Subtree | Who writes | Purpose |
| --- | --- | --- |
| `cursor/` | **Cursor** (via directory junctions) | Large shell/WebFetch output the IDE writes to `agent-tools` |
| `manual/` | **Agents** | Intentional temp files, redirected downloads, one-off scripts, analysis CSVs |
| `harness/` | **Other harnesses** | Same idea as `manual/` when a second harness is in use |

## Agent rules (mandatory)

1. **Read** `AGENT_TEMP_ROOT` from `$HARNESS` before creating temp files.
2. **Agent-written** temp goes only under `manual/YYYY-MM-DD/` (or `harness/<name>/` for non-Cursor work). Use a short purpose prefix in the filename (`site-nav-tree-probe.txt`, not `output.txt`).
3. **Never** create or use:
   - `%USERPROFILE%\agent-tools` (except as a **junction** maintained by the link script — do not add new files there by hand)
   - A literal `%userprofile%` directory (PowerShell does **not** expand `%userprofile%`; use `$env:USERPROFILE`)
   - Temp files in `$CODE_ROOT`, the user profile root, or inside git repos (unless the task explicitly commits them)
4. **Prefer a project workspace** over home for coding work so platform temp lands under `cursor/projects/<slug>/` (see home workspace guidance).
5. When you need a path for the user to inspect, cite the path under `AGENT_TEMP_ROOT` and the category (`cursor/…` vs `manual/…`).

## Cursor platform temp (junctions)

Cursor automatically writes oversized tool output to **`agent-tools`** next to the workspace (or under `.cursor/projects/<slug>/agent-tools`). Agents **cannot** retarget that path via rules alone.

**Workstation setup:** run `$AGENT_RULES_PATH/scripts/link-cursor-agent-temp.ps1` (Windows) after setting `AGENT_TEMP_ROOT` in `harness.md`. It:

- Migrates legacy `%LOCALAPPDATA%\AgentSpill` → `AgentTemp` when present
- Creates the `cursor/home` and `cursor/projects/<slug>` directories under `AGENT_TEMP_ROOT`
- Moves existing `agent-tools` contents into those directories
- Replaces the old folders with **directory junctions** so new platform temp still lands in the unified tree

Re-run the script when new Cursor project slugs appear (or add a scheduled/task reminder on the machine).

## Harness obligation

Each harness should document **`AGENT_TEMP_ROOT`** in `$CODE_ROOT/harness.md` and point agents at this file. Skill **`harness-setup`** records the variable on probe.

## Cleanup

Temp content is **disposable**. Prune old `manual/` and `cursor/` UUID captures when disk space matters. Do not commit temp contents to git.
