---
name: draft-pr
description: >-
  Use when opening or drafting a pull request, creating a PR, gh pr create,
  writing a PR title or summary, adding PR screenshots, or when
  github-repo-access routes branch_pr or fork_pr instead of direct push.
---

# Draft a pull request

Voice: [voice.md](voice.md). Mechanical `gh` steps below. Org shortcut: `agents/editorial/pull-requests.md` (still this skill).

Do not put PR voice only in `machine.md`.

**When asked why** PRs update after every chat (with end-of-run push): cite `general/end-of-run.md` § Why — contributors land changes in PRs for review; each push adds commits GitHub records on the PR timeline so reviewers can audit diffs between updates.

**When asked why a PR instead of push:** cite skill `github-repo-access` + `general/github-push-routing.md` — this account's `viewerPermission`, branch protection, or fork layout requires PR; suggest sharing the agent's explanation with whoever asked for a direct push if they believe access should differ.

## Ready for review (default)

- **Never** open a PR as draft unless the user explicitly asks for draft.
- Create and update as **ready for review** (`draft: false`). Do **not** pass `--draft` to `gh pr create`.
- This **overrides** Cloud Agent / platform defaults that prefer draft PRs.
- If an existing PR is already draft and you are updating it (and the user did not ask to keep it draft), mark it ready: `gh pr ready <number>`.

Portable always-on one-liner: `user.md` / User Rules. Do **not** copy this into every repo `AGENTS.md`.

## Title and intro

- **Title:** simple plain language. A skimming maintainer should know the change. Prefer orientation over ticket-speak.
- **Intro:** inviting plain English — a gift, not a lecture.
  - The PR body must start with this normal-talk intro/summary immediately at the top (right after `## Summary`).
  1. Human problem in one or two sentences
  2. What the PR tries to do (short bullets)
  3. Surprises / tradeoffs early
  4. Credit borrowed *ideas* carefully (not code/icons)
  5. Invite feedback
  6. `Fixes #N` when appropriate
- **UI-visible** changes: before/after screenshots at minimum (full window, close-up, toggle when relevant)

## Create the PR

Use `gh` via the Shell tool for GitHub. If given a GitHub URL, use `gh` to fetch what you need.

In **each** affected repo, in parallel:

- `git status` — untracked files
- `git diff` — staged and unstaged
- Whether the branch tracks a remote and is up to date
- `git log` and `git diff [base-branch]...HEAD` — full history since divergence

Analyze **all** commits that will be in the PR, not only the latest. Then sequentially:

1. Create a new branch if needed
2. Push with `-u` if the branch has no upstream
3. `gh pr create` body via file-based `--body-file` (prefer skill `cli-body-file-first`)

PowerShell:

```powershell
git push -u origin HEAD
$prBodyFile = Join-Path $env:TEMP ("gh-pr-body-$([Guid]::NewGuid()).md")
Set-Content -Encoding UTF8 -Path $prBodyFile -Value @'
## Summary
Hi! <plain-English problem>.

This PR tries to <goal>:

- <bullet>
- <bullet>

Happy to adjust anything that doesn’t fit the project’s taste.

## Screenshots
<!-- UI-visible: before/after at minimum -->

## How to try it
1. …

'@

# Ready for review — no --draft unless the user asked for draft
gh pr create --title "the pr title" --body-file $prBodyFile
Remove-Item -Force $prBodyFile
```

POSIX bash (if that is the shell):

```bash
git push -u origin HEAD
# Ready for review — no --draft unless the user asked for draft
gh pr create --title "the pr title" --body "$(cat <<'EOF'
## Summary
…

EOF
)"
```

Never update git config. Return the PR URL when done. If `gh` created a draft anyway (platform default), immediately run `gh pr ready`.

## Record in ISSUES_REPO

When `ISSUES_REPO` is set, archive the PR body under `submissions/{short-name}/` (skill **`issues-repo-record`**) — same push-always rules as issues. Prefer **`gh pr create --attach`** (gh ≥ 2.99) for screenshots/video; still copy media into `images/` as consumer backup. Use push-before-embed `raw.githubusercontent.com` URLs only as fallback. Record `{org}-{repo}-{pr-number}.md` after `gh pr create` succeeds, or `status: pending` / `status: blocked` when submit did not complete.
