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

Open items are plain list items; mark done in-line with a checkmark emoji (e.g. ✅) rather than `- [x]`, because people often read Markdown/AsciiDoc raw (same as `user.md`: "Task lists in files: mark done with checkmark emojis"). Or move the item to the done file.

```markdown
- Delete locked folder - where: DESKTOP-1 `Z:\code\foo\.old` - why: locked by Code.exe - source: <link>
- ✅ Approve repo invite - where: github.com/org/repo - why: needs owner approval - source: <link> (done 2026-10-26)
```