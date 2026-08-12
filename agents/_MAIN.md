# Org agent orchestration

Entry point for **Dev-Centr org** instruction modules in `dev-centr/agent-rules`.

## Always relevant on org repos

- Editorial titles when writing outward (news) or inward (blog) copy → `editorial/titles.md`
- Skills governance when adding or junctioning Cursor skills → `../skills/CATALOG.md`

## Load by task

| Task signal | Module |
| --- | --- |
| DUB, `dub.json`, registry pins, `dub add-local` | `engineering/dub.md` |
| News / blog / essay titles | `editorial/titles.md` |
| News body copy (ship note, org announcement) | Cursor skill `writing-news` |
| Blog body copy (essay, philosophy, tutorial narrative) | Cursor skill `writing-blog` |

## Not here

- Portable dev environment rules → `RULES.md` + `general/*` (personal profile)
- Dev-Centr product automation → `devcentr-agent-rules`
- Machine paths and hardware → `$CODE_ROOT/MEMORIES.md`
- Single-repo facts → that repo’s `AGENTS.md`

## Precedence

On `dev-centr/*` work, org modules and this tree **override** personal portable rules where they conflict. See root `AGENTS.md`.
