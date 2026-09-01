# GitHub push routing (permissions)

<!---
Portable policy: direct push vs branch+PR vs fork PR vs blocked.
Discovery + cache: skill `github-repo-access`; machine cache in `$CODE_ROOT/machine.md`.
--->

## Rule

Before **push** (including end-of-run), the agent probes **this user's effective access** on the target repo and follows the route — even when a teammate said **"just push"**.

Load skill **`github-repo-access`** when push or PR is in scope.

## Why (when asked)

GitHub permissions are per **account**, not per chat instruction. A senior developer with **write** or **admin** on a repo can push directly; a **member** with **read** or a **protected default branch** cannot — the agent routes to a **PR** (or fork PR) so work still lands on the remote without pretending access exists.

Cached facts live in **`$CODE_ROOT/machine.md`** (`<!-- github-access:begin -->` block) so the agent does not re-probe every message.

## Routes

| Route | When | Agent behavior |
| --- | --- | --- |
| `direct_push` | Write+ on unprotected default, or write on current branch policy | `git push` as today |
| `branch_pr` | Write+ but default branch protected | Push feature branch; `draft-pr` |
| `fork_pr` | Read/triage on upstream; local clone is a fork | Push fork; PR to parent |
| `blocked` | No write on upstream; not a fork | Commit locally if asked; explain; no push |

## "Just push" but blocked

When the user repeats **push** after a permission block:

1. Repeat the **access fact** (permission level, protection, fork).
2. Say what you **will** do (open PR, push fork branch).
3. Suggest they **share this text or a screenshot** with whoever told them to push — often missing **write** role, wrong remote, or branch protection — not something to override in the agent.

Do not treat standing end-of-run authorization (`general/end-of-run.md`) as permission to bypass GitHub.

## Exceptions

- User explicitly said **not** to push — always honor.
- Secrets in tree — never push (`push-code` safety).
- `gh` not installed or not authenticated — stop and report; do not guess permissions.

## Related

- Skill `github-repo-access`
- Skill `push-code` — probes before step 4 push
- Skill `draft-pr` — when route is `branch_pr` or `fork_pr`
- `general/end-of-run.md` — permission-aware end-of-run
- `machine.example.md` — cache block template
