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

## Does the agent know platform spill happened?

**Often yes.** On Cursor, when Shell (or similar) output is too large for chat, the tool result usually **names the file path** (under `agent-tools`, often a UUID `.txt`). The same applies to some MCP/CDP responses saved to disk. Treat that path as a signal: the harness wrote platform temp.

**Sometimes no.** The harness may write without surfacing a path in your turn. Known hard-coded locations should already appear in **`spill-registry.json`** after `link-cursor-agent-temp.ps1` (or equivalent for another harness).

**When you see a platform spill path** (in tool output, or when reading/grepping a path the user pasted):

1. Resolve **`HARNESS_NAME`** and **`AGENT_TEMP_ROOT`** from `$HARNESS`.
2. Upsert the path in **`{AGENT_TEMP_ROOT}/spill-registry.json`** via `$AGENT_RULES_PATH/scripts/update-spill-registry.ps1`:
   - **`-Id`**: stable key, e.g. `cursor:projects:<slug>` or `cursor:home`
   - **`-Harness`**: `HARNESS_NAME`
   - **`-PlatformPath`**: path the harness used (junction path is fine)
   - **`-UnifiedPath`**: directory under `AGENT_TEMP_ROOT/cursor/…` if junctions are in use; else same as platform path
   - **`-LastArtifact`**: filename when known (e.g. UUID `.txt` from Shell spill)
   - **`-RecordedBy`**: `agent`
3. Do this **once per path per session** when first observed (update **`lastSeen`** on repeats). Do not spam the registry on every grep of the same file.

Registry is for **analysis across harnesses** — not for secrets; store paths only, not file contents.

### Registry shape (`spill-registry.json`)

```json
{
  "schemaVersion": 1,
  "agentTempRoot": "…",
  "updated": "ISO-8601",
  "entries": [
    {
      "id": "cursor:projects:empty-window",
      "harness": "cursor",
      "kind": "platform-hard-coded",
      "platformPath": "C:\\Users\\…\\.cursor\\projects\\empty-window\\agent-tools",
      "unifiedPath": "C:\\Users\\…\\AppData\\Local\\AgentTemp\\cursor\\projects\\empty-window\\agent-tools",
      "workspaceSlug": "empty-window",
      "recordedBy": "link-script",
      "firstRecorded": "…",
      "lastSeen": "…",
      "lastArtifact": "optional-filename.txt"
    }
  ]
}
```

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

**Setup:** `$AGENT_RULES_PATH/scripts/link-cursor-agent-temp.ps1` after `AGENT_TEMP_ROOT` is set — junctions into `AGENT_TEMP_ROOT/cursor/…`, migrates legacy `AgentSpill`, **seeds/updates `spill-registry.json`**. Re-run when new `.cursor/projects/<slug>` workspaces appear.

## Harness obligation

Document **`AGENT_TEMP_ROOT`** in `$CODE_ROOT/harness.md`. Skill **`harness-setup`** records it on probe and mentions the link script for Cursor.

## Cleanup

Temp is disposable. Prune old `manual/` and `cursor/` captures when disk space matters. Never commit temp contents to git.
