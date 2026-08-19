# Tool inventory record (portable)

Agents should keep a lightweight, local record of what tools/skills are available on the current machine, so future runs can explain “what changed” without re-discovering everything.

## When to update

- After installing tools or skills
- After removing tools or skills
- After updating tools/skills to a new version
- When the agent detects (or is told) tool availability has changed

## How to record

1. Capture a best-effort list of tools you can see/know are available.
   - Include tool names (and versions if the harness provides them).
   - Do **not** include secrets, tokens, credentials, or environment values.
2. Write the record to a **local, machine-only** file (by convention, either:
   - `$CODE_ROOT/machine.md` (gitignored workstation file), or
   - a sibling file like `$CODE_ROOT/TOOL-INVENTORY.md` if your workspace ignores it).
3. Add a timestamp and a short “why/what changed” label if available (e.g. `installed record-rule`, `updated vercel-cli`).

## Limitations

- Harness identity varies per agent (Cursor vs other tools). This mechanism is harness-agnostic, so it must work with *whatever discovery hooks are available* in that harness.
- Agents may not be able to automatically detect tool changes; when that happens, rely on the agent to call the “tool inventory update” skill whenever it performs install/remove/upgrade actions.