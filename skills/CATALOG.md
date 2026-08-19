# Cursor skills catalog (Dev-Centr)

Living inventory for team skills in **`dev-centr/agent-rules/skills/`**. Personal-only experiments stay in your fork until upstreamed.

## Contract

| Location | Role |
| --- | --- |
| `$AGENT_RULES_PATH/skills/<name>/` | Canonical (this repo) |
| `~/.cursor/skills/<name>/` | What Cursor discovers (junction or copy) |
| `~/.cursor/skills-cursor/` | Cursor built-ins — **do not author here** |

Install: [`BOOTSTRAP.md`](./BOOTSTRAP.md). Team SOP: member-only [team.docs.devcentr.org](https://team.docs.devcentr.org).

## Rules

1. **One skill per job** — separate skills with descriptions that trigger on distinct tasks (not one router skill for unrelated modes).
2. **Junction, don’t fork** on disk unless intentionally diverging.
3. **Thin pointers** in `AGENTS.md` / `RULES.md` only — never paste `SKILL.md` bodies into always-on rules.
4. **PR to update this file** when adding, moving, or deprecating a skill.
5. **`description`** is **trigger words** (utterances, filenames, task phrases) — not a lay description of the skill. Third person. Body = how; `name` = identity. Skill `write-a-skill`.

## Registered skills

| Skill | Triggers on | Status | Notes |
| --- | --- | --- | --- |
| `writing-news` | News item, ship note, org announcement, news channel body | active | `skills/writing-news/` |
| `writing-blog` | Blog post, essay, philosophy, thinking-in-public body | active | `skills/writing-blog/` |
| `fix-docs-encoding` | Mojibake (`â€œ`), SVG Encoding/EntityName errors, post-edit Antora SVG/adoc on Windows | active | Transcode repair script in `skills/fix-docs-encoding/scripts/` — not a refactor |
| `publish-to-dub` | "publish to dub", "publish to dlang", "publish dlang", DUB/code.dlang.org categories, register/publish a D package | active | `dubx` + `dub-publish`; always POST 1–4 categories; official `dub` has no publish command |
| `bootstrap-org` | bootstrap an org, initialize an org, create a GitHub organization, start a company/nonprofit, library, CLI, desktop, Tauri, SolidStart, populate org data, org profile, `.github`, github.io, Antora docs hub, named SDL profile, paste a profile block, org agent-rules overlay, fast-path org/business/project bootstrap | active | Fast identity/project path; `profiles/*.sdl` is the list (site `/skills?cat=bootstrap` compiles it); house org init uses a pointer `{org}/agent-rules` overlay (no submodule). IT literature stays in business-bootstrap |
| `github-profile-assets` | GitHub org profile assets, `profile/assets/`, `.github` logos, org avatar PNG 256, profile README images, brand revision archive, export profile rasters | active | Standard `{org}/.github/profile/assets/`; pairs with `bootstrap-org` |
| `tag-release` | tag a release, ship a version, cut `vX.Y.Z`, rolling `v2`/`v2.x`, GitHub Releases, pin vs float, `+` build metadata / dual-axis labels | active | One skill; `github.md` (moving aliases — GitHub does not compute 2.x) and `registries.md` (range rolling). Not a per-platform skill family. |
| `write-a-skill` | author/edit a Cursor skill, `SKILL.md`, skill frontmatter, YAML `description`; trigger words vs lay blurb; create-skill; `agent-rules/skills`; `~/.cursor/skills`; how to write skills | active | Wins over create-skill on `description` / auto-invoke. Layout leftover: Cursor `create-skill`. |
| `ship-app` | scaffolding/shipping a GUI, CLI, TUI, library, game, service; Software Product Essentials; About; debug dump; auto-update; installer; CI release; 1.0 | active | Pointers into general-knowledge architecture docs |
| `antora-org-site` | Antora site, docs hub, antora-playbook, GitHub Pages for docs, Lunr, antora-search-chat, Valentus, KaTeX, one Antora site per org | active | Valentus is a suggestion — confirm before applying |
| `public-readme` | README.md, README.adoc, public repo face, Best-README, Explore the docs, shields.io, Built With | active | GitHub adapter default; other forges swap metric URLs |
| `draft-pr` | open/draft a pull request, `gh pr create`, PR title, PR summary, PR screenshots | active | Voice in `skills/draft-pr/voice.md` |
| `git-commit` | git commit, commit message, commit staged/unstaged changes | active | User must ask to commit |
| `push-code` | pushing code, git push, push changes, push to remote, push my commits | active | Split dirty tree into logical commits, then push |
| `owned-changelog` | changelog, changelog-details, backfill from git, wire changelog into docs, functional change in an owned project | active | Match existing repo style when present |
| `env-names-registry` | env vars, `.env.example`, `ENV-VARIABLES.md`, ENV.md, new integration, Netlify env; names only | active | Never store secret values |
| `outdated-code-protocol` | Context7 unavailable, stale APIs, `AI-LOCAL-LIBRARY-DOCS.local.json5`, `_local-library-docs`, Dlang clone-source | active | Fallback when Context7 is missing |
| `issue-reports` | issue report, bug report, blocker, upstream coordination, `gh issue create`, `ISSUES_REPO`, `.issues` submissions | active | How-to only; when filing warranted — not after every owned-repo change |
| `issues-repo-record` | record issue/PR to `.issues`, `submissions/`, push ISSUES_REPO, embed screenshot in gh body, `raw.githubusercontent.com`, unfiled/pending/blocked submission | active | Always commit+push; images push before embed; pairs with `issue-reports` and `draft-pr` |
| `polyglot-ci` | GitHub Actions, release.yml, win/mac/lin/BSD, x64, arm64, macos-14, ubuntu-24.04-arm, cosmocc, APE, binary-tailor, polyglot pack, Intel Mac runners | active | macOS arm64 only; pack with Binary Tailor |
| `record-rule` | make that a rule, save this rule, record a rule, add a rule, create a rule, persist this preference, remember this, add to agent-rules, `.cursor/rules`, AGENTS.md rule, RULES.md update | active | Persists instructions to the right agent-rules layer + Cursor `.mdc` |
| `tool-inventory` | tools changed, installed/removed/updated tools or skills, record tool inventory, update local tool list snapshot | active | Writes a local, non-secret tool inventory snapshot (timestamp + tool names) via `MEMORIES.md` or `TOOL-INVENTORY.md` |

## Adding a skill (checklist)

- [ ] One job per skill; `description` is trigger words only (not a lay summary)
- [ ] Create `skills/<name>/SKILL.md` + progressive-disclosure siblings
- [ ] Junction: `cmd /c mklink /J "%USERPROFILE%\.cursor\skills\<name>" "%AGENT_RULES_PATH%\skills\<name>"`
- [ ] Add row to this catalog
- [ ] Optional one-line pointer in `AGENTS.md`
- [ ] New agent chat → verify discovery

## Deprecating

Mark `deprecated`, point to replacement, remove junction after team notice. Changelog entry in this repo.

**Removed:** `writing-news-vs-blog` (router) — replaced by `writing-news` + `writing-blog`.

**Renamed:** `write-skill` → `write-a-skill` (slug was ambiguous with “write” as a verb).
