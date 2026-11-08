---
name: routine-ledger
description: >-
  Use when a task is recurring, scheduled, event-driven, or blocked on upstream;
  remind me, every day/week, check back, watch this issue/PR/release, when X ships,
  monitor, cron, Task Scheduler, missed run, routine, trigger, repository_dispatch,
  routine-ledger, claim/lease/heartbeat, harness target, dependency watch, workaround
  for an upstream bug, project-management discovery (GitHub Projects, Linear, Jira),
  session start in a harness without routine checks, onboarding a new harness or org.
---

# Routine ledger

Design: [routine-ledger.adoc](../../docs/modules/agent-rules/pages/design/routine-ledger.adoc).
Schemas: [`schemas/routine-ledger/`](../../schemas/routine-ledger/) (JSON5 files, JSON Schema 2020-12).
Until the `routine-timer` CLI exists, follow the **manual procedure** below with `gh` or the GitHub MCP.

## 1. Register, do not just act once

- If a request is recurring, scheduled, or "when X happens", **register a routine** in the ledger
  in addition to doing the first run. Do not rely on your own harness memory.
- If work is **blocked by or depends on** an upstream bug, PR, or release, register a
  **dependency watch** without being asked (section 6).
- Multi-harness routines are shared: set `requires` to capabilities, not a harness name.
  `preferred_targets` is a hint only.
- Tell the owner what you registered (routine id and file link). Registering is allowed;
  posting anything outside the ledger is not.

## 2. Where the ledger lives

| Scope | Location |
| --- | --- |
| Owner or team ledger | `<owner>/routine-ledger` (Ryan: his personal ledger) |
| Org project-management record (subscribing org) | `<org>/agent-rules`, layered on `dev-centr/agent-rules`; repo rules last |
| Guest repo / non-subscribing org | Owner's ledger `pm/<org>.json5`, `confirmed: false`. **Never write into their repos.** |

Layout: `routines/<id>.json5`, `runs/<yyyy>/<mm>/<routine-id>/<run-id>.json5`,
`targets/<harness-id>.json5`, `machines/<machine-id>.json5`, `pm/<scope>.json5`,
`bootstrap/<scope>.json5`, `archive/<yyyy>/<routine-id>.json5`.
Files are JSON5 and must validate: `node skills/routine-ledger/validate.mjs <schema> <file>`.
Prefer adding new files over editing existing ones.

## 3. Session start (harnesses without routine checks)

1. `git pull` the ledger, or read it via the GitHub MCP.
2. **Missed runs:** for each active routine, compute occurrences since the last run file.
   An occurrence with no `finish` and no unexpired lease is missed. Apply `catch_up`
   (`skip` writes a `skipped` run; `run-once` runs the latest only; `run-all` runs each).
3. Claim only what your capabilities cover (section 4). Do not claim more than you can finish this session.
4. If `bootstrap/harness:<your-harness>.json5` is missing or not `complete`, run section 8.

## 4. Claim protocol (issue comments in the ledger repo)

One **run issue** per run, titled `run: <routine-id> <run-id>`, label `routine-run`,
locked to collaborators. Each protocol comment is exactly one fenced `json5` block
(schema `claim-comment`), optionally followed by one human-readable line:

````markdown
```json5
{ routine_ledger: 1, kind: "claim", routine: "watch-git-ai-2399", run_id: "20261109T1500Z",
  harness: "cursor-desktop", session_id: "<real session id>", machine: "ab9557fa",
  capabilities: ["shell", "gh", "rust-build", "windows"],
  at: "2026-11-09T15:00:40Z", lease_expires: "2026-11-09T15:45:40Z" }
```
````

| `kind` | Extra required fields | Meaning |
| --- | --- | --- |
| `claim` | `capabilities`, `lease_expires` | Request. |
| `start` | `lease_expires`, `claim_comment` | **The lock.** Post only if your claim won. |
| `heartbeat` | `lease_expires` | Extend the lease before it expires. |
| `finish` | `status` (`done`/`failed`/`skipped`), `result` | Done; then write the run file. |
| `release` | none | Give up a claim or lock early. |

**Winner rule:** read all comments in creation order. A claim is *valid* if its author is a
repo collaborator or allowlisted bot, its JSON5 validates, its `capabilities` cover the
routine's `requires`, and no earlier lock is still live. **The earliest valid claim wins.**
If you lost, back off silently. A lock whose `lease_expires` passes with no heartbeat is
void; the next valid claim posted after expiry may start. Record the real session ID on
claim and start. Times are UTC ISO 8601.

