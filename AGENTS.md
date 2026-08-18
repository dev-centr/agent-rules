# Dev-Centr org agent notes
<!-- Org-layer preamble for dev-centr org work. Paste into User Rules **after** personal portable rules, or compose via rules-manager. -->

## Constants (fill before paste)

- `CODE_ROOT` — your code hive (see `profiles/*.md`)
- `AGENT_RULES_PATH` — shared tree: `$CODE_ROOT/github.com/dev-centr/agent-rules` (clone/fetch this repo; do not submodule it). Satellite orgs add overlay `$CODE_ROOT/github.com/{org}/agent-rules/AGENTS.md` only.
- `ORG` — `dev-centr`
- `ISSUES_REPO` — path to your `.issues` workflow repo when used (often personal; see profile)
- `MEMORIES` — `$CODE_ROOT/MEMORIES.md` (workstation only; never commit)

## Layering (do not conflate)

| Layer | Files in this repo | When it applies |
| --- | --- | --- |
| Portable | `RULES.md` + `general/*` + your `profiles/*.md` | All coding work |
| **Org** | **`AGENTS.md`** + `agents/*` + org `skills/*` | Any `dev-centr` org repo |
| Product | `devcentr-agent-rules` (separate repo) | Dev-Centr app acting **for** the user |
| Project | `<repo>/AGENTS.md` | That repository only |

Personal machine facts → `MEMORIES`. Project facts → repo `AGENTS.md` + docs. Editorial policy → `agents/editorial/` + site `STYLE.adoc`.

## Precedence (org work — explicit)

Cursor and other harnesses **do not** automatically rank rule layers. When working in any **`dev-centr/*`** repository:

1. **Org wins on conflict:** this `AGENTS.md` and `agents/*` **override** personal portable rules (`RULES.md`, personal fork overlays) where they disagree.
2. **Repo adds, does not weaken:** per-repo `AGENTS.md` adds facts; it must not contradict org policy.
3. **Product scope only:** `devcentr-agent-rules` applies when the Dev-Centr app acts for the user — not for normal editing.
4. **MEMORIES is machine-only:** workstation paths never override org editorial or engineering policy.

**User Rules stack order:** personal `RULES.md` first (portable baseline), then **this `AGENTS.md`** (org override). Instruct the agent to apply org layer after assembly and treat org as authoritative on dev-centr work.

## Context assembly (org pass)

After portable `agent-rules` assembly (see `MAIN.md`), read **in one parallel batch** from `$AGENT_RULES_PATH`:

- `AGENTS.md` (this file — org obligations + precedence)
- `agents/_MAIN.md` (orchestrator)
- `agents/editorial/titles.md` (when authoring or reviewing news, blog, or doc titles)
- `agents/engineering/dub.md` (when working on DUB / D packages in org repos)
- Cursor skill `draft-pr` when opening a pull request
- `skills/CATALOG.md` (when installing, authoring, or auditing Cursor skills)

Repo-local `AGENTS.md` in the active project is **additive** — read it when you open that repository.

*(Fallback)*: If filesystem access is missing, follow the obligations below.

## Org obligations (always on dev-centr work)

- **Sync before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`; pull/rebase before coding on a stale HEAD.
- **One Antora site per org:** skill `antora-org-site` (hub at [docs.devcentr.org](https://docs.devcentr.org); Valentus is a suggestion — confirm).
- **Public README chrome:** skill `public-readme`; hub link **Explore the docs »** → org docs.
- **Changelogs:** every owned project, functional changes — skill `owned-changelog`.
- **Config:** SDL (`.sdl`) on DevCentr-owned / `sdlang-d` surfaces; KDL (`.kdl`) greenfield outside that stack; JSON5 in the JSON family. No Extended SDL/XDL.
- **Issues:** skill `issue-reports` — not only in chat.
- **Skills:** canonical copies under `skills/` in this repo; junction into `~/.cursor/skills/<name>/`. Inventory in `skills/CATALOG.md`. Do **not** paste skill bodies into this always-on preamble.

## AI ops

- Stale APIs: Context7 MCP; else skill `outdated-code-protocol`.
- Cursor skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md`; one skill per job. Do not paste bodies here.
- **Skill authoring:** skill `write-a-skill` (`skills/write-a-skill/`) when creating or editing `SKILL.md` or a skill `description`. That field is trigger words, not a lay blurb. Cursor `create-skill` still owns layout.
- **Release tags:** skill `tag-release` (`skills/tag-release/`) when the user asks to tag/ship a version, cut `vX.Y.Z`, or maintain rolling GitHub `v2`. `+` dual-axis labels where a peer/engine exists; GitHub moving aliases in `github.md` (the platform does not compute 2.x).
- **Org / company / project bootstrap:** skill `bootstrap-org` (`skills/bootstrap-org/`). Name a profile in the first prompt (see `skills/bootstrap-org/profiles/catalog.sdl` or https://devcentr.org/skills/?cat=bootstrap), attach/paste an SDL `profile "…" { }` block, or let the agent infer (`new CLI` → `cli`) and poll only leftovers. House org init: `{org}/agent-rules` is a pointer overlay (no submodule of this repo). Deep email/vault/chat/infra stays in Business Bootstrap.
- **DUB publish:** official `dub` has no publish command. Use skill `publish-to-dub` (`skills/publish-to-dub/`) — `dubx` / `dub-publish` — when the user says publish to dub / dlang. Always set registry categories (do not leave them empty). Always-on pins: `agents/engineering/dub.md`.
- **Docs encoding:** hand-authored Antora SVG/adoc breakage is usually **transcode corruption** (Windows mojibake / invalid SVG XML), not Antora plugins and not a refactor. Use skill `fix-docs-encoding` (`skills/fix-docs-encoding/`) — run its script `--check` / `--fix` after figure edits. Always-on tips: `general/documentation.md`.
- **Polyglot / multi-OS CI:** skill `polyglot-ci` (`skills/polyglot-ci/`) when generating GitHub Actions matrices for win/mac/lin/BSD, APE, or Binary Tailor packs. macOS is arm64 only.
- Deep framing: general-knowledge *Vibe coding bootstrap* / *Bootstrap Cursor skills* on docs.devcentr.org.

## Local shortcut (team convention)

Optional junction so the org folder shows the org entry file:

```powershell
cmd /c mklink /J "$CODE_ROOT\github.com\dev-centr\AGENTS.md" `
  "$AGENT_RULES_PATH\AGENTS.md"
```

Prefer [`rules-manager`](https://github.com/dev-centr/rules-manager) to compose personal + org sections into one watched file.
