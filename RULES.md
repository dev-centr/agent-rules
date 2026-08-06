# Agent Rules
<!-- Generalized agent preamble. Fill Constants before paste. Detail lives in general/*.md when assembling from MAIN.md. -->

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
- Changelogs: match the repo’s existing style.

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
- Config: SDL preferred; else JSON5 (`.json5` over `.json`).
- Changelog: every project; README links to it; timeline + `changelog-details/date - title`.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc unless host requires Markdown (e.g. npm).
- Antora: follow `dev-centr` publishing guidance.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). Short defaults — first-party news omits org; action essays pass implied [On] and drop surplus *the*; prefer `X as Y` / *when* / disproof / questions over rigid `X is Y`; attach floating modifiers to an object; docs topics = concept names. Philosophy: `Titles as orientation`. Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- Project facts: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- **App shipping architecture:** when scaffolding/building/shipping apps, read `general/app-architecture.md` and adhere to Software Product Essentials under `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/` (hub: `software-product-essentials.adoc`). About/build info, debug dump, Windows auto-update, installers, and CI release pipelines are core—not polish.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (workstation facts). Create if missing; counter from 1. Never commit. Format: see `AMDphreak/agent-rules/MEMORIES.example.md` (or this fork’s copy if present).
- Stale APIs: Context7 MCP (https://context7.com/); else Outdated Code Protocol.
- Outdated Code Protocol: `AI-LOCAL-LIBRARY-DOCS.local.json5` + `docs/_local-library-docs/`; prefer local indexed docs/source; for Dlang prefer cloning source.
