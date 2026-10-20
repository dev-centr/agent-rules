---
name: agent-temp
description: >-
  Use when writing a temp file, scratch file, curl -o, shell redirect, probe
  script, CSV dump, large output capture, agent-tools spill path in tool output,
  spill-registry.json, or any agent-chosen path outside a git commit;
  AGENT_TEMP_ROOT, manual/, global agent temp, avoid profile litter.
---

# Agent temp

See **`general/agent-temp.md`** for the full two-track model (platform vs agent-chosen).

## Agent-chosen temp (`manual/`)

When **you** pick the path:

1. Read **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md`.
2. Write under **`{AGENT_TEMP_ROOT}/manual/{YYYY-MM-DD}/{purpose}-….{ext}`**.
3. PowerShell: **`$env:USERPROFILE`**, **`$env:LOCALAPPDATA`** — never `%userprofile%`.

## Platform spill (harness hard-coded)

When a **tool result names a spill file** (e.g. Cursor Shell → `…/agent-tools/{uuid}.txt`):

1. Read **`HARNESS_NAME`** from `$HARNESS`.
2. Run **`$AGENT_RULES_PATH/scripts/update-spill-registry.ps1`** once per distinct platform directory (update on later spills with **`-LastArtifact`**):

```powershell
& "$env:code\github.com\dev-centr\agent-rules\scripts\update-spill-registry.ps1" `
  -Id 'cursor:projects:<slug>' `
  -Harness '<HARNESS_NAME>' `
  -PlatformPath '<junction or platform dir>' `
  -UnifiedPath '<AGENT_TEMP_ROOT>\cursor\projects\<slug>\agent-tools' `
  -WorkspaceSlug '<slug>' `
  -LastArtifact '<file-if-known>' `
  -RecordedBy agent
```

Use **`cursor:home`** when the path is profile `agent-tools`. If slug is unknown, derive from the path or use a stable id from **`platformPath`**.

3. Continue work using that path; cite **`unifiedPath`** under `AGENT_TEMP_ROOT` when helpful.

Junction setup (Cursor Windows): **`scripts/link-cursor-agent-temp.ps1`** — also registers known paths as **`link-script`**.
