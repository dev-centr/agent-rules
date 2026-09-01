---
name: github-repo-access
description: >-
  Use when discovering GitHub repo permissions, viewerPermission, collaborator
  role, org member vs write access, can't push, just push but no permission,
  branch protection blocks push, push vs PR routing, github role discovery,
  record github access to machine.md, or explaining why the agent opens a PR
  instead of pushing to main.
---

# GitHub repo access (discover + record + route)

Discover **this user's** GitHub identity and **effective repo access**, record it in **`$CODE_ROOT/machine.md`**, and route **direct push** vs **branch + PR** vs **fork PR** vs **blocked**.

Policy detail: `general/github-push-routing.md`.

## When to run

- Before **push** or **end-of-run push** in a repo (skill `push-code` calls this)
- Before **PR** when upstream write is missing (skill `draft-pr` pairs with this)
- User asks **"just push"** but access may not allow it
- First push/PR in a repo this session and cache is stale (>24h) or missing
- Harness setup on a new machine (optional identity probe)

## Step 1 — Auth + identity

```powershell
gh auth status
gh api user --jq '{login:.login}'
```

If not authenticated: stop, explain `gh auth login`, record nothing.

Resolve `GITHUB_USER` from `gh api user` (prefer over profile constant when they differ).

## Step 2 — Repo context

From the git remote of the repo being pushed:

```powershell
gh repo view --json nameWithOwner,isFork,parent,viewerPermission,defaultBranchRef `
  --jq '{repo:.nameWithOwner,fork:.isFork,parent:.parent.nameWithOwner,perm:.viewerPermission,default:.defaultBranchRef.name}'
```

If `gh repo view` fails (wrong remote, no access): treat as **blocked** with reason `auth_required` or `permission_denied`.

Optional branch protection (best-effort):

```powershell
$repo = "<owner>/<repo>"
$branch = "<default-branch>"
gh api "repos/$repo/branches/$branch/protection" 2>$null
```

If the API returns protection rules, set `default_branch_protected: true`. If 404, `false`.

## Step 3 — Routing decision

Use `viewerPermission` + fork + protection:

| Condition | Route | Agent action |
| --- | --- | --- |
| `ADMIN` / `MAINTAIN` / `WRITE`, not fork, default branch **not** protected | `direct_push` | Push current branch (incl. end-of-run) |
| `WRITE` (or above), default branch **protected** | `branch_pr` | Push **feature branch** only; open/update PR (`draft-pr`) — never push to protected default |
| `READ` / `TRIAGE` / missing perm, repo **is fork** | `fork_pr` | Push to **fork** remote; PR to parent |
| `READ` / `TRIAGE` / missing perm, **not** fork | `blocked` | Commit locally if asked; **do not push**; explain + offer fork/PR path or maintainer grant |
| User says **"just push"** but route ≠ `direct_push` | (same as row) | **Refuse direct push**; explain in plain language (see § Explain) |

Org **Member** role alone does not imply write — trust `viewerPermission` on the repo.

## Step 4 — Record in `$CODE_ROOT/machine.md`

Append or refresh the delimited block (do not commit this file):

```markdown
<!-- github-access:begin -->
Last checked: 2026-09-01T12:00:00-05:00
Identity: amdphreak (counter: 1)

| Repo | Perm | Fork | Default | Protected | Route | Checked |
| --- | --- | --- | --- | --- | --- | --- |
| dev-centr/agent-rules | WRITE | false | main | true | branch_pr | 2026-09-01 |
<!-- github-access:end -->
```

Rules:

- Update the row for `owner/repo` when re-probed; bump `(counter: N)` on identity line when reused.
- Never store tokens or secret env values.
- If probe failed, add a row with `Route: blocked` and `Notes: <reason>`.

Pattern copied from hive-watch stamp in `machine.example.md`.

## Step 5 — Return to caller

Return JSON-shaped summary for push/PR skills:

```text
route: branch_pr | direct_push | fork_pr | blocked
repo: owner/name
permission: WRITE
reason: default branch protected
user_message: <one sentence for the user if route blocks "just push">
```

## Explain (jr dev vs sr dev instruction)

When someone told the user **"just push"** but route is not `direct_push`:

1. State **what GitHub reports** for this account on this repo (`viewerPermission`, protection, fork).
2. State **what the agent will do instead** (PR, push to fork, etc.) and **why** — not org politics, just access facts.
3. If the user believes they should have access, ask them to **screenshot or paste** the agent's explanation (or `gh repo view --json viewerPermission`) and share with the person who said "just push" — often a **policy or role** fix, not an agent override.
4. Do **not** force-push, bypass protection, or push to upstream without write.

Standing end-of-run push (`general/end-of-run.md`) **defers** to this skill when route ≠ `direct_push` — use PR path instead of failing silently.

## Related

- `general/github-push-routing.md` — portable policy
- `general/end-of-run.md` — exceptions
- Skills `push-code`, `draft-pr`, `record-rule`
- `hive-layout` — fork detection (complements, does not replace permission probe)
