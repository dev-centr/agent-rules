# Agent skills catalog (Dev-Centr)

Living inventory for team skills in **`dev-centr/agent-rules/skills/`**. Personal-only experiments stay in your fork until upstreamed.

## Contract

| Location | Role |
| --- | --- |
| `$AGENT_RULES_PATH/skills/<name>/` | Canonical (this repo) |
| `$SKILLS_DISCOVERY_ROOT/<name>/` | Harness discovery when installed (from `$CODE_ROOT/harness.md`) |

Install: [`BOOTSTRAP.md`](./BOOTSTRAP.md). Architecture: https://docs.devcentr.org/agent-rules/harness-neutral.html

## Rules

1. **One skill per job** — separate skills with descriptions that trigger on distinct tasks (not one router skill for unrelated modes).
2. **Link, don’t fork** on disk unless intentionally diverging. Install method lives in `$harness.md`.
3. **Thin pointers** in `AGENTS.md` / `user.md` only — never paste `SKILL.md` bodies into always-on rules.
4. **PR to update this file** when adding, moving, or deprecating a skill.
5. **`description`** is **trigger words** (utterances, filenames, task phrases) — not a lay description of the skill. Third person. Body = how; `name` = identity. Skill `write-a-skill`.

## Registered skills

| Skill | Triggers on | Status | Notes |
| --- | --- | --- | --- |
| `harness-setup` | harness setup, harness.md, new machine, polyglot harness, template boundary, probe harness capabilities | active | Populates `$CODE_ROOT/harness.md`; read `general/harness-boundary.md` |
| `sync-agent-rules` | skills/rules drift, catalog vs discovery mismatch, broken junction, agent-rules behind origin, `AGENT_RULES_SYNCED_SHA`, `skills-set/` label, sync skills, autoupdate across machines | active | SHA authoritative; human tag `skills-set/YYYY.MM.DD` |
| `writing-news` | News item, ship note, org announcement, news channel body | active | `skills/writing-news/` |
| `writing-blog` | Blog post, essay, philosophy, thinking-in-public body | active | `skills/writing-blog/` |
| `fix-docs-encoding` | Mojibake (`â€œ`), SVG Encoding/EntityName errors, post-edit Antora SVG/adoc on Windows | active | Transcode repair script in `skills/fix-docs-encoding/scripts/` |
| `publish-to-dub` | "publish to dub", "publish to dlang", "publish dlang", DUB/code.dlang.org categories | active | `dubx` + `dub-publish`; official `dub` has no publish command |
| `library-registry-choice` | create library, path/`file:` dependency, publish vs local disk, registry for new package, unpublished owned dep | active | Ask publish vs path; encourage registry; suggest which |
| `library-registry-choice` | create library, path/`file:` dependency, publish vs local disk, registry for new package, unpublished owned dep | active | Ask publish vs path; encourage registry; suggest which |
| `bootstrap-org` | bootstrap an org, initialize an org, create a GitHub organization, SDL profile, org agent-rules overlay | active | Fast identity/project path; house org init uses pointer overlay |
| `github-profile-assets` | GitHub org profile assets, `profile/assets/`, org avatar PNG 256 | active | Pairs with `bootstrap-org` |
| `tag-release` | tag a release, ship a version, cut `vX.Y.Z`, rolling `v2`/`v2.x` | active | `github.md` + `registries.md` siblings |
| `write-a-skill` | author/edit agent skill, `SKILL.md`, skill frontmatter, YAML `description`; trigger words | active | Harness-neutral authoring; layout may use harness-specific scaffolds |
| `ship-app` | scaffolding/shipping GUI, CLI, TUI, library, game, service | active | Software Product Essentials |
| `antora-org-site` | Antora site, docs site, docs hub, antora theme, playbook, antora-playbook, GitHub Pages for docs; Valentus; Facto; antora-facto; compose pack; Kroki; Mermaid | active | Valentus lean; Facto compose pack — confirm |
| `public-readme` | README.md, README.adoc, public repo face, Best-README | active | GitHub adapter default |
| `draft-pr` | open/draft a pull request, `gh pr create`, PR title, PR summary | active | Voice in `skills/draft-pr/voice.md` |
| `git-commit` | git commit, commit message, commit staged/unstaged changes | active | User ask **or** end-of-run (`general/end-of-run.md`) |
| `push-code` | pushing code, git push, push changes, push to remote; end of agent run | active | Logical commits then push; standing end-of-run auth |
| `owned-changelog` | changelog, changelog-details, backfill from git, functional change in owned project | active | Match existing repo style |
| `env-names-registry` | env vars, `.env.example`, `ENV-VARIABLES.md`; names only | active | Never store secret values |
| `outdated-code-protocol` | Context7 unavailable, stale APIs, local library-docs fallback | active | Fallback when Context7 missing |
| `issue-reports` | issue report, bug report, blocker, upstream coordination, `gh issue create` | active | When filing warranted — not after every owned-repo change |
| `issues-repo-record` | record issue/PR to `.issues`, `submissions/`, push ISSUES_REPO | active | Always commit+push; pairs with `issue-reports` |
| `polyglot-ci` | GitHub Actions, release.yml, win/mac/lin/BSD, polyglot pack | active | macOS arm64 only |
| `record-rule` | make that a rule, save this rule, record a rule, persist preference, agent-rules layer; update AI rules/skills; sync harness + template | active | Routes to portable/org/project/harness-local per `harness-boundary` |
| `tool-inventory` | tools changed, record tool inventory, update local tool list snapshot | active | Harness-agnostic; writes via `machine.md` or `TOOL-INVENTORY.md` |

## Adding a skill (checklist)

- [ ] One job per skill; `description` is trigger words only (not a lay summary)
- [ ] Create `skills/<name>/SKILL.md` + progressive-disclosure siblings
- [ ] Install per `$CODE_ROOT/harness.md` (`SKILLS_INSTALL` → `$SKILLS_DISCOVERY_ROOT/<name>/`)
- [ ] Add row to this catalog
- [ ] Optional one-line pointer in `AGENTS.md`
- [ ] New agent chat → verify discovery or direct read

## Deprecating

Mark `deprecated`, point to replacement, remove discovery install after team notice. Changelog entry in this repo.

**Removed:** `writing-news-vs-blog` (router) — replaced by `writing-news` + `writing-blog`.

**Renamed:** `write-skill` → `write-a-skill` (slug was ambiguous with “write” as a verb).
