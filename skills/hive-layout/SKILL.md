---
name: hive-layout
description: >-
  Use when hive layout, folder-schema, CODE_ROOT clone path, .forks placement,
  reconcile duplicate repos, misplaced fork at org root, bulk org sync clones,
  dedupe git repos by origin URL, move fork to .forks, isFork gh api,
  .clones vs owned vs fork path, or auditing hive directory structure.
---

# Hive layout (clone paths + dedupe)

Enforce `general/folder-schema.md` on `$CODE_ROOT`. **Forks live in `.forks/`** — personal account **and** org account. Org membership does not override fork placement.

## Not this skill

| Job | Use |
| --- | --- |
| Scheduled fetch, ahead/behind stamp | `hive-watch` |
| Skills/rules install drift | `sync-agent-rules` |
| Bootstrap new org identity | `bootstrap-org` |

## Path rules (short)

| GitHub | Path |
| --- | --- |
| `fork: true` under owner | `$CODE_ROOT/<host>/<owner>/.forks/<repo>` |
| `fork: false`, owned by owner | `$CODE_ROOT/<host>/<owner>/<repo>` |
| Upstream, not owned/forked | `$CODE_ROOT/<host>/.clones/<owner>/<repo>` |

Verify with `gh api repos/<owner>/<repo> --jq '{fork:.fork,parent:.parent.full_name}'`.

## Clone missing repos

1. Resolve `$CODE_ROOT` from profile / `$env:code`.
2. For each target repo, run `gh api` fork check above.
3. Clone to the path from the table — **never** default forks to `<owner>/<repo>`.

## Reconcile duplicates (same normalized origin URL)

1. Build a map: walk `$CODE_ROOT/github.com/<org>/`, each `/.forks/`, and `/.clones/` (git repos only).
2. Normalize URLs: strip `.git`, `git@github.com:` → `https://github.com/`, `devcntr-app` → `dev-centr`.
3. For each URL with multiple paths:
   - If `fork: true` → **keep** `$CODE_ROOT/.../<owner>/.forks/<repo>`.
   - If `fork: false` → **keep** `$CODE_ROOT/.../<owner>/<repo>`.
   - Remove or move the other copy only when HEAD matches or the keeper is strictly ahead; **stop** if the loser has unique commits or meaningful dirty state.
4. Prefer **move** (`Move-Item` / `git` safe rename) over delete when the keeper slot is empty.
5. Report skips (diverged HEAD, dirty worktrees, multi-branch worktrees like `dub-registry-*`).

## Anti-patterns

- Assuming org repos belong at org root without checking `fork`.
- Deleting `.forks/` copies when a sync also created org-root dupes.
- Treating `.clones/` upstream mirrors as duplicates of org forks (different remotes = OK).

## Related

- `general/folder-schema.md`
- `general/environment.md`
- Skill `hive-watch`
