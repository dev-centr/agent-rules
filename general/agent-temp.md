# Global agent temp location

<!---
Portable policy: one harness-neutral tree for temporary files.
Machine path: $CODE_ROOT/harness.md → AGENT_TEMP_ROOT.
Skill agent-temp — no cleanup scripts in this repo; one-off machine tidying is ad hoc.
--->

## Two tracks (vocabulary)

| Word | Meaning | Location |
| --- | --- | --- |
| **Spill** | Harness overflow the agent **does not control** (hard-coded paths, oversized tool output the IDE writes) | **Native platform paths** (e.g. Cursor `…/agent-tools`, `.cursor/projects/<slug>/agent-tools`) — **do not move or mirror** |
| **Scratch / temp** | Agent **working files** (redirects, probes, analysis dumps you author) | `AGENT_TEMP_ROOT/scratch/YYYY-MM-DD/…` only |

Do not call agent scratch “spill.” Do not put platform spill under `scratch/`. Do **not** relocate spill into `AGENT_TEMP_ROOT` — Cursor and other harnesses expect their own paths.

| Track | Agent obligation |
| --- | --- |
| Platform spill | Do not move, rename, organize, or copy into `AGENT_TEMP_ROOT`. Optional: one spill root per harness in `harness-registry.json5`. |
| Scratch / temp | **Required:** `scratch/…` — not `$env:TEMP`, profile root, repos, or `%userprofile%`. |

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
  README.md                   # machine-local index
  harness-registry.json5      # optional: one spill root per harness (patterns)
  scratch/YYYY-MM-DD/         # agent scratch only
```

## Before writing non-platform temp

Load skill **`agent-temp`**.

1. **`scratch/YYYY-MM-DD/`** + **`{purpose}-….{ext}`**
2. PowerShell: **`$env:USERPROFILE`**, **`$env:LOCALAPPDATA`** — never **`%userprofile%`**
3. Cite the full path when the user should open the file

## Harness registry (optional, JSON5)

**File:** **`harness-registry.json5`** at `AGENT_TEMP_ROOT`. Use **JSON5** (or JSONC-style `//` comments) so the file explains itself — strict `.json` without comments is discouraged.

**Purpose:** machine-local cheat sheet of **where each harness spills** — **one spill root per harness**, not a catalog of every workspace or artifact. It does not list `scratch/` files. Patterns or paths only — never secrets or file bodies.

**How agents learn spill:** when the harness redirects oversized tool output, the **tool result usually cites the concrete file path**. Treat that as authoritative for the session. The registry orients you to the **root pattern** (`HARNESS_NAME` from `$CODE_ROOT/harness.md`); do not enumerate per-repo paths here.

Update the registry when **`HARNESS_NAME` changes**, you add a **second harness**, or probe shows the **platform changed its spill root** — not on every new workspace slug.

```json5
// harness-registry.json5 (machine-local; lives under AGENT_TEMP_ROOT)
//
// Background: Agent harnesses often will dump temporary working content into files
//          in order for long responses to be used by agents to perform temporary
//          analysis. This is called "spill" or "spillage". The spillage should NOT
//          show up inside this AgentTemp folder tree.
//
// Purpose: one spill root per harness (patterns only). See general/agent-temp.md.
{
  schemaVersion: 3,
  agentTempRoot: 'C:\\…\\AgentTemp',
  updated: '2026-10-20T00:00:00Z',
  spillRoots: [
    {
      harness: 'cursor', // matches HARNESS_NAME in harness.md
      spillRoot: '%USERPROFILE%\\.cursor\\projects\\<workspace-slug>\\agent-tools',
      // Windows: Cursor may also use %USERPROFILE%\\agent-tools for some sessions.
    },
  ],
}
```

## Anti-patterns

- Moving, archiving, or **mirroring** platform spill under `AGENT_TEMP_ROOT`
- Junctions that redirect `.cursor/…/agent-tools` into `AgentTemp/` (breaks the “stay where the harness writes” rule)
- `$env:TEMP`, profile root scratch, repo root scratch (unless committing)
- Cmd-style **`%userprofile%`** in PowerShell

## Harness obligation

Document **`AGENT_TEMP_ROOT`** in `$CODE_ROOT/harness.md`. Skill **`harness-setup`** records it on probe.

## Cleanup

Temp is disposable. **Past clutter on a workstation** (profile root, old spill) is a **one-off** — use AI with an explicit per-file plan for that machine; do not rely on shared cleanup scripts in agent-rules.
