# Harness-neutral operations

<!---
HARNESS MANIFEST — how portable rules interact with any AI coding harness.
Machine-specific values live in $CODE_ROOT/harness.md (see harness.example.md).
--->

## Principles

- **Templates are forkable; machine files are not.** Never commit `$CODE_ROOT/harness.md`, `$CODE_ROOT/machine.md`, or filled `profiles/<machine>.md` paths into upstream `dev-centr/agent-rules`.
- **Polyglot harness use:** one workstation may alternate harnesses. Re-read `$CODE_ROOT/harness.md` when the active harness changes.
- **Skills are canonical in this repo** under `$AGENT_RULES_PATH/skills/<name>/`. Harness-specific install/discovery is recorded in `harness.md`, not duplicated in skill bodies.
- **Layer precedence is not automatic.** Harnesses do not rank portable vs org vs project rules — the agent must follow explicit stacking instructions in `AGENTS.md` / `user.md`.

## First read on session start

When `$CODE_ROOT` is known, read in parallel:

1. `$CODE_ROOT/harness.md` (create from `harness.example.md` via skill `harness-setup` if missing)
2. `$CODE_ROOT/machine.md` (create from `machine.example.md` if missing)
3. Active machine profile in your fork: `profiles/<machine>.md`

## Variables (resolved from harness.md)

| Variable | Purpose |
| --- | --- |
| `HARNESS_NAME` | Active harness identifier |
| `ALWAYS_ON_RULES` | Where thin preamble / composed rules are injected |
| `SKILLS_DISCOVERY_ROOT` | Where harness auto-discovers linked skills, or `none` |
| `LOCAL_RULES_DIR` | Machine-local overlay rules (never sync) |
| `SKILLS_INSTALL` | How to link canonical skills into discovery root |
| `CHAT_FILE_LINKS` | How to reference files in chat |
| `CODE_CITATION` | Line-range citation format, if any |
| `IDE_PROJECT_RULES` | In-repo IDE rule format (`.mdc`, etc.) |
| `MCP_CONTEXT7` | Whether Context7 MCP is available on this machine |

## Loading agent skills

1. **Prefer discovery** when `SKILLS_DISCOVERY_ROOT` is set and skills are installed per `SKILLS_INSTALL`.
2. **Else read directly:** `$AGENT_RULES_PATH/skills/<name>/SKILL.md` using native file tools.
3. **Never paste** full skill bodies into always-on rules — one-line pointers only.

Shop entry: `skills/BOOTSTRAP.md`. Inventory: `skills/CATALOG.md`.

## Chat file references

Follow `CHAT_FILE_LINKS` and `CODE_CITATION` from `$CODE_ROOT/harness.md`:

- **`markdown-workspace-links`** — file name as markdown link to workspace-relative path (forward slashes). Example: [`SKILL.md`](skills/write-a-skill/SKILL.md).
- **`line-range-fence`** — code regions use the harness line-range citation format when citing existing code.
- **`plain-paths`** — workspace-relative paths in backticks; no special link syntax.
- **`harness-default`** — use whatever link/citation behavior this harness documents; record the choice in `harness.md` after probing.

Do not use `file://` or Windows backslashes in chat links. Do not link incidental mentions of a common filename as a concept.

## Stale APIs

When `MCP_CONTEXT7 = available`, prefer Context7 MCP for library docs. When unavailable, use skill **`outdated-code-protocol`**.

## Boundary awareness

Read **`general/harness-boundary.md`** before editing template files. Skill **`harness-setup`** probes the machine and populates `$CODE_ROOT/harness.md`.
