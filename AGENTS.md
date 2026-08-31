# Dev-Centr org agent notes
<!-- Org-layer preamble for dev-centr org work. Paste into always-on rules **after** personal portable rules, or compose via rules-manager. -->

## Constants (fill before paste)

- `CODE_ROOT` — your code hive (see `profiles/*.md` in your fork)
- `AGENT_RULES_PATH` — shared tree: `$CODE_ROOT/github.com/dev-centr/agent-rules` (clone/fetch this repo; do not submodule it). Satellite orgs add overlay `$CODE_ROOT/github.com/{org}/agent-rules/AGENTS.md` only.
- `ORG` — `dev-centr`
- `ISSUES_REPO` — path to your `.issues` workflow repo when used (often personal; see profile)
- `MACHINE` — `$CODE_ROOT/machine.md` (machine rules — this user's workstation; never commit)
- `HARNESS` — `$CODE_ROOT/harness.md` (harness rules — discovery + behaviors; never commit)

## Layering (do not conflate)

| Layer | Files in this repo | When it applies |
| --- | --- | --- |
| Portable | `user.md` + `general/*` + your `profiles/*.md` | All coding work |
| **Org** | **`AGENTS.md`** + `agents/*` + org `skills/*` | Any `dev-centr` org repo |
| Product | `devcentr-agent-rules` (separate repo) | Dev-Centr app acting **for** the user |
| Project | `<repo>/AGENTS.md` | That repository only |

Machine rules → `MACHINE`. Harness rules → `HARNESS`. Project facts → repo `AGENTS.md` + docs. Editorial policy → `agents/editorial/` (site `STYLE.adoc` = thin pointer only, if present).

## Precedence (org work — explicit)

Harnesses **do not** automatically rank rule layers. When working in any **`dev-centr/*`** repository:

1. **Org wins on conflict:** this `AGENTS.md` and `agents/*` **override** personal portable rules (`user.md`, personal fork overlays) where they disagree.
2. **Repo adds, does not weaken:** per-repo `AGENTS.md` adds facts; it must not contradict org policy.
3. **Product scope only:** `devcentr-agent-rules` applies when the Dev-Centr app acts for the user — not for normal editing.
4. **Machine files stay local:** `MACHINE` and `HARNESS` never override org editorial or engineering policy.

**Always-on stack order:** personal `user.md` first (portable baseline), then **this `AGENTS.md`** (org override). Instruct the agent to apply org layer after assembly and treat org as authoritative on dev-centr work.

## Context assembly (org pass)

After portable `agent-rules` assembly (see `MAIN.md`), read **in one parallel batch** from `$AGENT_RULES_PATH`:

- `AGENTS.md` (this file — org obligations + precedence)
- `agents/_MAIN.md` (orchestrator)
- `agents/editorial/titles.md` (when authoring or reviewing news, blog, or doc titles)
- `agents/demos-and-push.md` (when inventing/shipping UI concepts or interactive demos for owned orgs)
- `agents/engineering/dub.md` (when working on DUB / D packages in org repos)
- `agents/engineering/antora.md` (when wiring Antora/Valentus/Facto or Internet Architecture vs HCI faces)
- Skill `draft-pr` when opening a pull request
- Skill `issues-repo-record` when recording to `ISSUES_REPO`
- `skills/CATALOG.md` (when installing, authoring, or auditing agent skills)

Repo-local `AGENTS.md` in the active project is **additive** — read it when you open that repository.

*(Fallback)*: If filesystem access is missing, follow the obligations below.

## Org obligations (always on dev-centr work)

- **Sync before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`; pull/rebase before coding on a stale HEAD.
- **End of agent run:** after file changes, logical commits + push before the final reply (`general/end-of-run.md`; skill `push-code`).
- **One Antora site per org:** skill `antora-org-site` (hub at [docs.devcentr.org](https://docs.devcentr.org); Valentus lean + **Facto** compose pack — confirm; `agents/engineering/antora.md`).
- **Internet Architecture / Reliability:** systems content in `general-knowledge`; portal peer nav in `dev-centr/docs`. HCI *Labels versus wires* is the symptom ↔ diagnosis face, not this umbrella; connectome-fs is substrate.
- **Public README chrome:** skill `public-readme`; hub link **Explore the docs »** → org docs.
- **Repo About homepage:** on new project repos, set GitHub About URL to the org docs hub component page unless the repo is the org main/marketing site or a product with its own domain/subdomain (skill `bootstrap-org`).
- **Changelogs:** every owned project, functional changes — skill `owned-changelog`.
- **Config:** SDL (`.sdl`) on DevCentr-owned / `sdlang-d` surfaces; KDL (`.kdl`) greenfield outside that stack; JSON5 in the JSON family. No Extended SDL/XDL.
- **Issues:** file for bugs, blockers, and external coordination — not routine owned-repo work (`owned-changelog`). When filing: skills `issue-reports` + `issues-repo-record` (when `ISSUES_REPO` set; always push); never chat-only.
- **Skills:** canonical copies under `skills/` in this repo; install per `$HARNESS` (`SKILLS_DISCOVERY_ROOT`, `SKILLS_INSTALL`) or read on demand. Inventory in `skills/CATALOG.md`. Do **not** paste skill bodies into this always-on preamble.
- **Sync skills/rules on drift:** skill `sync-agent-rules` — fetch/pull this repo, repair discovery installs, refresh local overlays, stamp `AGENT_RULES_SYNCED_SHA` + `AGENT_RULES_SYNCED_LABEL` (`skills-set/*`) in `$HARNESS`. Detail: `general/rules-skills-sync.md`.
- **Hive layout:** forks (personal **and** org) → `$CODE_ROOT/<host>/<owner>/.forks/<repo>`; owned non-forks → `<owner>/<repo>`; upstream → `.clones/`. Verify `gh api … --jq .fork` before clone or dedupe. Skill `hive-layout`; detail: `general/folder-schema.md`.
- **Hive remotes:** skill `hive-watch` + tool [`dev-centr/hive-watch`](https://github.com/dev-centr/hive-watch) — scheduled fetch; agents read `machine.md` stamp + `hive-watch.status.json` instead of per-chat hive fetch. Detail: `general/hive-watch.md`.
- **Template boundary:** read `general/harness-boundary.md` before editing forkable files; skill `harness-setup` for machine config.

## AI ops

- Stale APIs: Context7 MCP when available per `$HARNESS`; else skill `outdated-code-protocol`.
- Agent skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md`; one skill per job. Do not paste bodies here.
- **Skill authoring:** skill `write-a-skill` (`skills/write-a-skill/`) when creating or editing `SKILL.md` or a skill `description`. That field is trigger words, not a lay blurb.
- **Harness setup:** skill `harness-setup` when probing a new machine or harness.
- **Skills/rules drift:** skill `sync-agent-rules` when catalog/discovery mismatch, behind origin, or `AGENT_RULES_SYNCED_SHA` stale.
- **Hive layout:** skill `hive-layout` when cloning org repos, reconciling duplicate paths, or auditing fork placement.
- **Hive remotes:** skill `hive-watch` when installing or reading daily remote status (`hive-watch.status.json`, `machine.md` stamp).
- **Release tags:** skill `tag-release` (`skills/tag-release/`) when the user asks to tag/ship a version, cut `vX.Y.Z`, or maintain rolling GitHub `v2`. `+` dual-axis labels where a peer/engine exists; GitHub moving aliases in `github.md` (the platform does not compute 2.x).
- **Org / company / project bootstrap:** skill `bootstrap-org` (`skills/bootstrap-org/`). Name a profile in the first prompt (see `skills/bootstrap-org/profiles/catalog.sdl` or https://devcentr.org/skills/?cat=bootstrap), attach/paste an SDL `profile "…" { }` block, or let the agent infer (`new CLI` → `cli`) and poll only leftovers. House org init: `{org}/agent-rules` is a pointer overlay (no submodule of this repo). Deep email/vault/chat/infra stays in Business Bootstrap.
- **GitHub org profile assets:** skill `github-profile-assets` — `{org}/.github/profile/assets/` layout, rasters, discovery.
- **DUB publish:** official `dub` has no publish command. Use skill `publish-to-dub` (`skills/publish-to-dub/`) — `dubx` / `dub-publish` — when the user says publish to dub / dlang. Always set registry categories (do not leave them empty). Always-on pins: `agents/engineering/dub.md`.
- **Library registry vs local:** skill `library-registry-choice` when scaffolding a publishable library or depending on an owned/unpublished package — check the registry, ask publish vs path, encourage publish, suggest which registry.
- **Web fonts:** skill `self-host-fonts` — prefer Fontsource / local `woff2` + preload; do not `@import` Google Fonts or wait on a CDN for first paint. Detail: `general/self-host-fonts.md`.
- **UI concepts → demos (owned orgs):** inventing/shipping a new UI concept auto-loads skill `demo-site-wiring` (demos + org index are part of the work, not optional). Do **not** suppress end-of-run push/PR for demo prototyping — iterate via later commits/PR updates; local preview does not block push. On demo/docs philosophy clashes: resolve if clear, else surface the inconsistency. Detail: `agents/demos-and-push.md`.
- **Interactive demos / explainers:** skill `demo-site-wiring` — wire into the parent org site + demos browser (create if missing), lay workflow copy, identity trail with intermediates (Org → Demos → demo home), VCS logo line, multi-variant **selector hub → separate pages** by default. Grandfather existing demos; apply on create / substantive edit.
- **Docs encoding:** hand-authored Antora SVG/adoc breakage is usually **transcode corruption** (Windows mojibake / invalid SVG XML), not Antora plugins and not a refactor. Use skill `fix-docs-encoding` (`skills/fix-docs-encoding/`) — run its script `--check` / `--fix` after figure edits. Always-on tips: `general/documentation.md`.
- **Antora page titles:** H1 = `nav.adoc` label; prefer no divergent `:navtitle:`. Section landings: linked parent (link text = H1), not `.Section` + Overview. Never mix `.Title` dotted nav headers with sibling linked parents (titled list absorbs following `*` items). Detail: `general/documentation.md`.
- **Polyglot / multi-OS CI:** skill `polyglot-ci` when generating GitHub Actions matrices. Default release sets: skill `release-targets` (`common` / `desktop` / dated `common/2026`). macOS is arm64 only. Detail: `general/release-target-patterns.md`.
- Deep framing: docs.devcentr.org agent-rules module — xref:agent-rules:harness-neutral.adoc[Harness-neutral architecture].

## Local shortcut (team convention)

Optional junction so the org folder shows the org entry file:

```powershell
cmd /c mklink /J "$CODE_ROOT\github.com\dev-centr\AGENTS.md" `
  "$AGENT_RULES_PATH\AGENTS.md"
```

Prefer [`rules-manager`](https://github.com/dev-centr/rules-manager) to compose personal + org sections into one watched file.
