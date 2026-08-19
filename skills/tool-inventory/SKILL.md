---
name: tool-inventory
description: >-
  Use when tools/skills were installed, removed, or changed on the current machine
  and the agent should record/update a local tool inventory for this workspace.
---

# Tool inventory record

This skill writes a local (machine-only) record of the tools available to the agent, so the agent can later explain what changed without re-discovering everything.

## Inputs (from chat context)

If the user or the agent says tools changed, you should call this skill with:

- a short label for the change (e.g. `installed pulumi`, `added mcp server`, `removed sed`, `updated convex plugin`)
- optional scope: `install`, `remove`, or `update`

If the caller doesn’t provide a label, use a generic label like `tool inventory update`.

## Step 1: Detect tools (best-effort, harness-agnostic)

Build a list of tool identifiers you can reliably observe:

1. **If tool discovery exists in this harness**, use it to list available tools.
   - Example pattern (if available): call an MCP “list tools” / “catalog” function and include the resulting server + tool names.
2. Otherwise, fall back to a minimal inventory:
   - the local tools you already know are available to you in this session (e.g. “Shell”, “ReadFile”, “ApplyPatch”, “WebFetch”)
   - omit anything you can’t confirm.

Include versions only if the harness explicitly provides version strings (otherwise, omit versions).

## Step 2: Write/update a local record file

Write to ONE of these locations (pick the first that is available/allowed):

1. `$CODE_ROOT/MEMORIES.md` (recommended; workstation file and conventionally gitignored)
2. `$CODE_ROOT/TOOL-INVENTORY.md` (only if your workspace explicitly allows it / gitignore it)

**Format:**

Append a new section like:

```markdown
## Tool inventory: 2026-08-19T03:25:00-05:00
Label: installed tool X
Tools:
- <tool name 1> (optional version)
- <tool name 2> (optional version)
Notes:
- <any non-secret caveats>
```

Rules:
- Never write secrets, tokens, passwords, or environment values.
- Keep the tool list concise (names are enough).
- If the file already has a “Tool inventory” section, you may append or update by adding a new timestamped block.

## Step 3: Tell the agent what was recorded

Return (to the caller) the chosen file path and the count of tools recorded.

## Limitations

- The harness may not let you fully enumerate tools. Record what you can confirm.
- Identity differs per agent/harness; don’t rely on “who the agent is” as a stable key. The record should focus on tool names + (optional) versions.

