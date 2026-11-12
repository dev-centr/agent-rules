# Plan stack

Long chats lose the original ask when a prerequisite shows up mid-thread. This file is the order and the dependencies. It is not a design doc, a human task list, or a timer.

Skill: `skills/plan-stack/SKILL.md`.

## Who uses it

| Mode | Stack |
| --- | --- |
| Harness already keeps a multi-repo project stack | Use that. Do not also keep this file. |
| Cursor cloud Projects (one repo, cloud) | That list covers its one repo. An org folder of many repos still needs this file. |
| Standard chat, including an in-chat todo widget | `plan-stack.kdl` under the agent workspace `sessions/<chat-id>/`. |

TickTick and `HUMAN_TASKS_BACKEND` are steps only a person can do (`general/human-task-list.md`). `routine-ledger` is recurring work and upstream watches. Agent work that this chat must resume stays here.

## Where

One file per chat: `$AGENT_WORKSPACE_ROOT/sessions/<chat-id>/plan-stack.kdl`.

That tree is this machine's agent notes (`general/agent-workspace.md`). The file is not part of a product repository and not part of a code workspace a person opened to work on a project. A person browsing a repo should not find a chat's open work sitting in it.

## Not the other plan-stack

`dev-centr/plan-stack` is a local daemon and a visual queue of estimated waits. This file is the list of outcomes for one chat. They share a name and not a store.

## Same record, different stores

These are the same kind of node at different reaches. Do not ship a second task product for each reach.

| Store | Reach | What it is good for |
| --- | --- | --- |
| Memory | This turn | The path already loaded: ancestor summaries and the active node's children. Rebuilt at the start of a turn. Not something another harness can read. |
| Local database | This machine, while it is up | A path query without opening every node. A cache. CLI and MCP are doors onto that cache. |
| Git ledger | Harnesses and machines that are not up at the same time | The shared copy and the audit trail. The [routine ledger](https://github.com/dev-centr/agent-rules/blob/main/docs/modules/agent-rules/pages/design/routine-ledger.adoc) is this store for recurring work. |

A chat outcome is not a routine. Recurring handoff stays in the routine ledger. One chat's outcomes stay in the session file. If a later query service is built, it caches the git ledger and the session tree. It does not replace the git ledger. The git history is how a person checks what a harness claimed while another machine was off.

The in-memory copy is only as good as the summaries written when the idea arrived. It does not recover a sentence that was never stored.

## Header

Every `plan-stack.kdl` starts with comments a person can read. The comments say what the file is, that it is outside any product repository, that `plan` may be omitted, and how `status` and `needs` read. A later reader uses the comments before the entries.

## Shape

```kdl
// Work still open for one chat. Kept with this machine's agent notes, not in a product repository.
// `plan` may name a design write-up, and it can be omitted.
// `needs` lists outcomes that have to be finished before this one.
// `status` is open, active, done, or dropped. The active entry is the one underway.
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