Post with the harness's own bot or app token, never the owner's account, and never
@-mention the owner unless a human decision is needed. The owner watches the ledger repo
on **Ignore**.

## 5. Projects dashboard fields

After each protocol step, update the routine's item in the ledger's GitHub Project (v2):
**Status** (`scheduled`, `claimed`, `running`, `done`, `missed`, `failed`), **Claimed by**,
**Session ID**, **Lease expires**, **Next run**. Fields are a view; comments and files are the truth.
Example: `gh project item-edit --id <item> --project-id <proj> --field-id <field> --text <value>`.

**Cloud workers that cannot push:** open a PR with the run or routine file, or post the
`finish` comment with the run file as a second `json5` block. The first merge-capable actor
merges outstanding ledger PRs (additive files only) **before** pulling. Never force-resolve;
label conflicting PRs `needs-human` and report them.

## 6. Dependency watches (`kind: "watch"`)

Record `watch.urls`, `conditions` (`fix-merged`, `release-shipped`, `related-issue`, ...),
`action`, `notify`, and `retire_when`. On each run:

- **Report only on meaningful change.** Unchanged runs write `changed: false`, with no notification.
- On a claimed fix, **verify it yourself**: read the diff, build, run tests, run the end-to-end
  repro. Record the results under `verification`. Never trust "fixed" claims, release notes, or
  a closed state. If verification fails, keep the watch open and attach the failing repro.
- **Never post upstream** (comments, reviews, PRs, reactions) without the owner's explicit
  approval. Draft first.
- Retire (`status: "retired"`) only when the fix is verified **and** released, or the owner cancels.

## 7. Project-management discovery and recording

Before using an org's tracker, look for a record: repo rules, then `<org>/agent-rules`,
then the owner's ledger `pm/`. **Only if none exists**, gather clues: Projects linked to the
repo or org; Linear or Jira mentions in README, CONTRIBUTING.md, or AGENTS.md; issue templates;
integrations in workflows. Write a `pm-record` with `confirmed: false`, `evidence`, and
`last_verified`. `contact` is a handle, **never an email**. For a subscribing org, propose it as a
PR to `<org>/agent-rules`. For a guest org, put it in the owner's ledger. Then create a TickTick
task (skill `human-task-list`) asking the owner to confirm or correct it, and store its link in
`task_url`. Until confirmed, use the fallback: GitHub Projects plus issue comments in the ledger.

## 8. One-time bootstrap (missed opportunities)

Run this **once** per owner, and again only for a newly onboarded harness or org, over
history not yet covered.

1. Read `bootstrap/*.json5`. If your scope is `complete`, only cover history after
   `covered_until` for sources not yet listed.
2. Write `bootstrap/<scope>.json5` with `status: "in-progress"`.
3. Read the sources available to you: transcripts, repo history, issues, tasks, memory,
   changelogs, TODO comments. Look for recurring asks, blockers, workarounds, and
   "check back later" items with no routine or watch.
4. Register clear cases (sections 1 and 6). List unclear ones in `proposed` and send them to the owner.
5. Set `status: "complete"`, `covered_until`, `completed_at`, and the `sources` you covered.

## 9. Manual procedure (until `routine-timer` exists)

1. Clone or pull `<owner>/routine-ledger` into a worktree. Never force-push.
2. Add or edit JSON5 files and validate them with `validate.mjs`.
3. Create the run issue: `gh issue create -R <owner>/routine-ledger -t "run: <id> <run-id>" -l routine-run`,
   then `gh issue lock`.
4. Post protocol comments with `gh issue comment -R ... --body-file <file>` (UTF-8, LF).
5. Re-read comments (`gh api repos/<owner>/routine-ledger/issues/<n>/comments`) to apply the winner rule.
6. Commit the run file with `git commit -F`, then push (or open a PR if you cannot push).
7. Set up native timers only with the owner's approval for that machine. Until then, the
   session-start check (section 3) is the safety net.

## Tests

`powershell -NoProfile -File skills/routine-ledger/test.ps1` (also pwsh). It checks this
frontmatter, UTF-8/LF/no-BOM, validates every example, and confirms negative cases are rejected.
It needs Node 18+ and runs `npm install` in this folder the first time.
