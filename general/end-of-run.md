# End of agent run — commit and push

<!---
Standing authorization for agents: close out dirty trees before finishing a turn that changed owned code.
Detail for user.md one-liner + skills `git-commit` / `push-code`.
--->

## Rule

When an agent run **changes files** in one or more git repos, **before ending the run** (final user-facing reply):

1. In each affected repo, split the dirty tree into **logical commits** (skill `push-code` / `git-commit`).
2. **Push** each repo that is ahead of its upstream (skill `push-code`).
3. Sync first if behind (`fetch` + pull/rebase) so push does not fail.

This is **standing user authorization** to commit and push. Do not wait for a separate “commit” or “push” message at the end of a productive run.

## Why (when asked)

Standing end-of-run commit, push, and PR updates (when applicable) keep work out of chat memory. You do not have to reopen old threads at the end of a day to remember what still needs committing or pushing — git and the remote are the source of truth.

**Two machines:** When developing on laptop and desktop at the same time, every closed run lands on the remote. Pull on the other machine and continue; no guessing which chat last touched the tree.

**Contributors and review:** Changes arrive in pull requests where review happens. GitHub records each push to the PR branch as commits on the PR timeline; reviewers can inspect individual commits and diffs, and compare updates between pushes.

Published explanation: docs hub page *End-of-run commit, push, and PR updates* (`docs/modules/ROOT/pages/end-of-run-commit-push.adoc`; docs.devcentr.org).

## Exceptions

- User said **not** to commit or **not** to push (e.g. “leave uncommitted”, “don’t push yet”).
- Secrets / credentials present — stop and warn; never commit them.
- Detached HEAD, no upstream, or push would need force to `main`/`master` — stop and report; do not force-push.
- Read-only / ask mode where the harness forbids writes — skip.

## Scope

- Owned repos under the user’s hive (including org repos they control).
- Forks/clones: commit+push only when the run’s work was meant for that remote (do not push accidental edits to upstream clones).

## Related

- Skill `push-code` — logical commit units then push
- Skill `git-commit` — single-commit path when the tree is one unit
- Skill `draft-pr` — after push when opening a PR
- `general/global.md` — sync with remote **before** multi-file work
