# Creator rules

<!---
OWNED PROJECTS RULES MANIFEST — for projects created or owned by the developer.
Do not apply these rules to third-party open-source contributions unless explicitly requested.
--->

## Organization and GitHub

- Use `gh api` to perform repo transfers when you own the orgs.
- **Agent rules per org (house workflow, not every GitHub org):** when initializing an org this hive owns, create `{org}/agent-rules` as a pointer README + thin org `AGENTS.md` — **no submodule** of `dev-centr/agent-rules`; clone/fetch the canonical repo. Point `{org}/.github/AGENT-RULES.md` at the wrapper — do **not** submodule rules into `.github`. Script: `scripts/setup-org-agent-rules-wrapper.ps1`. Skill `bootstrap-org` phase 3a.
- Issue reports: skill **`issue-reports`** — durable draft, never only in chat. Follow `ISSUES_REPO` instructions when that constant is set.

## Architecture and data

- Formally endorse **SDL (`.sdl`)** for DevCentr-owned configuration and catalogs parsed with `sdlang-d`. Prefer **KDL (`.kdl`)** for greenfield / cross-language node documents outside that stack (DUB: `kdl`). If neither fits (tool requires JSON-shaped files), use `json5` over `.json`. Do **not** adopt Extended SDL/XDL (`newsdlang`).

## Changelogs

- Every **owned** project records **functional** changes. Match an existing changelog’s style when one exists.
- How to create, backfill, and wire: Cursor skill **`owned-changelog`** (`skills/owned-changelog/`).
