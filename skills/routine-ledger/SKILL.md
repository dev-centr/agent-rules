---
name: routine-ledger
description: >-
  Use when a task is recurring, scheduled, event-driven, or blocked on upstream;
  remind me, every day/week, check back, watch this issue/PR/release, when X ships,
  monitor, cron, Task Scheduler, missed run, routine, trigger, repository_dispatch,
  routine-ledger, routine-timer, claim/lease/heartbeat, harness target, dependency watch,
  wait for the harness, spun up, launch wait, agent-bus submit.
---

# Routine ledger

Design: [routine-ledger.adoc](../../docs/modules/agent-rules/pages/design/routine-ledger.adoc).
Schemas: [`schemas/routine-ledger/`](../../schemas/routine-ledger/).
Command: `dev-centr/routine-timer` (`routine-timer`). It submits due work with `agent-bus`. It does not start a desktop harness unless the target says so.

## 1. Register, do not just act once

- If a request is recurring, scheduled, or "when X happens", register a routine in the ledger in addition to doing the first run.
- A one-conversation prerequisite stays on `plan-stack.kdl` (skill `plan-stack`). It is not a routine.
- If work is blocked by an upstream bug, PR, or release, register a dependency watch without being asked (section 6).
- Set `requires` to capabilities, not a harness name. `preferred_targets` is a hint only.
- Tell the owner the routine id and the file path. Registering is allowed. Posting outside the ledger is not.

## 2. Where the ledger lives

| Scope | Location |
| --- | --- |
| Owner or team ledger | `<owner>/routine-ledger` |
| Org project-management record | `<org>/agent-rules`, layered on `dev-centr/agent-rules` |
| Guest repo | Owner's ledger `pm/<org>.json5`, `confirmed: false`. Never write into their repos. |

Layout: `routines/<id>.json5`, `runs/<yyyy>/<mm>/<routine-id>/<run-id>.json5`, `targets/<harness-id>.json5`, `machines/<machine-id>.json5`, `pm/<scope>.json5`, `bootstrap/<scope>.json5`, `archive/<yyyy>/<routine-id>.json5`.

Validate with `node skills/routine-ledger/validate.mjs <schema> <file>` or with `routine-timer targets validate --ledger <dir>`.

## 3. Timer

`routine-timer` has to be able to call `agent-bus` (`AGENT_BUS_BIN`, `AGENT_BUS_PROFILES`, or `--agent-bus` and `--profiles`).

- `status` reports whether this host and each named harness process are up. It does not submit.
- `serve` repeats that check. The first time the host or a harness process comes up, it prints `spun-up`.
- A due routine is submitted only when the target's process is already running. The line is `submit ... via=agent-bus`.
- Default `launch` is `wait`. The timer does not open Cursor, Grok, or any other program.
- `launch: "launch"` is opt-in and requires `launch_program`. The process image is for detection only. The timer does not reuse it as the program to start.
- A target whose `machines` list is another computer is reported and left to that computer.
- `plan` prints the logon task and the refresh task. `apply --install` registers them. The daemon task is `ONLOGON`, not at boot.
- `fire <routine>` runs the same decision once.

Session start on a harness with no built-in timer: `routine-timer serve --once --ledger <dir>`. Claim only what this session can finish.

## 4. Target shape

```json5
{
  schema: "routine-ledger/target/1",
  id: "cursor-desktop",
  kind: "agent_bus",
  capabilities: ["shell", "gh", "windows"],
  app: "cursor",
  version: "3.29.15",
  operation: "prompt-existing-desktop-chat",
  chat_id: "<composer id>",
  launch: "wait",
  presence: { process: "Cursor.exe" },
  machines: ["local"],
}
```

`presence.assume: "running"` is the explicit opt-in for a harness with no local process. It is not the default.

## 5. Claim protocol

One run issue per run, titled `run: <routine-id> <run-id>`, label `routine-run`, locked to collaborators. Each protocol comment is one fenced json5 block (`claim-comment`).

The earliest valid claim wins. A claim is valid when the author is trusted, the JSON5 validates, and `capabilities` cover `requires`. A later claim backs off while that lease is live. `start` is the lock. `heartbeat` extends it. After `lease_expires` with no heartbeat, the lock is void.

Record the real session id. Times are UTC. Post with the harness bot, not the owner's account. Do not @-mention the owner unless a human decision is needed.

## 6. Dependency watches (`kind: "watch"`)

Record `watch.urls`, `conditions`, `action`, `notify`, and `retire_when`. Report only on a meaningful change. On a claimed fix, verify it: read the diff, build, run tests, run the repro. Never post upstream without the owner's approval. Retire only when the fix is verified and released, or the owner cancels.

## 7. Project-management discovery

Look for a record in repo rules, then `<org>/agent-rules`, then the owner's ledger `pm/`. Only if none exists, gather clues and write a `pm-record` with `confirmed: false`. `contact` is a handle, never an email. Until a human confirms it, use GitHub Projects plus ledger issue comments.

## 8. One-time bootstrap

Once per owner, and again only for a newly onboarded harness or org. Read `bootstrap/*.json5`. If that scope is `complete`, cover only history after `covered_until`. Register clear watches. List unclear ones for the owner.

## Tests

`powershell -NoProfile -File skills/routine-ledger/test.ps1` checks this frontmatter, UTF-8/LF, and the schemas. The command's own checks are `dub test --compiler=ldc2` in `dev-centr/routine-timer`.
