# User rules
<!-- Portable user-layer preamble (forkable). Fill Constants before paste.
     Name = *user layer*, not "rules for users who aren't AI folks" — see harness-neutral
     "Layer names vs harness vocabulary" for how this maps to Cursor User Rules, CLAUDE.md, etc.
     Detail lives in general/*.md when assembling from MAIN.md. Do **not** paste skill bodies here. -->

## Constants
- CODE_ROOT: `REQUIRED_PATH`
- GITHUB_USER: `REQUIRED_NAME`
- ENVIRONMENT: `windows | linux | mac`
- ISSUES_REPO: optional path to `.issues` workflow repo
- MACHINE: `$CODE_ROOT/machine.md` (machine rules — this workstation; not per repo)
- HARNESS: `$CODE_ROOT/harness.md` (harness rules — discovery + behaviors on this machine; not per repo)

## Core
- Plain language: keep explanations easy to read. Default to conversational, direct speech — not jargon-heavy or corporate. Detail: `general/plain-speech.md`.
- Tool inventory record: keep a local snapshot of which tools are available on the current machine. Detail: `general/tool-inventory.md` (skill `tool-inventory`).
- **Harness-neutral:** read `$HARNESS` and `general/harness.md` when chat formatting, skill discovery, or always-on injection behavior matters. Skill `harness-setup` probes a new machine or harness.
- **Sync skills/rules on drift:** when discovery install, always-on paste, or `$AGENT_RULES_PATH` SHA drifts from the shared reference, run skill `sync-agent-rules` and apply updates (stamp `AGENT_RULES_SYNCED_SHA` + `AGENT_RULES_SYNCED_LABEL` / `skills-set/*` in `$HARNESS`). Detail: `general/rules-skills-sync.md`.
- **Template boundary:** never write machine paths, harness names, or usernames into forkable templates — see `general/harness-boundary.md`.
- **File names in chat:** follow `CHAT_FILE_LINKS` in `$HARNESS` (default: markdown link to workspace-relative path, forward slashes). Detail: `general/harness.md`.
- Gitignore: allow-list (`*` then `!path`); update when adding files. Do **not** allow-list `machine.md` or `harness.md`.
- **Hive remotes (prefer hive-watch):** do not `git fetch` the whole hive at chat start. Read **Last checked** in `$MACHINE` (hive-watch block) and `$CODE_ROOT/hive-watch.status.json`. If checked within **24h**, trust the status file; pull/rebase only repos you will edit that show behind. If stale, prefer the **hive-watch** tray/daemon (skill `hive-watch`) — not a blanket fetch every chat. Detail: `general/hive-watch.md`.
- **End of agent run:** if the run changed files, compose logical commits and push before the final reply (skill `push-code`). Detail: `general/end-of-run.md`.
- Python: always `venv`; prefer `uv` over `pip`; install `uv` in scripts if missing.
- Build failures: fix project code over downgrading deps; missing icon → stop loop, placeholder or ask.
- Task lists in files: mark done with checkmark emojis.
- Changelogs: match the repo’s existing style; owned-project layout is skill `owned-changelog`.
- Never write secret values into git, docs, `machine.md`, `harness.md`, or `.env.example` (name-only registry: skill `env-names-registry`).
- **Release architectures:** default to pattern `common` (win/lin × x64+arm64); GUI apps prefer `desktop` (+ macOS arm64). Dated forms `common/2026`. Skill `release-targets`; detail `general/release-target-patterns.md`.
- **Web fonts:** prefer self-hosting (Fontsource / local `woff2` + preload); do not `@import` Google Fonts or wait on a CDN for first paint. Detail: `general/self-host-fonts.md` (skill `self-host-fonts`).

## Environment
- OS/Shell: default Windows 10/11 unless profile says otherwise; recommend Nushell as user default; agent terminals may still be PowerShell 7 when the IDE provides `pwsh`.
- Path refresh after tool installs (Windows):
  ```powershell
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  ```
- Node: `pnpm` (create/install); `pnpm dlx` one-offs; `pnpm exec` project bins.
- Git hosts: prefer MCP; else `gh` / `glab`.

## Repos
- **Fork first:** `gh api repos/<owner>/<repo> --jq .fork` — if `true`, path is `.forks/` even for org repos (`dev-centr/.forks/dprint`, not `dev-centr/dprint`).
- Owned (not a fork): `$CODE_ROOT/<host>/<owner>/<repo>`
- Forks (personal **or** org): `$CODE_ROOT/<host>/<owner>/.forks/<repo>`
- Clones (upstream only): `$CODE_ROOT/<host>/.clones/<owner>/<repo>`
- Dedupe / bulk sync / misplaced forks: skill `hive-layout`; detail `general/folder-schema.md`.
- Hosts: usually `github.com` or `gitlab.com`.

## Creator (owned orgs)
- Transfers: `gh api`.
- **Agent rules:** canonical template is this repo. Each owned org this hive initializes gets `{org}/agent-rules` (pointer README + thin org `AGENTS.md` — **no submodule**; clone/fetch this repo). House workflow, not a requirement for every GitHub org. `{org}/.github/AGENT-RULES.md` is a pointer only — do not submodule rules into `.github`. Shared changes: PR here; org-only: commit wrapper `AGENTS.md`. Script: `scripts/setup-org-agent-rules-wrapper.ps1`.
- Config: SDL (`.sdl`) for DevCentr-owned / `sdlang-d` surfaces; **KDL** (`.kdl`) for greenfield outside that stack; JSON5 when stuck in the JSON family. Do **not** adopt Extended SDL/XDL.
- **Publishable libraries:** when creating a library (or depending on an owned/unpublished one that belongs on a registry), load skill `library-registry-choice` — check published status, ask publish vs local disk, encourage publish, suggest the registry. Detail: `general/library-registry-choice.md`.
- Changelog: every owned project, functional changes — skill `owned-changelog`.
- **UI concepts → demos:** for owned orgs, inventing/shipping a new UI concept auto-applies skill `demo-site-wiring` (demos + org index are part of invent/ship — not optional). Do **not** suppress push/PR for demo prototyping; iterate via later commits/PR updates. Detail: `agents/demos-and-push.md`.
- Issues: file for bugs, blockers, and external coordination — not routine owned-repo work (skill `owned-changelog`). When filing: skills `issue-reports` + `issues-repo-record` (when `ISSUES_REPO` set; always push); never chat-only.

## Docs
- Structure: Diátaxis (tutorials, how-to, explanation, reference).
- Format: AsciiDoc by default; retain Markdown on upstream forks; keep/add Markdown when a package registry only parses Markdown.
- **Illustrations:** new/updated teaching pages need at least one figure (diagram, screenshot, mockup, or source still) unless pure tabular reference or a thin changelog stub. Detail: `general/documentation.md`.
- **Audience / POV:** `page-*` attrs (Facto/`page-context`); keep `ifndef::page-context-active[]` fallback for audience / authors / last updated only. Agent-assisted: `<agent> on behalf of <human>`. Detail: `general/documentation.md`.
- Titles: follow site `STYLE.adoc` / `AGENTS.md` (not `machine.md`). **News = outward**; **blog = inward**. First-party news omits org; action essays pass implied [On]; prefer `X as Y` / *when* / disproof / questions; attach floating modifiers to an object; docs topics = concept names. Philosophy: `Titles as orientation`. In-repo IDE rules per `IDE_PROJECT_RULES` in `$HARNESS`; this file stays the paste preamble.
- Project facts: `AGENTS.md` + README/docs. Do not commit per-repo `machine.md`.
- On demand (do not inline): `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `writing-news`, `writing-blog`, `issue-reports`, `issues-repo-record`, `demo-site-wiring` — `skills/CATALOG.md`.

## AI ops
- AsciiDoc: checklists `* [ ]`; blank line after **bold** headings; list continuations `+`; images `image::`.
- **Machine rules:** **only** `$CODE_ROOT/machine.md`. Create if missing; counter from 1. Never commit. Format: `machine.example.md`.
- **Harness rules:** **only** `$CODE_ROOT/harness.md`. Create via skill `harness-setup` if missing. Never commit. Format: `harness.example.md`.
- Stale APIs: Context7 MCP when `MCP_CONTEXT7 = available` in `$HARNESS`; else skill `outdated-code-protocol`.
- Agent skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md` — load bodies on demand; do **not** paste into always-on rules. On drift vs shared reference: skill `sync-agent-rules`. Dev-Centr org members: also load org `AGENTS.md`; org layer overrides personal on `dev-centr/*` work.
- Commits / push / PRs: skills `git-commit`, `push-code`, and `draft-pr`. Load `push-code` at end of any run that changed files (standing auth — `general/end-of-run.md`); load `draft-pr` when opening a PR.

## Optional workstation patterns (not default)

- **Bitwarden CLI session reuse:** local `BW_SESSION` persistence for agents — `general/bitwarden-session-persist-optional.md`; hub how-to `docs/modules/ROOT/pages/bitwarden-cli-agents.adoc`. Reference skill: personal `bitwarden-unlock`; enable only via `$HARNESS` + machine-local overlays.
- **gcloud for agents:** user login persists under Cloud SDK config until revoke — hub how-to `docs/modules/ROOT/pages/gcloud-cli-agents.adoc`. Prefer individual login on desks; org SA key only for true headless hosts.
