# Agent Rules
<!-- Generalized agent preamble. Fill Constants before paste. Detail lives in general/*.md when assembling from MAIN.md. Do **not** paste skill bodies into this file. -->

## Constants
- CODE_ROOT: `REQUIRED_PATH`
- GITHUB_USER: `REQUIRED_NAME`
- ENVIRONMENT: `windows | linux | mac`
- ISSUES_REPO: optional path to `.issues` workflow repo
- MEMORIES: `$CODE_ROOT/MEMORIES.md` (workstation file — this user's machine; not per repo)
- HARNESS: `$CODE_ROOT/HARNESS.md` (harness discovery + behaviors on this machine; not per repo)

## Core
- Plain language: keep explanations easy to read. Default to conversational, direct speech — not jargon-heavy or corporate. Detail: `general/plain-speech.md`.
- Tool inventory record: keep a local snapshot of which tools are available on the current machine. Detail: `general/tool-inventory.md` (skill `tool-inventory`).
- **Harness-neutral:** read `$HARNESS` and `general/harness.md` when chat formatting, skill discovery, or always-on injection behavior matters. Skill `harness-setup` probes a new machine or harness.
- **Template boundary:** never write machine paths, harness names, or usernames into forkable templates — see `general/harness-boundary.md`.
- **File names in chat:** follow `CHAT_FILE_LINKS` in `$HARNESS` (default: markdown link to workspace-relative path, forward slashes). Detail: `general/harness.md`.
- Gitignore: allow-list (`*` then `!path`); update when adding files. Do **not** allow-list `MEMORIES.md` or `HARNESS.md`.
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- Python: always `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- Build failures: fix project code over downgrading deps; missing icon → stop loop, placeholder or ask.
- Task lists in files: mark done with checkmark emojis.
- Changelogs: match the repo’s existing style; owned-project layout is skill `owned-changelog`.
- Never write secret values into git, docs, `MEMORIES.md`, `HARNESS.md`, or `.env.example` (name-only registry: skill `env-names-registry`).

## Environment
- OS/Shell: default Windows 10/11 unless profile says otherwise; recommend Nushell as user default; agent terminals may still be PowerShell 7 when the IDE provides `pwsh`.
- Path refresh after tool installs (Windows):
  ```powershell
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  ```
- Node: `pnpm` (create/install); `pnpm dlx` one-offs; `pnpm exec` project bins.
- Git hosts: prefer MCP; else `gh` / `glab`.

## Repos
- Owned: `$CODE_ROOT/<host>/<owner>/<repo>`
- Forks: `$CODE_ROOT/<host>/<owner>/.forks/<repo>`
- Clones: `$CODE_ROOT/<host>/.clones/<owner>/<repo>`
- Hosts: usually `github.com` or `gitlab.com`.

## Creator (owned orgs)
- Transfers: `gh api`.
- **Agent rules:** canonical template is this repo. Each owned org this hive initializes gets `{org}/agent-rules` (pointer README + thin org `AGENTS.md` — **no submodule**; clone/fetch this repo). House workflow, not a requirement for every GitHub org. `{org}/.github/AGENT-RULES.md` is a pointer only — do not submodule rules into `.github`. Shared changes: PR here; org-only: commit wrapper `AGENTS.md`. Script: `scripts/setup-org-agent-rules-wrapper.ps1`.
- Config: SDL (`.sdl`) for DevCentr-owned / `sdlang-d` surfaces; **KDL** (`.kdl`) for greenfield outside that stack; JSON5 when stuck in the JSON family. Do **not** adopt Extended SDL/XDL.
- Changelog: every owned project, functional changes — skill `owned-changelog`.
- Issues: file for bugs, blockers, and external coordination — not routine owned-repo work (skill `owned-changelog`). When filing: skills `issue-reports` + `issues-repo-record` (when `ISSUES_REPO` set; always push); never chat-only.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward**; **blog = inward**. First-party news omits org; action essays pass implied [On]; prefer `X as Y` / *when* / disproof / questions; attach floating modifiers to an object; docs topics = concept names. Philosophy: `Titles as orientation`. In-repo IDE rules per `IDE_PROJECT_RULES` in `$HARNESS`; this file stays the paste preamble.
- Project facts: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- On demand (do not inline): `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `writing-news`, `writing-blog`, `issue-reports`, `issues-repo-record` — `skills/CATALOG.md`.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (workstation facts for this user's machine). Create if missing; counter from 1. Never commit. Format: `MEMORIES.example.md`.
- HARNESS: **only** `$CODE_ROOT/HARNESS.md` (harness name, skill discovery, chat behaviors). Create via skill `harness-setup` if missing. Never commit. Format: `HARNESS.example.md`.
- Stale APIs: Context7 MCP when `MCP_CONTEXT7 = available` in `$HARNESS`; else skill `outdated-code-protocol`.
- Agent skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md` — load bodies on demand; do **not** paste into always-on rules. Dev-Centr org members: also load org `AGENTS.md`; org layer overrides personal on `dev-centr/*` work.
- Commits / push / PRs: skills `git-commit`, `push-code`, and `draft-pr` (load when the user asks to commit, push, or open a PR).
