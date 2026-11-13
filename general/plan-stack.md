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

The directory name is the canonical chat id: the first id recorded for that conversation. A workspace move must not start a second directory.

## Transcript locations

Cursor stores each chat under a directory named from the workspace path (`z-code-github-com-…`). Renaming that folder, or moving the chat onto a new workspace, leaves the old transcript where it was and starts a second directory. The second directory can have a new chat id. Those two directories are one conversation. The plan stack stays under the first id.

A link stores three things: the canonical chat id, the Cursor transcript id that held the sentence, and the segment and turn inside that transcript. It may also store a short quote of the sentence. It does not store a project slug or a folder path. The slug changes when the workspace is renamed. Segment numbers are not global: each transcript folder starts its own `segment_000.md`. A bare segment number from the other folder is a different sentence.

Aliases live in `sessions/<canonical-id>/locations.kdl`. Each Cursor chat id, project slug, workspace URI, and transcript folder is a row. One row of each kind is `live=true` (the folder Cursor is writing now). Older rows stay, with `role=original` on the first value and `role=alias` on the rest. `sessions/location-index.kdl` maps a Cursor chat id, or one transcript folder, to the canonical id. A project slug is not an index key. Many chats share one workspace folder.

The database cannot watch Cursor's directories. The agent that just moved the workspace is the only party that knows both paths. After that move succeeds, and before the next task, that agent runs `record-move`. That call is the notification. There is no other signal. The command adds the new id and the new folder as aliases and marks them live. It does not create a second plan stack.

`resolve` opens the transcript the link named. When that file is in an older folder, the result says so and names the live folder. When the file is in none of the recorded folders, the result is a miss. The miss carries `status`, `reason`, `canonical`, and `hint`. `reason` is `never-recorded`, `workspace-fragmented`, or `file-missing`. The hint says which keys were tried and why a path-shaped link failed: Cursor split the chat across workspace paths, and the old key is still an alias of the canonical id. A caller shows that hint. It does not treat the miss as a deleted chat.

When a later agent can see that the files were gathered back into one folder, it runs `repair` and passes the folder it found, with the transcript id those files belong to. Repair marks that folder live, sets the others `present`, `missing`, or `reunited`, and keeps every old key. Links that stored the canonical id and the transcript id do not need new paths. `resolve` follows the transcript id to whichever folder is live for it. Another transcript's segment numbers are not copied onto that folder.

A later MCP or HTTP door returns the same fields the CLI prints. It does not invent a second shape.

Commands, from this repo. `powershell` is Windows PowerShell. Use `pwsh -NoProfile -File` when PowerShell 7 is installed. The script is the same.

```text
powershell -NoProfile -File scripts/plan-stack-locations.ps1 record-move --canonical <first-chat-id> --from-cursor-chat <id> --to-cursor-chat <id> --from-project-key <slug> --to-project-key <slug> --from-root <folder> --to-root <folder>
powershell -NoProfile -File scripts/plan-stack-locations.ps1 resolve --chat <id> [--cursor-chat <id>] [--segment <n>] [--turn <n>] [--quote <text>]
powershell -NoProfile -File scripts/plan-stack-locations.ps1 repair --chat <id> [--cursor-chat <id> --live-root <folder>] [--live-project-key <slug>] [--files-moved]
powershell -NoProfile -File scripts/plan-stack-locations.ps1 show --chat <id>
```

## Not the other plan-stack

`dev-centr/plan-stack` draws schedule columns: estimated waits, and a phase that points at a plan node. This file is the list of outcomes for one chat. The command for both is `agent-coordinator` in `dev-centr/coordination`. `plan` is the tree. `schedule wait` stores the estimate and the live signal. The plan title stays on the node.

## Coordination suite

`agent-coordinator serve` on `127.0.0.1:17359` is the local database and the browser. `--public` with a hosted token is the online database Dev-Centr can sell. A workstation token stays on this machine.

Import this chat's `plan-stack.kdl` and `locations.kdl` with `agent-coordinator plan import`. After a workspace move, `agent-coordinator plan record-move` writes the database. The location file remains the copy a person can read when the database is down. The column process keeps its own JSON files in that case. Those files are not the routine ledger. The git routine ledger remains the copy for recurring work when no machine is up.

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
