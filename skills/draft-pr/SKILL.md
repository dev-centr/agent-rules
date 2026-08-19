---
name: draft-pr
description: >-
  Use when opening or drafting a pull request, creating a PR, gh pr create,
  writing a PR title or summary, or adding PR screenshots.
---

# Draft a pull request

Voice: [voice.md](voice.md). Mechanical `gh` steps below. Org shortcut: `agents/editorial/pull-requests.md` (still this skill).

Do not put PR voice only in `machine.md`.

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

gh pr create --title "the pr title" --body-file $prBodyFile
Remove-Item -Force $prBodyFile
```

POSIX bash (if that is the shell):

```bash
git push -u origin HEAD
gh pr create --title "the pr title" --body "$(cat <<'EOF'
## Summary
…

EOF
)"
```

Never update git config. Return the PR URL when done.

## Record in ISSUES_REPO

When `ISSUES_REPO` is set, archive the PR body under `submissions/{short-name}/` (skill **`issues-repo-record`**) — same push-always rules as issues. Push any `images/` URLs before they appear in the PR body. Record `{org}-{repo}-{pr-number}.md` after `gh pr create` succeeds, or `status: pending` / `status: blocked` when submit did not complete.
