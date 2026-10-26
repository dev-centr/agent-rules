---
name: human-task-list
description: >-
  Use when a file lock prevents a delete, file in use, access denied on
  remove, EBUSY, a step only the human can do, needs user approval, needs a
  credential or password, needs a physical action, "add to my task list",
  "put it in TickTick", TickTick, HUMAN_TASKS_BACKEND, HUMAN_TASKS_FILE,
  human task list, todo for the user, tasks buried in chat, mark checklist
  item done, follow-up for the user, or when closing out a run that left
  manual steps, team task, org task, assign to teammate, file an issue for
  the team, project board, GitHub Projects, Linear, PROJECT_MANAGEMENT,
  PROJECT_MANAGEMENT_URL.
---

# Human task list

When the agent cannot finish a step itself, record it on that person's task list instead of leaving it buried in chat. Detail: `general/human-task-list.md`.

## Team tasks (org project management)

Work someone on a team or org must do (not only this user) goes to **that org's project-management tool** as an issue or board item, assigned when the assignee is known. Same item fields and dedupe/verify rules as below.

Resolve the tool:

1. **Org declaration** - `PROJECT_MANAGEMENT` + `PROJECT_MANAGEMENT_URL` in the org overlay `$CODE_ROOT/github.com/<org>/agent-rules/AGENTS.md` (for `dev-centr`, this repo's `AGENTS.md`). Declared once per org - not in per-repo `AGENTS.md` / `CONTRIBUTING.md`.
2. **Per-repo override** - only when that repo genuinely uses a different tool: the same keys in `<repo>/AGENTS.md`.
3. **Default** - GitHub Issues / Projects in that org; tell the user the org has no declaration.

Access: forge MCP or `gh` (`gh issue create`, `gh project item-add`); other tools via their MCP connector or API, else tell the user.

## Personal tasks

## What qualifies

Only steps the **human** must do because the AI cannot: locked-file deletes, approvals, credentials/sign-ins/2FA, physical actions, GUI-only or elevated steps the harness blocks. Not general todos the agent can do itself.

## Backend (per person or machine)

Resolve in order: `HUMAN_TASKS_BACKEND` in `$HARNESS` (machine override) -> `user.md` Constants (person) -> ask.

| Value | Access |
| --- | --- |
| `ticktick` (preferred) | Composio MCP connector, toolkit `ticktick`: `TICKTICK_LIST_ALL_TASKS` (duplicate check), `TICKTICK_CREATE_TASK`, `TICKTICK_GET_TASK_BY_PROJECT_AND_ID`, `TICKTICK_UPDATE_TASK`. Else the TickTick Open API when a token is configured. Optional `HUMAN_TASKS_TICKTICK_PROJECT`. |
| `file` | Markdown checklist at `HUMAN_TASKS_FILE` (machine-local path; default `$CODE_ROOT/human-tasks.md`, never committed). |
| `none` / unavailable | Tell the user in the final reply, with the item fields below. |

If the chosen backend is unreachable (connector missing, unauthenticated), fall back to telling the user - never silently drop the item.

## Item format

Each item states:

- **What** to do (imperative title)
- **Where**: machine name + absolute path (or app/URL)
- **Why** the AI couldn't (e.g. `file locked by Code.exe`, `needs 2FA code`)
- **Source**: link back (PR, issue, commit, chat/run link, or file path)

## Steps

1. **Dedupe first.** List open items (`TICKTICK_LIST_ALL_TASKS` or read the file); if an equivalent open item exists, update it instead of adding.
2. **Add** the item with all four fields.
3. **Verify, then mark done.** When the agent later confirms the step is complete (path gone, approval visible, login works), mark it done:
   - TickTick: use a complete-task tool if the connector has one; otherwise `TICKTICK_UPDATE_TASK` with completed status.
   - File: tick the real checkbox in-line - `- [ ]` -> `- [x]` (Markdown), `* [ ]` -> `* [x]` (AsciiDoc) - or move the item to the done file (`HUMAN_TASKS_DONE_FILE`, default `human-tasks.done.md` beside it) with the completion date. Viewers that let the person tick boxes: see `general/human-task-list.md`.
4. Never mark done on the user's word alone when it can be checked; never mark done unverified.
5. Mention added/completed items in the final reply, with links (below).

## Link the list in chat

Whenever the agent reads or writes a task list, the chat reply includes a clickable Markdown link with a descriptive label:

- **File:** the file itself as a `file:///` URL to the absolute local path (e.g. `[Human tasks (DESKTOP-1)](file:///Z:/code/human-tasks.md)`), plus the forge URL when the file is in a pushed repo.
- **TickTick:** the task(s) created or updated - the TickTick web task URL if the API returns one, otherwise the list/project URL.
- **Team tasks:** the issue or board item URL.

## Do not

- Put machine paths or personal backends in this skill or other forkable templates - use `user.md` Constants, `$HARNESS`, or `$MACHINE`.
- Add items the agent could do itself.