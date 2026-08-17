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
5. **`description`** is **trigger words** (utterances, filenames, task phrases) — not a lay description of the skill. Third person. Body = how; `name` = identity. Skill `write-skill`.

## Registered skills

| Skill | Triggers on | Status | Notes |
| --- | --- | --- | --- |
| `writing-news` | News item, ship note, org announcement, news channel body | active | `skills/writing-news/` |
| `writing-blog` | Blog post, essay, philosophy, thinking-in-public body | active | `skills/writing-blog/` |
| `fix-docs-encoding` | Mojibake (`â€œ`), SVG Encoding/EntityName errors, post-edit Antora SVG/adoc on Windows | active | Transcode repair script in `skills/fix-docs-encoding/scripts/` — not a refactor |
| `publish-to-dub` | "publish to dub", "publish to dlang", "publish dlang", register/publish a D package on code.dlang.org | active | `dubx` + `dub-publish`; official `dub` has no publish command |
| `bootstrap-org` | bootstrap an org, create a GitHub organization, start a company/nonprofit, library, CLI, desktop, Tauri, SolidStart, solid-ui, populate org data, org profile, `.github`, github.io, Antora docs hub, named SDL profile, paste a profile block, fast-path org/business/project bootstrap | active | Fast identity/project path; `profiles/*.sdl` is the list (site `/skills?cat=bootstrap` compiles it); IT literature stays in business-bootstrap |
| `tag-release` | tag a release, ship a version, cut `vX.Y.Z`, rolling `v2`/`v2.x`, GitHub Releases, pin vs float, `+` build metadata / dual-axis labels | active | One skill; `github.md` (moving aliases — GitHub does not compute 2.x) and `registries.md` (range rolling). Not a per-platform skill family. |
| `write-skill` | author/edit a Cursor skill, `SKILL.md`, skill frontmatter, YAML `description`; trigger words vs lay blurb; create-skill; `agent-rules/skills`; `~/.cursor/skills`; how to write skills | active | Wins over create-skill on `description` / auto-invoke. Layout leftover: Cursor `create-skill`. |

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
