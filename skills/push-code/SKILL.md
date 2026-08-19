---
name: push-code
description: >-
  Use when pushing code, git push, push changes, push to remote, push my
  commits, on pushing code, or when the user asks to push.
---

# Push code

Only push when the user asked. If they only asked to commit, use skill `git-commit` and stop before push.

## Safety

Same as skill `git-commit`, plus:

- NEVER force-push to `main`/`master`; warn if they request it
- NEVER push secrets (`.env`, credentials, real keys)
- NEVER update git config
- NEVER skip hooks unless the user explicitly asked
- Do not push if the branch is behind its upstream without pull/rebase first (unless they explicitly want force — then warn)
- Never `git` commands with `-i`

## Goal

Before push, the working tree should be **zero dirty files**, split into **logical commits** — one coherent change per commit, easy to review and revert.

## Sequence

### 1. Survey (parallel)

- `git status`
- `git diff` (staged and unstaged)
- `git log` (recent messages — match this repo’s style)
- `git status -sb` (ahead/behind upstream)

If there is nothing to commit and the branch is ahead: skip to push (step 4).

### 2. Plan logical commits

Read the full diff. Partition changes into **units** — each unit becomes one commit.

**Good boundaries:**

- One feature, fix, or refactor per commit
- Changelog/docs-only when they stand alone from the code change
- Backend vs frontend only when they are independently shippable
- Generated artifacts with the script/source that produces them
- Config/env **names** with the code that uses them (never secret values)

**Avoid:**

- “WIP” grab-bags mixing unrelated files
- Half a feature split across commits with broken intermediate states (reorder or combine so each commit builds)
- Committing secrets

**Order:** foundational first (schema, shared types, then callers; lib changes before app wiring).

Briefly tell the user the planned commit list (titles only) before staging. If the tree is trivial (one obvious unit), skip the narration.

### 3. Commit each unit

For **each** planned unit, in order:

1. Stage only that unit’s files (`git add` paths — not `-A` unless the whole tree is one unit).
2. Re-check `git diff --staged` matches the intended unit.
3. Commit with a 1–2 sentence message on **why**, matching repo style (`add` / `update` / `fix`). Use a here-string (PowerShell `@""@`, bash `<<'EOF'`).
4. `git status` — confirm remaining changes match the next unit.

Follow skill `git-commit` for message quality and hook failure handling (new commit after hook reject; do not amend pushed commits).

Do not push until all units are committed and the working tree is clean.

### 4. Push

1. `git fetch` and `git status -sb` — if **behind** upstream, pull/rebase (or ask) before pushing.
2. Push. Set upstream when missing:

```powershell
git push -u origin HEAD
```

3. `git status -sb` — confirm clean and synced.

Return the remote branch state (ahead/behind gone, push succeeded).

## When commits already exist

If everything is already committed and only push was requested: run step 1 survey + step 4 push. Do not rewrite history or add empty commits.

## Related skills

- Single commit, no push → `git-commit`
- Push then open PR → this skill, then `draft-pr`
