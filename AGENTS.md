# Dev-Centr org agent notes
<!-- Org-layer preamble for dev-centr org work. Paste into User Rules **after** personal portable rules, or compose via rules-manager. -->

## Constants (fill before paste)

- `CODE_ROOT` — your code hive (see `profiles/*.md`)
- `AGENT_RULES_PATH` — this repository, e.g. `$CODE_ROOT/github.com/dev-centr/agent-rules` (org canonical) or your fork
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
- `agents/editorial/pull-requests.md` (when opening or drafting a pull request)
- `agents/engineering/dub.md` (when working on DUB / D packages in org repos)
- `skills/CATALOG.md` (when installing, authoring, or auditing Cursor skills)

Repo-local `AGENTS.md` in the active project is **additive** — read it when you open that repository.

*(Fallback)*: If filesystem access is missing, follow the obligations below.

## Org obligations (always on dev-centr work)

- **Sync before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`; pull/rebase before coding on a stale HEAD.
- **One Antora site per org:** hub at [docs.devcentr.org](https://docs.devcentr.org); wire project `docs/` into the hub playbook; do not publish a second public Antora site on project GitHub Pages. See `general/antora-docs-sites.md`.
- **Public README chrome:** follow `general/readme-layout.md`; hub link **Explore the docs »** → org docs.
- **Changelogs:** every owned project; functional changes; README links; index + `changelog-details/date - title`.
- **Config:** SDL (`.sdl`) on DevCentr-owned / `sdlang-d` surfaces; KDL (`.kdl`) greenfield outside that stack; JSON5 in the JSON family. No Extended SDL/XDL.
- **Issues:** draft in `ISSUES_REPO` per its instructions — not only in chat.
- **Skills:** canonical copies under `skills/` in this repo; junction into `~/.cursor/skills/<name>/`. Inventory in `skills/CATALOG.md`. Do **not** paste skill bodies into this always-on preamble.

## AI ops

- Stale APIs: Context7 MCP; else Outdated Code Protocol (`general/global.md`).
- Cursor skills: `skills/BOOTSTRAP.md` + `skills/CATALOG.md`; separate skills per job (`writing-news`, `writing-blog`, `fix-docs-encoding`).
- **Docs encoding:** hand-authored Antora SVG/adoc breakage is usually **transcode corruption** (Windows mojibake / invalid SVG XML), not Antora plugins and not a refactor. Use skill `fix-docs-encoding` (`skills/fix-docs-encoding/`) — run its script `--check` / `--fix` after figure edits. Always-on tips: `general/documentation.md`.
- Deep framing: general-knowledge *Vibe coding bootstrap* / *Bootstrap Cursor skills* on docs.devcentr.org.

## Local shortcut (team convention)

Optional junction so the org folder shows the org entry file:

```powershell
cmd /c mklink /J "$CODE_ROOT\github.com\dev-centr\AGENTS.md" `
  "$AGENT_RULES_PATH\AGENTS.md"
```

Prefer [`rules-manager`](https://github.com/dev-centr/rules-manager) to compose personal + org sections into one watched file.
