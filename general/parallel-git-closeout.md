# Parallel git close-out (deferred push)

<!---
When many workers run at once, each inherited "push at end of run" fires remote CI
and burns wait time. Commit locally on workers; one push after the wave settles.
Detail for user.md / end-of-run / push-code / DevCentr harness GIT_CLOSEOUT.
--->

## Problem

Cursor (and similar harnesses) often **copy parent always-on rules into subagents**. Standing end-of-run push then runs on **every** worker. In a high-volatility session (many parallel Task / multitask / actor nodes touching remotes), that means:

- Repeated `git push` while siblings are still editing
- Remote CI rebuild storms and long wait queues
- Racey PR branch tips across workers

Rules alone are weak if the parent **re-injects** full push authorization into each brief. Close-out must be **role-scoped** and **brief-scoped**.

## Rule

| Role | Close-out |
| --- | --- |
| **Worker** (Task tool, multitask worker, harness `task` node, parallel child) | **Commit locally** only — skill `git-commit`. **Do not push** unless push is required *now* to validate something (CI check the worker owns, Pages preview the user asked for, forge attach that needs a remote URL). |
| **Coordinator / parent** (after all workers in the wave finish) | Logical commits if still dirty, then **one push per affected repo** (skill `push-code`). Open/update PRs once. |

Standing end-of-run authorization (`general/end-of-run.md`) still applies to the **session close** — not to every parallel leaf.

## High volatility

Treat the session as **high volatility** when any of:

- Multitask / multi-subagent mode with **2+** concurrent workers that may touch git remotes
- Harness actor graph with **2+** non-terminal `task` nodes under the same coordinator wave
- The parent explicitly marks the wave as parallel / swarm

In high volatility: default workers to **commit-only**; coordinator batches push after terminal status (or after the parent collects all worker results).

## Parent briefing obligation (Cursor and peers)

When spawning a worker, the parent **must**:

1. Put an explicit close-out line in the worker prompt, e.g. `GIT_CLOSEOUT=commit-only — commit locally; do not push; parent will push after the wave.`
2. **Strategically omit** standing “push before final reply” language from the worker brief (do not paste the full end-of-run push paragraph into Task prompts).
3. Tell the worker what *does* justify an early push (only if that worker’s job needs remote validation).

Do not rely on the worker “noticing” a soft preference in a sea of always-on rules.

## DevCentr harness

Reference runtime (`dev-centr/harness`) stores `gitCloseout` on each node and injects a **system addendum** on spawn / provider session so inherited always-on push text cannot silently win.

| Value | Meaning |
| --- | --- |
| `commit-only` | Worker: commit OK; no push |
| `coordinator-batch` | Same as commit-only on the leaf; coordinator owns push after the wave |
| `per-node` | Legacy / single-agent: commit + push on that node’s close-out |
| `off` | No automatic close-out for this node |

Harness variable (optional in `$CODE_ROOT/harness.md`):

```text
GIT_CLOSEOUT = coordinator-batch | per-node | off
```

Default when `ACTOR_AGENTIC_UI=graph-grid` (or when spawning parallel `task` nodes): **`coordinator-batch`**. Single-node / serialized sessions may use `per-node`.

## Exceptions (worker may push)

- User explicitly told **that** worker to push
- Validation **requires** a remote (CI the worker is diagnosing, deploy preview URL, `issues-repo-record` raw-URL fallback, forge media that must exist on `origin`)
- Skill `issues-repo-record` on `ISSUES_REPO` (always push that repo’s record)

## Related

- `general/end-of-run.md`
- Skill `push-code` / `git-commit`
- `agents/demos-and-push.md` — still push at wave/session end; do not suppress the final push for demo prototyping
- Docs: *End-of-run commit and push*; *Actor-model agentic UI*; *Agent harness*
