---
name: issues-repo-record
description: >-
  Use when recording an issue or PR submission to ISSUES_REPO or .issues,
  submissions/, images/ for gh bodies, push .issues, commit issue submission,
  pr-body.md, unfiled issue, embed screenshot in issue body, raw.githubusercontent.com
  image URL, or after gh issue create / gh pr create when ISSUES_REPO is set.
---

# Record issue and PR submissions (.issues)

**When** to file is always-on policy (`AGENTS.md`, `.cursor/rules/issue-reports.mdc`) and skill `issue-reports`. **This skill** is the git + layout lifecycle for `ISSUES_REPO`.

## Contract

Recording in `ISSUES_REPO` **is submitting**. By the time the agent writes into `submissions/`, the user has asked to file — not to leave a local draft.

Every record step ends with **commit and push** to `origin` (usually `main`). This overrides skill `git-commit` / `push-code` “only when asked” for `ISSUES_REPO` only.

Do **not** leave submission files uncommitted or unpushed.

Resolve `ISSUES_REPO` from the machine profile (`profiles/<machine>.md`) or `$ISSUES_REPO` in constants (e.g. `$CODE_ROOT/github.com/<GITHUB_USER>/.issues`). Follow that repo’s README; house layout:

```text
ISSUES_REPO/
  submissions/{issue-short-name}/   # lowercase slug
    issue.md                        # shared base body (no title line)
    screenshots/                    # working copies (optional)
    {org}-{repo}-{issue-number}.md  # per-forge copy after submit
    pr-body.md                      # optional PR body archive
    {org}-{repo}-{pr-number}.md     # optional per-forge PR copy
  images/{issue-short-name}/        # embeddable assets (raw GitHub URLs)
```

Never commit `archives/`, `*.sqlite`, or `monitor.sdl`.

## Images before embed

GitHub CLI cannot upload images. Bodies use `raw.githubusercontent.com/.../images/...` URLs.

When screenshots are needed:

1. Copy files to `images/{issue-short-name}/` with descriptive names.
2. **Commit and push** that `images/` tree **before** referencing URLs in `issue.md`, forge bodies, or PR text.
3. Build URLs from the pushed path on `main`:

   `https://raw.githubusercontent.com/{owner}/{repo}/main/images/{issue-short-name}/{filename}`

4. Only then run `gh issue create`, `gh pr create`, or post comments that embed those images.

If you add or replace images later, push again before updating forge bodies that reference them.

## Workflow

### 1. Draft base body

In `ISSUES_REPO`:

1. Create `submissions/{short-name}/`.
2. Write `issue.md` — **no title** in the body (title goes to `gh --title` and front matter only).

For PRs, also write `pr-body.md` (or skip `issue.md` when the submission is PR-only).

### 2. Images (if any)

Push `images/{short-name}/` as above. Confirm URLs resolve before forge submit.

### 3. Forge submit

Pass body files into `gh` / `glab` so the shell does not expand `$variables`:

```powershell
gh issue create --repo OWNER/REPO --title "…" --body-file "Z:\path\to\ISSUES_REPO\submissions\{short-name}\issue.md"
```

PRs: skill `draft-pr` for voice and `gh pr create`; return here to record.

### 4. Record outcome

Add or update the per-forge file under `submissions/{short-name}/`.

#### Submitted (success)

`{org}-{repo}-{issue-number}.md` or `{org}-{repo}-{pr-number}.md`:

```markdown
---
title: …
repository: OWNER/REPO
issue_number: 123
url: https://github.com/OWNER/REPO/issues/123
submitted: YYYY-MM-DD
status: submitted
---
```

(PRs: use `pull_number` / PR URL instead of `issue_number` when that reads clearer; keep the same shape.)

Body matches what was filed (or `pr-body.md` content).

#### Pending retry

Use when submit **failed transiently** or **cannot run yet**, and retry later is appropriate:

- Issues disabled on the target repo
- Network / rate-limit / timeout after the draft is ready
- User env not ready (e.g. `gh auth login` needed) but not a policy block

`{org}-{repo}-unfiled.md` or `{org}-{repo}-pending.md`:

```markdown
---
title: …
repository: OWNER/REPO
issue_number: unfiled
url: none
submitted: YYYY-MM-DD
status: pending
---

Normal-talk intro/summary (plain English, 1 paragraph): what happened and why it’s pending.

Retry when ready:

gh issue create --repo OWNER/REPO --title "…" --body-file submissions/{short-name}/issue.md
```

After a successful retry, add the numbered file, set `status: submitted`, and note the retry in the commit message.

#### Blocked

Use when **retry without user action is wrong**:

- Permission denied on the target repo
- Auth failure the user must fix deliberately
- Smart Mode / policy auto-reject (not a transient glitch)
- Maintainer or org policy forbids filing

```markdown
---
title: …
repository: OWNER/REPO
issue_number: unfiled
url: none
submitted: YYYY-MM-DD
status: blocked
blocked_reason: permission_denied
---

Normal-talk intro/summary (plain English) of what blocked the submission.

Then: what the user must change — not “retry later” boilerplate.
```

`blocked_reason` examples: `permission_denied`, `auth_required`, `policy_rejected`, `issues_disabled_permanent`.

Do **not** tell the user to “retry later” for blocked cases unless they explicitly fix the underlying blocker first.

### 5. Format, commit, push

In `ISSUES_REPO`:

1. Run prettier (or that repo’s formatter) on markdown under `submissions/`.
2. `git fetch` — if behind `origin/main`, pull/rebase before pushing.
3. Stage only submission + `images/` paths (never `archives/`).
4. Commit — match repo style, e.g. `Record OWNER/REPO issue #123 submission.` / `Add pending OWNER/REPO issue submission.` / `Record OWNER/REPO PR #456 submission.`
5. `git push origin main` (or the repo’s default branch).
6. Confirm clean tree and synced with remote.

PowerShell:

```powershell
Set-Location $env:ISSUES_REPO  # or profile path
git add submissions/{short-name}/ images/{short-name}/
git commit -m @"
Record OWNER/REPO issue #123 submission.

"@
git push origin main
```

## Integration

| Skill | Role |
| --- | --- |
| `issue-reports` | Draft quality, `gh issue create`, when filing is warranted |
| `draft-pr` | PR voice, push product branch, `gh pr create` |
| **This skill** | Layout, images, front matter, **always push** `ISSUES_REPO` |
| `git-commit` / `push-code` | Default “ask first” — **except** `ISSUES_REPO` record steps |

Call this skill at the end of every issue or PR filing flow when `ISSUES_REPO` is set.

## Do not

- Leave `submissions/` or `images/` only on disk
- Embed `raw.githubusercontent.com` URLs before those blobs exist on `main`
- Put secrets in bodies or screenshots
- Use `status: pending` for permission or policy blocks — use `status: blocked`
- Commit SQLite archives or issues-browser backups
