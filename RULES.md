# Agent Rules
<!-- Generalized agent preamble. Fill Constants before paste. Detail lives in general/*.md when assembling from MAIN.md. Do **not** paste skill bodies into this file. -->

## Constants
- CODE_ROOT: `REQUIRED_PATH`
- GITHUB_USER: `REQUIRED_NAME`
- ENVIRONMENT: `windows | linux | mac`
- ISSUES_REPO: optional path to `.issues` workflow repo
- MEMORIES: `$CODE_ROOT/MEMORIES.md` (sys-wide workstation file — not per repo)

## Core
- Plain language: keep explanations easy to read.
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
- Config: SDL (`.sdl`) for DevCentr-owned / `sdlang-d` surfaces; **KDL** (`.kdl`) for greenfield outside that stack; JSON5 when stuck in the JSON family. Do **not** adopt Extended SDL/XDL.
- Changelog: every owned project, functional changes — skill `owned-changelog`.
- Issues: never only in chat — skill `issue-reports`.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward**; **blog = inward**. First-party news omits org; action essays pass implied [On]; prefer `X as Y` / *when* / disproof / questions; attach floating modifiers to an object; docs topics = concept names. Philosophy: `Titles as orientation`. Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- Project facts: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- On demand (do not inline): `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `writing-news`, `writing-blog` — `skills/CATALOG.md`.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (workstation facts). Create if missing; counter from 1. Never commit. Format: see `MEMORIES.example.md` in this repository (or your fork’s copy).
- Stale APIs: Context7 MCP (https://context7.com/); else skill `outdated-code-protocol`.
- Cursor skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md` — do **not** paste skill bodies here. Dev-Centr org members: also load `AGENTS.md` from this repo; org layer overrides personal on `dev-centr/*` work.
- Commits / PRs: skills `git-commit` and `draft-pr` (load when the user asks to commit or open a PR).
