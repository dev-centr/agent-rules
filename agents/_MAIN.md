# Org agent orchestration

Entry point for **Dev-Centr org** instruction modules in `dev-centr/agent-rules`.

## Always relevant on org repos

- Editorial titles when writing outward (news) or inward (blog) copy → `editorial/titles.md`
- Pull request titles and inviting summaries → Cursor skill `draft-pr`
- Skills governance when adding or junctioning Cursor skills → `../skills/CATALOG.md`

## Load by task

| Task signal | Module |
| --- | --- |
| DUB, `dub.json`, registry pins, `dub add-local` | `engineering/dub.md` |
| "publish to dub" / "publish to dlang" / "publish dlang" / DUB categories | Cursor skill `publish-to-dub` |
| Bootstrap / initialize an org, `{org}/agent-rules` overlay | Cursor skill `bootstrap-org` |
| Authoring a skill / `SKILL.md` / skill `description` | Cursor skill `write-a-skill` |
| News / blog / essay titles | `editorial/titles.md` |
| Opening or drafting a pull request | Cursor skill `draft-pr` |
| News body copy (ship note, org announcement) | Cursor skill `writing-news` |
| Blog body copy (essay, philosophy, tutorial narrative) | Cursor skill `writing-blog` |
| Antora site / docs hub | Cursor skill `antora-org-site` |
| Public README | Cursor skill `public-readme` |
| Shipping an app | Cursor skill `ship-app` |
| Changelog (owned project) | Cursor skill `owned-changelog` |
| Bug/blocker/external issue (when filing warranted) | Cursor skill `issue-reports` |
| Record issue/PR in `ISSUES_REPO` / `.issues` | Cursor skill `issues-repo-record` |
| Git commit | Cursor skill `git-commit` |
| Push code / git push | Cursor skill `push-code` |

## Not here

- Portable dev environment rules → `RULES.md` + `general/*` (personal profile)
- Dev-Centr product automation → `devcentr-agent-rules`
- Machine paths and hardware → `$CODE_ROOT/MEMORIES.md`
- Single-repo facts → that repo’s `AGENTS.md`

## Precedence

On `dev-centr/*` work, org modules and this tree **override** personal portable rules where they conflict. See root `AGENTS.md`.
