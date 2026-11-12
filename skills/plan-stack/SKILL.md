---
name: plan-stack
description: >-
  Use when a chat has no project stack, plan-stack.kdl, meta-plan, dependency
  stack, original ask buried, conversation drifted, side issue first, outstanding
  list, after several conversation changes, standard chat, org folder workspace,
  many repos in one workspace, Cursor projects limited to one repository,
  resume the backlog, what was next, keep working on the backlog.
---

# Plan stack

A long chat forgets the original ask when a later idea has to land first. Harness modes that already keep a multi-repo stack use that. Standard chat does not. Detail: `general/plan-stack.md`.

## When this applies

Use the file when the mode has no stack of its own that can name work in more than one repo.

Cursor cloud Projects is one repository in the cloud. It does not cover an org folder of many repos. The in-chat todo widget is session state. Neither one is this stack.

Do not use TickTick, a human task file, or `routine-ledger` for items the agent can do. Those stay human steps, team boards, and recurring or upstream watches.

## File

`plan-stack.kdl` at the workspace root the human bound this chat to.

- An org folder (many repos, not one product checkout) keeps the file there. It is not copied into each child repo.
- A single-repo workspace keeps the same filename and does not commit it. Denylist gitignores gain the name. Allow-list gitignores do not allow-list it.

## Attention

Before choosing the next implementation step, read the file.

Resume the `active` item. If none is `active`, resume the first `open` item whose `needs` are all `done`. Name that item in one sentence, then do it.

A new idea that must happen first becomes its own item with `status=active`. Add its id to the older item's `needs`. Leave the older item `open`. When the new item is `done`, set the older one `active` if its other needs are done.

Finished items stay `done`. Drop an item only when the human cancels it (`dropped`).

Design write-ups stay in the harness plan files. The stack links them. The stack is the order.
