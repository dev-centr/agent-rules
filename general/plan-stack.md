# Plan stack

Long chats lose the original ask when a prerequisite shows up mid-thread. This file is the order and the dependencies. It is not a design doc, a human task list, or a timer.

Skill: `skills/plan-stack/SKILL.md`.

## Who uses it

| Mode | Stack |
| --- | --- |
| Harness already keeps a multi-repo project stack | Use that. Do not also keep this file. |
| Cursor cloud Projects (one repo, cloud) | That list covers its one repo. An org folder of many repos still needs this file. |
| Standard chat, including an in-chat todo widget | `plan-stack.kdl` at the workspace root. |

TickTick and `HUMAN_TASKS_BACKEND` are steps only a person can do (`general/human-task-list.md`). `routine-ledger` is recurring work and upstream watches. Agent work that this chat must resume stays here.

## Where

`plan-stack.kdl` at the workspace root.

The workspace may be one repo or an org directory that contains many repos. One file for that root. Do not split a copy into each child repo.

Session state, not product source. A denylist gitignore lists `plan-stack.kdl`. An allow-list gitignore does not exception it. An org directory that is not a git repo just holds the file.

## Shape

```kdl
stack {
  item "expand-editor" title="Build the expand-in-place editor" status=open {
    needs "lang-island"
    plan "expand_in_place_editor.plan.md"
    repo "dev-centr/expand-in-place"
  }
  item "lang-island" title="CentrMark language island" status=done {
    repo "dev-centr/centrmark"
  }
}
```

| Field | Meaning |
| --- | --- |
| `item` id | Stable short id. Later `needs` use this id. |
| `title` | The outcome in one sentence. |
| `status` | `open`, `active`, `done`, or `dropped`. |
| `needs` | Ids that must be `done` before this item is resumed. |
| `plan` | Optional design file name, relative to the harness plans directory or the workspace. |
| `repo` | `owner/name` when the work lives in a repo. Several repos are several `repo` properties. |

One `active` item. `open` items wait. `done` stays on the file so a later turn can see that it shipped. `dropped` is the human canceling it.

## Order of work

1. Read the file before the next implementation step. Create it when this chat already has more than one outcome and the file is missing. Record only outcomes the human asked for or that a named plan already lists.
2. A prerequisite idea is a new `active` item. The original item gains that id in `needs` and stays `open`.
3. When the prerequisite is `done`, mark `active` the item that needed it, if every other need is `done`.
4. Say the resumed item in one sentence, then do that item. Do not ask what was next when the file already says.
