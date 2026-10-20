---
name: agent-temp
description: >-
  Use when writing temp files, scratch files, curl -o, redirects, large output
  captures, platform agent-tools paths in tool results, AGENT_TEMP_ROOT,
  scratch/, harness-registry.json5, harness registry; global agent temp policy.
---

# Agent temp

Read **`general/agent-temp.md`**.

## Agent scratch / temp (not spill)

Required location for working files you author:

1. **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md` (workspace `temp/` — default `%LOCALAPPDATA%\AgentWorkspace\temp` on Windows; see `general/agent-workspace.md`).
2. Write only under **`scratch/YYYY-MM-DD/{purpose}-….{ext}`**.
3. Never `$env:TEMP`, profile root, or repo scratch unless committing.

## Platform temp (hard-coded / spill)

**Spill** = harness-written overflow files the agent did not choose (often under `agent-tools`). **Do not move** spill and **do not mirror** it under `AGENT_TEMP_ROOT`.

- Concrete spill paths usually appear **in tool output** when the harness writes them; trust that path for the session.
- **`harness-registry.json5`** (optional, at `AGENT_TEMP_ROOT`): machine-local cheat sheet — **one `spillRoot` per harness** (pattern), not a workspace catalog. Keep the file’s top `// Background` comment (what spill is). Update on harness change or probe, not every new project folder.

## One-off machine cleanup

Skill **`agent-workspace-migrate`** — profile litter, legacy temp root, utilities relocation (`general/agent-workspace-migrate.md`).
