# Main Rules

<!--
This is a modular context assembly file. For a consolidated, all-in-one ruleset, use **[RULES.md](./RULES.md)** instead.
-->

> **Dev Configuration (Fill these in before passing to AI)**:
> `CODE_ROOT= # insert the path to your code hive`
> `AGENT_RULES_PATH=$CODE_ROOT/github.com/<your-username>/agent-rules`

You are operating under this rules set.

## Context Assembly (CRITICAL FIRST STEP)

You must read all foundational rules in a single step using your native file reading tools. Do not read them sequentially. All paths below are strictly relative to `$AGENT_RULES_PATH`. Resolve that absolute path based on the variables above.

Read these files **simultaneously in parallel tool calls** to assemble your full context:

- `profiles/<infer-profile-name>.md` (contains machine constants, including `ENVIRONMENT`)
- `general/global.md`
- `general/environment.md`
- `general/<windows|mac|linux>.md` (infer OS from host or profile)
- `general/creator.md`
- `general/folder-schema.md`
- `general/documentation.md` (only if the task involves authoring or publishing project documentation)
- `general/app-architecture.md` (only if the task involves scaffolding, building, shipping, packaging, or maintaining an application, CLI, TUI, publishable library, game client, or service)

*(Fallback)*: If you lack native file reading tools, use a terminal to read them all in one command (e.g. `cat`), but beware of output truncation. If the host cannot read the filesystem, follow the **obligations** below as your only source.

## Machine-local memory

- Read **`$CODE_ROOT/MEMORIES.md`** for durable facts about **this workstation** (paths, PATH gaps, hardware). Create it if missing (see `MEMORIES.example.md`). Never commit it.
- Do **not** use per-repo `MEMORIES.md` for project knowledge — put that in `AGENTS.md` + docs/README.

## Constants (interpret from the active profile)

- `CODE_ROOT` — root directory for all clones.
- `GITHUB_USER` — GitHub username for path examples.
- `ISSUES_REPO` — path to the `.issues` repository when that workflow is used.
- `ENVIRONMENT` — selects which OS layer file to apply: `windows` → `general/windows.md`, `mac` → `general/mac.md`, `linux` → `general/linux.md`.

## Obligations (always)

- **OS/Shell:** Assume **Windows 10/11** when on this profile’s host. Recommend **Nushell** as the user default shell on all OSes. Agent terminal commands may still run under **PowerShell 7** when that is the IDE shell—do not confuse the two.
- Write explanations in plain language.
- Treat `.gitignore` as an allow-list unless the project says otherwise (exclude `*` then allow specific).
- For Python, use a `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- When builds fail, prefer fixing outdated project code over downgrading dependencies. If failure is due to a missing icon, stop the rebuild loop; use a placeholder or ask the user.
- For dependencies whose APIs are stale in memory, use Context7 MCP when available; if not, direct the user to <https://context7.com/>

## Dev-Centr product scope

These rules are for **end-user / project** agents. **Dev-Centr application automation** (acting on behalf of the user) must load `https://github.com/dev-centr/devcentr-agent-rules` instead of this repository—do not conflate the two.

## Memory file format (when writing `$CODE_ROOT/MEMORIES.md`)

Stable workstation facts only; see `MEMORIES.example.md`. One line shape:

```text
<fact about this machine> (counter: 1)
```
