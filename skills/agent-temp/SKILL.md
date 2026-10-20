---
name: agent-temp
description: >-
  Use when writing temp files, scratch files, curl -o, redirects, large output
  captures, platform agent-tools paths in tool results, AGENT_TEMP_ROOT,
  scratch/, harness-registry.json5, harness registry, profile litter; global agent temp policy.
---

# Agent temp

Read **`general/agent-temp.md`**.

## Agent scratch / temp (not spill)

Required location for working files you author:

1. **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md` (default `%LOCALAPPDATA%\AgentTemp` on Windows).
2. Write only under **`scratch/YYYY-MM-DD/{purpose}-….{ext}`**.
3. Never `$env:TEMP`, profile root, or repo scratch unless committing.

## Platform temp (hard-coded)

- **Do not move** harness spill (`agent-tools`, etc.).
- If tool output cites a new platform path, optionally update **`AGENT_TEMP_ROOT/harness-registry.json5`** (JSON5 with `//` comments; paths only). Keep the header comment block explaining purpose.

## One-off machine cleanup

Not covered by this skill. Inventory the user's machine explicitly; do not use generic heuristics from agent-rules scripts.
