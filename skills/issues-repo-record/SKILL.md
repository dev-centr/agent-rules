---
name: issues-repo-record
description: >-
  Use when recording an issue or PR submission to ISSUES_REPO or .issues,
  submissions/, images/ backup for forge filings, gh --attach media upload,
  push .issues, commit issue submission, pr-body.md, unfiled issue, embed
  screenshot in issue body, raw.githubusercontent.com fallback image URL, or
  after gh issue create / gh pr create when ISSUES_REPO is set.
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
  images/{issue-short-name}/        # durable local/media backup (always keep)
```

Never commit `archives/`, `*.sqlite`, or `monitor.sdl`.

## Media: forge upload vs consumer backup

**Two jobs, two homes:**

| Job | Where |
| --- | --- |
| What the forge shows | Native upload when available (`gh --attach` on GitHub; browser attach otherwise) |
| What *you* keep | `ISSUES_REPO/images/` (+ submission markdown) — consumer-owned backup, always |

`.issues` is **not** the preferred CDN for GitHub bodies anymore. Prefer forge-native attach; still **copy every screenshot/video into `images/`**, commit, and push so filings survive host CDN churn and remain searchable offline (pair with `issues-browser` archives).

### Prefer `gh --attach` (GitHub, gh ≥ 2.99.0)

Requires write access to the target repo. Supported on `gh issue|pr` `create` / `edit` / `comment`.

1. Copy media to `images/{issue-short-name}/` with descriptive names (backup first).
2. In `issue.md` / `pr-body.md`, either:
   - Reference the **same local path** you will pass to `--attach` (Markdown image syntax). `gh` rewrites those paths to the uploaded URL in place; or
   - Omit embeds and let `--attach` append media at the end.
3. Submit with `--body-file` **and** repeatable `--attach`:

```powershell
gh issue create --repo OWNER/REPO --title "…" `
  --body-file "$env:ISSUES_REPO\submissions\{short-name}\issue.md" `
  --attach "$env:ISSUES_REPO\images\{short-name}\error.png#The error dialog"
```

Alt text: `path#alt text` on the flag. When the body already has `![alt](path)`, body alt wins for rewritten refs.

4. After forge success, record the per-forge file, then **commit and push** `submissions/` + `images/` together (backup of text + media).

Check version when unsure: `gh --version` — need **2.99.0+**. If older, upgrade `gh` or use the fallback below.

### Fallback: `raw.githubusercontent.com` (legacy / non-attach)

Use only when `--attach` is unavailable: `gh` too old, Enterprise Server without support, no write access for attach, or a forge without an equivalent CLI upload (e.g. some `glab` paths).

1. Copy files to `images/{issue-short-name}/`.
2. **Commit and push** that `images/` tree **before** referencing URLs in forge bodies.
3. Build URLs from the pushed path on `main`:

   `https://raw.githubusercontent.com/{owner}/{repo}/main/images/{issue-short-name}/{filename}`

4. Only then run `gh issue create` / `gh pr create` / comments that embed those URLs.

If you add or replace fallback images later, push again before updating forge bodies that reference them.

## Workflow

### 1. Draft base body

In `ISSUES_REPO`:

1. Create `submissions/{short-name}/`.
2. Write `issue.md` — **no title** in the body (title goes to `gh --title` and front matter only).

For PRs, also write `pr-body.md` (or skip `issue.md` when the submission is PR-only).

### 2. Media (if any)

Copy into `images/{short-name}/`. Prefer `--attach` (above). Fallback push-before-embed only when using raw GitHub URLs.

### 3. Forge submit

Pass body files into `gh` / `glab` so the shell does not expand `$variables`:

```powershell
gh issue create --repo OWNER/REPO --title "…" `
  --body-file "$env:ISSUES_REPO\submissions\{short-name}\issue.md" `
  --attach "$env:ISSUES_REPO\images\{short-name}\shot.png"
```

Omit `--attach` when there is no media or when using the raw-URL fallback body.

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
media: attach   # or: raw_github | none
---
```

(PRs: use `pull_number` / PR URL instead of `issue_number` when that reads clearer; keep the same shape.)

Body matches what was filed (or `pr-body.md` content). Optional `media:` helps future audits know whether the forge copy used `--attach` or the CDN fallback.

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
| `draft-pr` | PR voice, push product branch, `gh pr create` (+ `--attach` when media) |
| **This skill** | Layout, media backup, front matter, **always push** `ISSUES_REPO` |
| `git-commit` / `push-code` | Default “ask first” — **except** `ISSUES_REPO` record steps |
| `issues-browser` (tool) | Opt-in forge metadata/body archives under `archives/` — complementary offline search |

Call this skill at the end of every issue or PR filing flow when `ISSUES_REPO` is set.

Architectural north star (provider search APIs + API-compatible consumer mirrors): general-knowledge *Provider search and mirror backups*; near-term wedge is this repo + `issues-browser`.

## Do not

- Leave `submissions/` or `images/` only on disk
- Skip copying media into `images/` because `--attach` uploaded to the forge — backup is still required
- Embed `raw.githubusercontent.com` URLs before those blobs exist on `main` (fallback path only)
- Prefer the raw-URL hack when `gh --attach` is available
- Put secrets in bodies or screenshots
- Use `status: pending` for permission or policy blocks — use `status: blocked`
- Commit SQLite archives or issues-browser backups
