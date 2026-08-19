---
name: git-commit
description: >-
  Use when creating a git commit, writing a commit message, git commit,
  committing staged or unstaged changes, or when the user asks to commit.
---

# Git commit

Only create a commit when the user asked. If unclear, ask first.

**Exception:** skill `issues-repo-record` — recording in `ISSUES_REPO` is part of filing; commit there without a separate ask.

## Safety

- NEVER update git config
- NEVER run destructive/irreversible commands (`push --force`, hard reset, etc.) unless the user explicitly asked
- NEVER skip hooks (`--no-verify`, `--no-gpg-sign`, etc.) unless the user explicitly asked
- NEVER force-push to main/master; warn if they request it
- Avoid `git commit --amend`. Amend only when **all** of: they asked (or a hook auto-modified files from a commit you just created), HEAD was created by you this conversation (`git log -1 --format='%an %ae'`), and the commit has **not** been pushed
- If commit **failed** or was **rejected** by a hook: fix and make a **new** commit — do not amend
- If already pushed: NEVER amend unless they explicitly ask (requires force push)
- Do not commit secrets (`.env`, `credentials.json`, real keys)
- Never `git` commands with `-i` (no interactive add/rebase)
- Do not add extra exploratory commands beyond the git sequence below
- Empty tree: do not create an empty commit

## Sequence

Run in parallel:

- `git status`
- `git diff` (staged and unstaged)
- `git log` (recent messages — match this repo’s style)

Then:

1. Draft 1–2 sentences on **why**, not a file list. Match this repo’s tense/prefix style. `add` = new feature, `update` = enhancement, `fix` = bug fix.
2. Stage relevant files (not secrets).
3. Commit with a here-string (correct formatting; no interactive editors).
4. `git status` to verify.

PowerShell:

```powershell
git commit -m @"
Commit message here.

"@
```

POSIX bash:

```bash
git commit -m "$(cat <<'EOF'
Commit message here.

EOF
)"
```

Do not push unless they asked.
