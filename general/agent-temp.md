# Global agent temp location

<!---
Portable policy: one harness-neutral tree for temporary files.
Machine path: $CODE_ROOT/harness.md → AGENT_TEMP_ROOT.
Skill agent-temp — no cleanup scripts in this repo; one-off machine tidying is ad hoc.
--->

## Two tracks

| Track | Who picks the path | Agent obligation |
| --- | --- | --- |
| **Platform temp** | Harness/IDE (hard-coded) | Do **not** move, rename, or “organize” it. Do **not** invent alternate platform paths. |
| **Unified temp** | **Any agent / any harness** (everything else) | **Required:** `AGENT_TEMP_ROOT/manual/YYYY-MM-DD/…` or `harness/<name>/…` only. |

Platform-hard-coded → under **`AGENT_TEMP_ROOT/cursor/…`** when the workstation junctions harness spill there (machine setup — not forkable). Everything else → **`manual/`** — not `$env:TEMP`, profile root, repos, or `%userprofile%`.

## Resolve the root

Read **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md`.

| OS | Default when unset |
| --- | --- |
| Windows | `%LOCALAPPDATA%\AgentTemp` |
| Linux / macOS | `$XDG_STATE_HOME/AgentTemp` or `~/.local/state/AgentTemp` |

Record the concrete path in **`harness.md` only**.

## Layout

```text
AGENT_TEMP_ROOT/
  cursor/                   # platform-hard-coded (do not move contents)
  manual/YYYY-MM-DD/          # all non-platform temp
  harness/<harness-name>/     # optional non-Cursor harness temp
  harness-registry.json       # optional; platform paths only (see below)
```

## Before writing non-platform temp

Load skill **`agent-temp`**.

1. **`manual/YYYY-MM-DD/`** + **`{purpose}-….{ext}`**
2. PowerShell: **`$env:USERPROFILE`**, **`$env:LOCALAPPDATA`** — never **`%userprofile%`**
3. Cite the full path when the user should open the file

## Platform spill paths (optional registry)

When tool output names a platform spill file, you may append/update **`harness-registry.json`** at `AGENT_TEMP_ROOT` (paths only, no secrets): `harness`, `platformPath`, `unifiedPath`, `lastSeen`, optional `lastArtifact`. Edit JSON directly — once per path per session is enough.

## Anti-patterns

- Moving or archiving **`cursor/`** platform spill
- `$env:TEMP`, profile root scratch, repo root scratch (unless committing)
- Cmd-style **`%userprofile%`** in PowerShell

## Harness obligation

Document **`AGENT_TEMP_ROOT`** in `$CODE_ROOT/harness.md`. Skill **`harness-setup`** records it on probe.

## Cleanup

Temp is disposable. **Past clutter on a workstation** (profile root, old spill) is a **one-off** — use AI with an explicit per-file plan for that machine; do not rely on shared cleanup scripts in agent-rules.
