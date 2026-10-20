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
| Platform spill | Do not move, rename, organize, or copy into `AGENT_TEMP_ROOT`. Optional: record paths in `harness-registry.json5`. |
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
  harness-registry.json5      # optional index of native platform spill paths
  scratch/YYYY-MM-DD/         # agent scratch only
```

## Before writing non-platform temp

Load skill **`agent-temp`**.

1. **`scratch/YYYY-MM-DD/`** + **`{purpose}-….{ext}`**
2. PowerShell: **`$env:USERPROFILE`**, **`$env:LOCALAPPDATA`** — never **`%userprofile%`**
3. Cite the full path when the user should open the file

## Harness registry (optional, JSON5)

**File:** **`harness-registry.json5`** at `AGENT_TEMP_ROOT`. Use **JSON5** (or JSONC-style `//` comments) so the file explains itself — strict `.json` without comments is discouraged.

**Purpose:** index **native** hard-coded harness temp paths (platform spill) on this machine. It does not list `scratch/` files. Paths only — never secrets or file bodies.

When tool output names a platform spill path, append or update an entry (once per path per session): `id`, `harness`, `platformPath`, `lastSeen`, optional `lastArtifact`, optional `//` note on the entry.

```json5
// harness-registry.json5 — see general/agent-temp.md
{
  schemaVersion: 1,
  agentTempRoot: 'C:\\…\\AgentTemp',
  updated: '2026-10-20T00:00:00Z',
  entries: [
    {
      id: 'cursor:projects:empty-window',
      harness: 'cursor', // HARNESS_NAME from harness.md
      kind: 'platform-hard-coded',
      platformPath: 'C:\\Users\\…\\.cursor\\projects\\empty-window\\agent-tools',
      lastSeen: '2026-10-20T00:00:00Z',
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
