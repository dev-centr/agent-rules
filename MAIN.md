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

*(Fallback)*: If you lack native file reading tools, use a terminal to read them all in one command (e.g. `cat`), but beware of output truncation. If the host cannot read the filesystem, follow the **obligations** below as your only source.

## Machine-local memory

- Read `MEMORIES.md` at the **repository root** when you need durable facts about this machine. That file is **gitignored**; **create** it if you need to record stable local facts and it does not exist yet.

## Constants (interpret from the active profile)

- `CODE_ROOT` — root directory for all clones.
- `GITHUB_USER` — GitHub username for path examples.
- `ISSUES_REPO` — path to the `.issues` repository when that workflow is used.
- `ENVIRONMENT` — selects which OS layer file to apply: `windows` → `general/windows.md`, `mac` → `general/mac.md`, `linux` → `general/linux.md`.

## Obligations (always)

- **OS/Shell:** Assume **Windows 10/11** and **PowerShell 7** unless explicitly told otherwise.
- Write explanations in plain language.
- Treat `.gitignore` as an allow-list unless the project says otherwise (exclude `*` then allow specific).
- For Python, use a `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- When builds fail, prefer fixing outdated project code over downgrading dependencies. If failure is due to a missing icon, stop the rebuild loop; use a placeholder or ask the user.
- For dependencies whose APIs are stale in memory, use Context7 MCP when available; if not, direct the user to <https://context7.com/>

## Dev-Centr product scope

These rules are for **end-user / project** agents. **Dev-Centr application automation** (acting on behalf of the user) must load `https://github.com/dev-centr/devcentr-agent-rules` instead of this repository—do not conflate the two.

## Memory file format (when writing `MEMORIES.md`)

Stable facts only; one example line shape:

```text
<org-or-label> is a GitHub org; clones live under $CODE_ROOT/github.com/<org-or-label>/
```

Use the profile’s `CODE_ROOT` when expanding paths.
