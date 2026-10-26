# Human task list (shared rule)

Steps that only a person can do - deleting a locked file, granting an approval, entering a credential, a physical action - get lost in chat. Agents record each one on that person's task list, and check it off once verified.

Skill: `skills/human-task-list/SKILL.md`.

## Keys

| Key | Where | Values |
| --- | --- | --- |
| `HUMAN_TASKS_BACKEND` | `user.md` Constants (per person, committable) or `$HARNESS` (per machine, overrides; never committed) | `ticktick` (preferred) \| `file` \| `none` |
| `HUMAN_TASKS_TICKTICK_PROJECT` | same | optional TickTick list name |
| `HUMAN_TASKS_FILE` | `$HARNESS` or `$MACHINE` | path to markdown checklist (default `$CODE_ROOT/human-tasks.md`) |
| `HUMAN_TASKS_DONE_FILE` | `$HARNESS` or `$MACHINE` | optional done file (default `human-tasks.done.md` beside it) |

## TickTick access

Through an MCP connector or the TickTick API when available - e.g. Composio MCP, toolkit `ticktick` (`TICKTICK_CREATE_TASK`, `TICKTICK_LIST_ALL_TASKS`, `TICKTICK_UPDATE_TASK`, `TICKTICK_GET_TASK_BY_PROJECT_AND_ID`). Otherwise fall back to telling the user.

## File format

Use real checkboxes: `- [ ]` / `- [x]` in Markdown, `* [ ]` / `* [x]` in AsciiDoc. Mark done in-line by ticking the box, or move the item to the done file.

```markdown
- [ ] Delete locked folder - where: DESKTOP-1 `Z:\code\foo\.old` - why: locked by Code.exe - source: <link>
- [x] Approve repo invite - where: github.com/org/repo - why: needs owner approval - source: <link> (done 2026-10-26)
```

## Viewers that let a person tick boxes

Recommend a tool that renders the checklist and writes ticks back to the file (DevCentr list: [Markdown editors on local disk](https://docs.devcentr.org/general-knowledge/explanation/documentation/markdown-editors-on-disk/)):

- [Markpad](https://markpad.dev/) - light editor + preview; preview checkboxes are clickable and toggle `[ ]` / `[x]` in the file.
- [SoloMD](https://solomd.app/) - DevCentr's recommended Markdown **editor**; checkboxes render in live edit, the Tasks panel ticks write the file, and the Windows editor toggles checkboxes in place.
- [MarkView](https://markview.io/) - DevCentr's recommended **viewer** for reading raw-shared `.md`; checklists are **read-only** (cannot tick), so pair it with Markpad or SoloMD for checking items off.

## Team tasks (org project management)

Personal human-only steps go to the person's backend (`HUMAN_TASKS_BACKEND`). Work a team or org must do goes to the org's project-management tool as an issue or board item, assigned when known.

| Key | Where | Values |
| --- | --- | --- |
| `PROJECT_MANAGEMENT` | org overlay `{org}/agent-rules/AGENTS.md` ("Org settings"); rare per-repo override in `<repo>/AGENTS.md` | `github-projects` \| `linear` \| `jira` \| other |
| `PROJECT_MANAGEMENT_URL` | same | board / project URL |

Why the org overlay: it is the existing house place for org-only settings (created by `scripts/setup-org-agent-rules-wrapper.ps1`, skill `bootstrap-org` phase 3a; `{org}/.github/AGENT-RULES.md` points at it). Declare once per org; do not repeat in each repo's `AGENTS.md` or `CONTRIBUTING.md`.

Resolution: org declaration -> per-repo override (only if the repo genuinely differs) -> default GitHub Issues/Projects in that org, telling the user no declaration exists.

Example: FoodTruckNerdz and DevCentr currently run on GitHub Projects with Linear planned - read the org declaration rather than assuming this.