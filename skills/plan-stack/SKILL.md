---
name: plan-stack
description: >-
  Use when a chat has no project stack, plan-stack.kdl, per-chat outcomes,
  session ask list, agent workspace sessions, not the plan-stack daemon,
  original ask buried, conversation drifted, side issue first, outstanding
  list, resume the backlog, what was next, keep working on the backlog,
  workspace move, move_agent_to_root, transcript folder, new chat history,
  record-move, plan-stack-locations, link does not resolve,
  agent-coordinator, agent-planner, schedule wait, interruption, steer,
  steer without interrupting, new message while work is open, context.kdl,
  chat kind, continue the old work, does not depend, update the plan
  tree, modifying an existing item.
---

# Plan stack

A long chat forgets the original ask when a later idea has to land first. Harness modes that already keep a multi-repo stack use that. Standard chat does not. Detail: `general/plan-stack.md`.

## When this applies

Use the file when the mode has no stack of its own that can name work in more than one repo.

Cursor cloud Projects is one repository in the cloud. It does not cover an org folder of many repos. The in-chat todo widget is session state. Neither one is this stack.

People say "agent-planner" for this list. The command is `agent-coordinator`.

## Chat kind

Before the first write, and again when the harness prompt gains or loses a project stack, classify this turn. Read the harness name from `$HARNESS` (`HARNESS_NAME`). Judge the kind from features in the prompt, not from the product name alone.

| What this turn's prompt contains | kind |
| --- | --- |
| A multi-repo project stack the harness already keeps | `harness-stack` |
| A one-repo cloud project list | `cloud-project` |
| Neither | `standard-chat` |

`harness-stack` uses that stack. Do not also keep this file.

`cloud-project` uses that list for its one repo. Work that spans an org folder of repos still uses this file.

`standard-chat` uses this file. An in-chat todo widget is not this file.

Write the result in `sessions/<chat-id>/context.kdl`. Read it at the start of the next turn before choosing work.

```kdl
// Chat kind for this conversation. Read this before choosing the next step.
// kind is harness-stack, cloud-project, or standard-chat.
context {
  kind "standard-chat"
  harness "cursor"
  reason "The prompt has no multi-repo project stack and no one-repo cloud project list."
}
```

## Every new message

When the kind is `standard-chat`, or `cloud-project` work spans more than one repo, read the new message before changing the plan. A steer, a follow-up, or a correction does not replace the item already underway.

1. Read `context.kdl` and `plan-stack.kdl`.
2. Decide whether the message revises an item already on the tree, or is new work. Decide whether the item underway depends on that change.
3. Update the tree. If the message changes an existing outcome, revise that item's title, needs, plan, or status. Do not add a second item for the same outcome. If it is new work, add an item. Do not mark the item underway `dropped`, and do not start a new list.
4. If the item underway does not depend on the update, leave it `active` and keep working on it. A newly added item stays `open`. A revision of some other item keeps that item's status unless the message changed it.
5. If the item underway depends on the update, set the blocking item `active` and add its id to the older item's `needs`. The older item stays `open`. When the message revises the item underway, that item stays `active` and the next step is the revised work.
6. Run `agent-coordinator plan import` when that command is on the path or already built under `dev-centr/coordination`.
7. Say the active item's title in one sentence, then do that item.

Do not use TickTick, a human task file, or `routine-ledger` for items the agent can do. Those stay human steps, team boards, and recurring or upstream watches.

## File

`$AGENT_WORKSPACE_ROOT/sessions/<chat-id>/plan-stack.kdl`. Agent notes, not a product file and not the workspace root of a repo.

The first lines are comments a person can read: what the list is, that `plan` may be omitted, and what `status` and `needs` mean.

This skill is not the `dev-centr/plan-stack` column process. Recurring work shared across harnesses stays on the routine ledger (git). The command `agent-coordinator` (`dev-centr/coordination`) is the database: `plan` is the tree, and `schedule wait` points at a node. It does not replace the git ledger. The column process keeps JSON files when that database is down. Those files are not the routine ledger.

`agent-coordinator serve` can run more than once: another port, or one copy printing in a terminal and one in the background. Starting it follows skill `service-manager`. The column process on port 17358 is one process per machine. A second start finds that process. It does not get a `server 1` id unless a second copy becomes a real case, and then the same skill applies.

## Workspace move

Cursor keeps the old transcript under the old workspace slug and can mint a new chat id. That is still this chat. The session directory stays the first id. Do not start a second `plan-stack.kdl`.

After `move_agent_to_root` succeeds, before the next task, record both folders with `agent-coordinator plan record-move`. The database cannot see the move. That command is the notification. When the command is not built yet, write the same fact with:

`powershell -NoProfile -File $AGENT_RULES_PATH/scripts/plan-stack-locations.ps1 record-move --canonical <first-id> --from-cursor-chat <old-id> --to-cursor-chat <new-id> --from-project-key <old-slug> --to-project-key <new-slug> --from-root <old-folder> --to-root <new-folder>`

Use `pwsh -NoProfile -File` when PowerShell 7 is installed. The script is the same. `agent-coordinator plan import` reads that file into the database. If the harness prompt names a transcript id that is not the session folder you have been using, the move was not recorded yet. Run `record-move`, then keep reading the stack from the canonical session.

A link that does not open is a `resolve` miss. Show its `hint`. `workspace-fragmented` means the chat has more than one folder. `never-recorded` means `record-move` has not been run. `file-missing` means the recorded folder is gone. None of those mean the chat was deleted.

When you can see the files gathered into one folder, run `repair` with that folder and the transcript id it belongs to. Old keys stay as aliases. Detail: `general/plan-stack.md`.

## Attention

Before choosing the next implementation step, read `context.kdl` and the plan file.

Resume the `active` item. If none is `active`, resume the first `open` item whose `needs` are all `done`. Name that item in one sentence, then do it.

After the new message is on the tree, keep working on the item already underway when that item does not depend on the new ask. Switch only when it does: the new item becomes `active`, and the older item lists that id under `needs` and stays `open`. When the new item is `done`, set the older one `active` if its other needs are done.

Finished items stay `done`. Drop an item only when the human cancels it (`dropped`).

Design write-ups stay in the harness plan files. The stack links them. The stack is the order.
