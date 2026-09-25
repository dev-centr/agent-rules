---
name: git-worktrees
description: >-
  Use when creating or placing a git worktree, git worktree add, .worktrees path,
  migrate worktrees, move a worktree, linked worktree under owner, CODE_ROOT
  .worktrees, forbid $CODE_ROOT/.worktrees or $CODE_ROOT/worktrees, repo-purpose-slug
  worktree naming, agent/<purpose> branch checkout path, or parallel checkout layout.
---

# Git worktrees (hive placement)

Enforce org-scoped linked worktrees from `general/folder-schema.md`. **Path policy first**; branch names are secondary.

## Path

`$CODE_ROOT/<host>/<owner>/.worktrees/<repo>-<purpose-slug>`

| Piece | Rule |
| --- | --- |
| Owner scope | Same `<owner>` as the main clone (org or user folder under `<host>/`) |
| Directory | Hidden **`.worktrees`** (not `worktrees`) |
| Leaf name | `<repo>-<purpose-slug>` — kebab-case purpose |
| Branch (common) | `agent/<purpose>` — optional convention, not a path substitute |

## Not this skill

| Job | Use |
| --- | --- |
| Clone / fork / `.clones` placement, dedupe | `hive-layout` |
| Scheduled fetch / ahead-behind | `hive-watch` |
| Skills/rules install drift | `sync-agent-rules` |

## Add a worktree

1. Resolve the **main clone** path (owned / `.forks` / `.clones` per `hive-layout`).
2. Build the destination: `$CODE_ROOT/<host>/<owner>/.worktrees/<repo>-<purpose-slug>`.
3. Ensure the `.worktrees` directory exists under that owner.
4. Linked add only:

```bash
git -C <main-clone> worktree add <path> [-b <branch>] <start-point>
```

Example:

```bash
git -C "$CODE_ROOT/github.com/dev-centr/agent-rules" worktree add \
  "$CODE_ROOT/github.com/dev-centr/.worktrees/agent-rules-docs-pass" \
  -b agent/docs-pass main
```

## Forbidden (new worktrees)

- Full-clone into `.worktrees` (`git clone …/.worktrees/...`)
- `$CODE_ROOT/.worktrees/<…>`
- `$CODE_ROOT/worktrees/<…>`
- Non-hidden `…/<owner>/worktrees/<…>` when creating new ones (prefer `.worktrees`)

## Move / migrate an existing worktree

1. Prefer `git -C <main-clone> worktree move <old> <new>` when Git supports it and both paths are on the same volume.
2. Else: `git worktree remove` / manual relocate only with a clear plan — do not leave detached `.git` files pointing at dead paths.
3. After move, `git worktree list` from the main clone; fix `gitdir` / prune stale entries if needed.
4. Do **not** delete unique commits or dirty state to force a move — stop and report.

## Anti-patterns

- Global hive-root worktree buckets (`$CODE_ROOT/.worktrees`, `$CODE_ROOT/worktrees`)
- Treating a second full clone as a "worktree"
- Putting worktrees under the repo directory itself when an owner-scoped `.worktrees` slot exists
- Naming the leaf with only the purpose (omit `<repo>-` prefix) or only the repo name

## Related

- `general/folder-schema.md` (schema)
- Skill `hive-layout` (main clone / fork / `.clones` paths)
