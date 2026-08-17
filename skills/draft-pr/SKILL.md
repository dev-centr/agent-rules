---
name: draft-pr
description: >-
  Use when opening or drafting a pull request, creating a PR, gh pr create,
  writing a PR title or summary, or adding PR screenshots.
---

# Draft a pull request

Voice: [voice.md](voice.md). Mechanical `gh` steps below. Org shortcut: `agents/editorial/pull-requests.md` (still this skill).

Do not put PR voice only in `MEMORIES.md`.

## Title and intro

- **Title:** simple plain language. A skimming maintainer should know the change. Prefer orientation over ticket-speak.
- **Intro:** inviting plain English — a gift, not a lecture.
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
3. `gh pr create` with the body via a here-string (do not let the shell expand the summary)

PowerShell:

```powershell
git push -u origin HEAD
gh pr create --title "the pr title" --body @"
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
"@
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
