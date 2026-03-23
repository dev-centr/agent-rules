# Agent rules (entrypoint)

You are operating under this rules set. Prefer loading the **files below from the repository clone** when paths resolve. If the host cannot read the filesystem, follow the **obligations and summaries** in this document as your only source.

## Read these files in order (when the repo is available)

1. `profiles/<active-profile>.md` — machine constants. Required keys: `CODE_ROOT`, `ENVIRONMENT` (`windows`, `mac`, or `linux`). Also `GITHUB_USER`, `ISSUES_REPO` when present. If any required value is missing or ambiguous, **ask the user** before inferring paths or OS behavior.
2. `general/global.md`
3. `general/environment.md`
4. Exactly **one** of `general/windows.md`, `general/mac.md`, or `general/linux.md`, matching `ENVIRONMENT`.
5. `general/creator.md`
6. `general/folder-schema.md`
7. When the task involves authoring or publishing project documentation: `general/documentation.md`

## Machine-local memory

- Read `MEMORIES.md` at the **repository root** when you need durable facts about this machine. That file is **gitignored**; **create** it if you need to record stable local facts and it does not exist yet.

## Constants (interpret from the active profile)

- `CODE_ROOT` — root directory for all clones.
- `GITHUB_USER` — GitHub username for path examples.
- `ISSUES_REPO` — path to the `.issues` repository when that workflow is used.
- `ENVIRONMENT` — selects which OS layer file to apply: `windows` → `general/windows.md`, `mac` → `general/mac.md`, `linux` → `general/linux.md`.

## Obligations (always)

- Write explanations in plain language.
- Treat `.gitignore` as an allow-list unless the project says otherwise.
- For Python, use a `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- When builds fail, prefer fixing outdated project code over downgrading dependencies. If failure is due to a missing icon, stop the rebuild loop; use a placeholder or ask the user.
- For dependencies whose APIs are stale in memory, use Context7 MCP when available; if not, direct the user to https://context7.com/

## Before acting (full detail lives in the files above)

- You **must** have applied `general/global.md`, `general/environment.md`, the correct OS file, and `general/creator.md` before substantive work, unless the user explicitly scopes a trivial task that cannot interact with those concerns.
- You **must** read `general/documentation.md` when changing how documentation is written, structured, or published.

## Dev-Centr product scope

These rules are for **end-user / project** agents. **Dev-Centr application automation** (acting on behalf of the user) must load `https://github.com/dev-centr/devcentr-agent-rules` instead of this repository—do not conflate the two.

## Memory file format (when writing `MEMORIES.md`)

Stable facts only; one example line shape:

```text
<org-or-label> is a GitHub org; clones live under $CODE_ROOT/github.com/<org-or-label>/
```

Use the profile’s `CODE_ROOT` when expanding paths.
