# Main Rules

<!--
This is a modular context assembly file. For a consolidated, all-in-one ruleset, use **[user.md](./user.md)** instead.
-->

> **Dev Configuration (Fill these in before passing to AI)**:
> `CODE_ROOT= # insert the path to your code hive`
> `AGENT_RULES_PATH=$CODE_ROOT/github.com/<your-username>/agent-rules`

You are operating under this rules set.

## Context Assembly (CRITICAL FIRST STEP)

You must read all foundational rules in a single step using your native file reading tools. Do not read them sequentially. All paths below are strictly relative to `$AGENT_RULES_PATH`. Resolve that absolute path based on the variables above.

Read these files **simultaneously in parallel tool calls** to assemble your full context:

- `profiles/<infer-profile-name>.md` (machine constants: `CODE_ROOT`, `ENVIRONMENT`, …)
- `$CODE_ROOT/harness.md` (harness discovery + chat behaviors — create via skill `harness-setup` if missing; see `harness.example.md`)
- `$CODE_ROOT/machine.md` (workstation facts — create from `machine.example.md` if missing)
- `general/harness.md`
- `general/harness-boundary.md`
- `general/global.md`
- `general/environment.md`
- `general/<windows|mac|linux>.md` (infer OS from host or profile)
- `general/creator.md`
- `general/folder-schema.md`
- `general/documentation.md` (only if the task involves authoring or publishing project documentation)

Optional heavy curricula are **agent skills** under `skills/` (not MAIN assembly): `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `owned-changelog`, `issue-reports`, `issues-repo-record`, `harness-setup`, and others in [`skills/CATALOG.md`](./skills/CATALOG.md).

*(Fallback)*: If you lack native file reading tools, use a terminal to read them all in one command (e.g. `cat`), but beware of output truncation. If the host cannot read the filesystem, follow the **obligations** below as your only source.

## Machine-local files (this user's machine)

- **`$CODE_ROOT/harness.md`** — harness name, skill discovery paths, always-on injection slot, chat/citation behaviors. Never commit. Template: `harness.example.md`.
- **`$CODE_ROOT/machine.md`** — durable workstation facts (paths, PATH gaps, hardware). Never commit. Template: `machine.example.md`.
- Do **not** use per-repo `machine.md` for project knowledge — put that in `AGENTS.md` + docs/README.

## Constants (interpret from the active profile)

- `CODE_ROOT` — root directory for all clones.
- `GITHUB_USER` — GitHub username for path examples.
- `ISSUES_REPO` — path to the `.issues` repository when that workflow is used.
- `ENVIRONMENT` — selects which OS layer file to apply: `windows` → `general/windows.md`, `mac` → `general/mac.md`, `linux` → `general/linux.md`.

## Obligations (always)

- **OS/Shell:** Assume **Windows 10/11** when on this profile’s host. Recommend **Nushell** as the user default shell on all OSes. Agent terminal commands may still run under **PowerShell 7** when that is the IDE shell—do not confuse the two.
- Write explanations in plain language.
- **File names in chat:** follow `$CODE_ROOT/harness.md` (`CHAT_FILE_LINKS`, `CODE_CITATION`). Default: markdown workspace-relative links — see `general/harness.md`.
- **Template boundary:** never embed machine paths or harness-specific paths in forkable templates — see `general/harness-boundary.md`.
- Treat `.gitignore` as an allow-list unless the project says otherwise (exclude `*` then allow specific).
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- For Python, use a `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- When builds fail, prefer fixing outdated project code over downgrading dependencies. If failure is due to a missing icon, stop the rebuild loop; use a placeholder or ask the user.
- For dependencies whose APIs are stale in memory, use Context7 MCP when `MCP_CONTEXT7 = available` in `$HARNESS`; if not, direct the user to <https://context7.com/> or skill `outdated-code-protocol`.

## Dev-Centr product scope

These rules are for **end-user / project** agents. **Dev-Centr application automation** (acting on behalf of the user) must load `https://github.com/dev-centr/devcentr-agent-rules` instead of this repository—do not conflate the two.

## Optional agent skills (this repo)

Files under `skills/` are **not** auto-loaded by MAIN assembly. Shop entry: [`skills/BOOTSTRAP.md`](./skills/BOOTSTRAP.md). Install per `$CODE_ROOT/harness.md` (`SKILLS_DISCOVERY_ROOT`, `SKILLS_INSTALL`) or read `$AGENT_RULES_PATH/skills/<name>/SKILL.md` directly. Deep docs: xref:agent-rules:harness-neutral.adoc[Harness-neutral architecture] on docs.devcentr.org.

## Memory file format (when writing `$CODE_ROOT/machine.md`)

Stable workstation facts only; see `machine.example.md`. One line shape:

```text
<fact about this machine> (counter: 1)
```
