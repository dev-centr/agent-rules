---
name: agent-temp
description: >-
  Use when writing a temp file, scratch file, curl -o, shell redirect, probe
  script, CSV dump, large output capture, or any agent-chosen path outside a
  git commit; AGENT_TEMP_ROOT, manual/, global agent temp, avoid profile litter.
---

# Agent temp (agent-chosen paths)

Platform-hard-coded spill (e.g. Cursor `agent-tools`) is handled separately — see **`general/agent-temp.md`** § Platform temp. This skill applies when **you** choose where to put temporary data.

## When to load

- Redirecting command output to a file for grep/read later
- `Write` / here-doc / `curl -o` / download for analysis
- One-off probe scripts not meant for the repo
- Any urge to use `$env:TEMP`, profile root, or repo root “just this once”

## Procedure

1. Read **`AGENT_TEMP_ROOT`** from `$CODE_ROOT/harness.md` (default `%LOCALAPPDATA%\AgentTemp` on Windows).
2. Target directory: **`{AGENT_TEMP_ROOT}/manual/{YYYY-MM-DD}/`** — create if missing.
3. Filename: **`{purpose}-{shortid}.{ext}`** (purpose required).
4. PowerShell paths: **`$env:USERPROFILE`**, **`$env:LOCALAPPDATA`** — never `%userprofile%`.
5. In chat, cite the path under **`manual/`** if the user should open it.

Full policy and anti-patterns: **`general/agent-temp.md`**.
