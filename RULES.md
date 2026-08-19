# Agent Rules
<!-- Generalized agent preamble. Fill Constants before paste. Detail lives in general/*.md when assembling from MAIN.md. Do **not** paste skill bodies into this file. -->

## Constants
- CODE_ROOT: `REQUIRED_PATH`
- GITHUB_USER: `REQUIRED_NAME`
- ENVIRONMENT: `windows | linux | mac`
- ISSUES_REPO: optional path to `.issues` workflow repo
- MEMORIES: `$CODE_ROOT/MEMORIES.md` (sys-wide workstation file — not per repo)

## Core
- Plain language: keep explanations easy to read. Default to conversational, direct speech — not jargon-heavy or corporate. Detail: `general/plain-speech.md`.
- **File names in chat:** when you mention a file you are working on or the user asked about, write the **file name** as a markdown link to the workspace-relative path (forward slashes) so a click opens it in the editor. Do not use `file://` or Windows backslashes in chat links.
- Gitignore: allow-list (`*` then `!path`); update when adding files. Do **not** allow-list `MEMORIES.md`.
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- Python: always `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- Build failures: fix project code over downgrading deps; missing icon → stop loop, placeholder or ask.
- Task lists in files: mark done with checkmark emojis.
- Changelogs: match the repo’s existing style; owned-project layout is skill `owned-changelog`.
- Never write secret values into git, docs, `MEMORIES.md`, or `.env.example` (name-only registry: skill `env-names-registry`).

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
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward**; **blog = inward**. First-party news omits org; action essays pass implied [On]; prefer `X as Y` / *when* / disproof / questions; attach floating modifiers to an object; docs topics = concept names. Philosophy: `Titles as orientation`. Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- Project facts: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- On demand (do not inline): `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `writing-news`, `writing-blog`, `issue-reports`, `issues-repo-record` — `skills/CATALOG.md`.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (workstation facts). Create if missing; counter from 1. Never commit. Format: see `MEMORIES.example.md` in this repository (or your fork’s copy).
- Stale APIs: Context7 MCP (https://context7.com/); else skill `outdated-code-protocol`.
- Cursor skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md` — do **not** paste skill bodies here. Dev-Centr org members: also load `AGENTS.md` from this repo; org layer overrides personal on `dev-centr/*` work.
- Commits / push / PRs: skills `git-commit`, `push-code`, and `draft-pr` (load when the user asks to commit, push, or open a PR).
