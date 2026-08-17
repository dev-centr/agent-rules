# Org agent orchestration

Entry point for **Dev-Centr org** instruction modules in `dev-centr/agent-rules`.

## Always relevant on org repos

- Editorial titles when writing outward (news) or inward (blog) copy → `editorial/titles.md`
- Pull request titles and inviting summaries → `editorial/pull-requests.md` (detail in `../general/pull-requests.md`)
- Skills governance when adding or junctioning Cursor skills → `../skills/CATALOG.md`

## Load by task

| Task signal | Module |
| --- | --- |
| DUB, `dub.json`, registry pins, `dub add-local` | `engineering/dub.md` |
| "publish to dub" / "publish to dlang" / "publish dlang" | Cursor skill `publish-to-dub` |
| Tag / ship a version, GitHub rolling `v2` | Cursor skill `tag-release` |
| Authoring a skill / `SKILL.md` / skill `description` | Cursor skill `write-skill` |
| News / blog / essay titles | `editorial/titles.md` |
| Opening or drafting a pull request | `editorial/pull-requests.md` |
| News body copy (ship note, org announcement) | Cursor skill `writing-news` |
| Blog body copy (essay, philosophy, tutorial narrative) | Cursor skill `writing-blog` |

## Not here

- Portable dev environment rules → `RULES.md` + `general/*` (personal profile)
- Dev-Centr product automation → `devcentr-agent-rules`
- Machine paths and hardware → `$CODE_ROOT/MEMORIES.md`
- Single-repo facts → that repo’s `AGENTS.md`

## Precedence

On `dev-centr/*` work, org modules and this tree **override** personal portable rules where they conflict. See root `AGENTS.md`.
