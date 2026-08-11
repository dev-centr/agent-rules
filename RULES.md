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
- Config: SDL (`.sdl`) for DevCentr-owned / `sdlang-d` surfaces; **KDL** (`.kdl`) for greenfield outside that stack; JSON5 when stuck in the JSON family. Do **not** adopt Extended SDL/XDL.
- Changelog: every project; functional changes; README links to it; index + `changelog-details/date - title`; backfill from git if missing; wire into docs; alert user if cross-org secrets are required.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown.
- Antora: Valentus theme + org branding; Lunr + `antora-supplemental` AI search (`antora-search-chat`); follow `dev-centr` publishing guidance. If those extensions cannot be found, alert the user and wait.
- **One Antora site per org** with a hub (e.g. docs.devcentr.org): wire `docs/` into the hub playbook; never publish a second Antora site on project GitHub Pages. Deduplicate errant sites. See `general/antora-docs-sites.md`. (Does not apply to mixing Antora with other docs systems.)
- **Public README layout:** when creating/revising GitHub-facing READMEs, follow `general/readme-layout.md` (Best-README adapted: centered for-the-badge chrome, **Explore the docs »** → org hub, TOC if >3 sections, role-grouped Built With, back-to-top). Do not add Docs/CI shields that break the established look. Hand-edit per repo; blanks in `dev-centr/readme-template`.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not MEMORIES). **News = outward** (shared record); **blog = inward** (ideas, ideals, philosophy, tutorials, thinking in public). Short defaults — first-party news omits org; action essays pass implied [On] and drop surplus *the*; prefer `X as Y` / *when* / disproof / questions over rigid `X is Y`; attach floating modifiers to an object; docs topics = concept names. Philosophy: `Titles as orientation`. Cursor rules = `.cursor/rules/*.mdc` dir; this file stays the paste preamble.
- **News/blog body (anti-terse):** before drafting, read Laurie Hertzel, [Six Writing Tips for Crafting Scenes](https://niemanstoryboard.org/2005/03/24/six-tips-for-crafting-scenes/) (Nieman Storyboard). Apply her parameters: (1) write with a camera angle; (2) use both scene and summary; (3) telling details and metaphor; (4) vary pace; (5) move forward/backward in time with clear cues; (6) end scenes with pull-forward completion. Full checklist in `general/documentation.md`. Do not ship telegraphic bullet-essays on the narrative channel.
- Project facts: `AGENTS.md` + README/docs. Do not commit per-repo `MEMORIES.md`.
- **App shipping architecture:** when scaffolding/building/shipping apps, read `general/app-architecture.md` and adhere to Software Product Essentials under `$CODE_ROOT/github.com/dev-centr/general-knowledge/docs/modules/ROOT/pages/explanation/architecture/` (hub: `software-product-essentials.adoc`; delivery-class templates under `classes/`; interactive CentrMark checklists under `examples/product-essentials/` → `.devcentr/checklists/` with progress in `.cmk.checks/`). About/build info, Help, debug dump, auto-update (Windows + Unix apply safety), installers, and CI release pipelines are core—not polish.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- MEMORIES: **only** `$CODE_ROOT/MEMORIES.md` (workstation facts). Create if missing; counter from 1. Never commit. Format: see `MEMORIES.example.md` in this repository (or your fork’s copy).
- Stale APIs: Context7 MCP (https://context7.com/); else Outdated Code Protocol.
- Cursor skills (optional, on demand): see `skills/BOOTSTRAP.md` — do **not** paste skill bodies into this always-on preamble.
- Outdated Code Protocol: `AI-LOCAL-LIBRARY-DOCS.local.json5` + `docs/_local-library-docs/`; prefer local indexed docs/source; for Dlang prefer cloning source.
