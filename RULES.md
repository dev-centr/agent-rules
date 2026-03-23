# Rules (handoff)

This file is meant to be **copied wholesale** into an agent or IDE rules field when that tool does not reliably follow on-disk paths.

If the tool **can** read files from a clone of this repository, use the **read order** below instead of duplicating everything here.

## Read order (when loading from disk)

1. `profiles/<your-profile>.md` — copy from `profiles/my-desktop.md` or `profiles/my-laptop.md`, rename, and fill **constants** (`CODE_ROOT`, `GITHUB_USER`, `ISSUES_REPO`, `ENVIRONMENT`, …). `ENVIRONMENT` must be one of: `windows`, `mac`, `linux` (it selects which OS file you read next). If a constant is missing, ask the user to set it before guessing paths.
2. `general/global.md`
3. `general/environment.md`
4. **One** of: `general/windows.md`, `general/mac.md`, or `general/linux.md` — match the `ENVIRONMENT` value from your profile.
5. `general/creator.md`
6. `general/folder-schema.md`
7. When authoring or publishing documentation: `general/documentation.md`

Create `MEMORIES.md` in this repo root when you need stable machine-local facts (gitignored). Create it if absent when you need that class of fact.

**Dev-Centr:** when the **Dev-Centr application** acts on behalf of the user, it should load product rules from the **devcentr-agent-rules** repository (`https://github.com/dev-centr/devcentr-agent-rules`), not from this forkable rules repo.

## Constants

Define these in your active profile under `profiles/` (see `profiles/my-desktop.md` and `profiles/my-laptop.md`):

- `CODE_ROOT` — root directory for all clones (for example `Z:\code` or `/home/you/src`).
- `GITHUB_USER` — your GitHub username for path examples.
- `ISSUES_REPO` — path to your `.issues` repository, if you use that workflow.
- `ENVIRONMENT` — `windows`, `mac`, or `linux` (selects `general/windows.md`, `general/mac.md`, or `general/linux.md`).

## Global (summary)

- Write explanations in plain language.
- Use `.gitignore` as an allow-list; exclude by default, then allowlist what you need.
- Python: always use a `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- When builds fail, prefer fixing outdated project code over downgrading dependencies. If the failure is a missing icon, stop the build loop: add a placeholder icon or ask the user.
- Use Context7 MCP for libraries with APIs that go stale in model memory; if Context7 is missing, tell the user how to add docs at https://context7.com/

## Must read (full detail in repo)

- Read `general/environment.md` and the matching OS file before acting.
- Read `general/creator.md` before acting.
- Read `general/documentation.md` when you work on documentation or Antora-style sites.
- Read `MEMORIES.md` in this repo root when you need stable machine-local facts. That file is **gitignored**; create it if absent.

## Memory file

`MEMORIES.md` is **machine-local only**. Example entry:

```text
example-org is a GitHub org; clones live under $CODE_ROOT/github.com/example-org/
```

Replace `$CODE_ROOT` with your actual root when you paste paths, or reference the constant from your profile.
