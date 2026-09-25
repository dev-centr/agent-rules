# Repository organization schema

Clone repositories into the following path pattern (set `CODE_ROOT` in your `profiles/*.md` file).

## Decision order (fork first)

**Do not place a fork at org/user root just because the owner is an org you belong to.**

1. **Pure upstream clone** (not owned, not forked under your account/org) → `$CODE_ROOT/<host>/.clones/<owner>/<repo>`
2. **Fork** (GitHub `fork: true` on your personal account **or** any org you belong to) → `$CODE_ROOT/<host>/<owner>/.forks/<repo>`
3. **Owned, not a fork** (you or your org created it; no upstream parent on GitHub) → `$CODE_ROOT/<host>/<owner>/<repo>`

Examples:

- Owned: `$CODE_ROOT/github.com/dev-centr/agent-rules`
- Org fork: `$CODE_ROOT/github.com/dev-centr/.forks/dprint` (parent `dprint/dprint`)
- Personal fork: `$CODE_ROOT/github.com/<you>/.forks/obs-studio`
- Upstream clone: `$CODE_ROOT/github.com/.clones/obsproject/obs-studio`

## Fork vs owned — verify on GitHub

Membership in an org is **not** enough. Ask GitHub whether the repo is a fork:

```bash
gh api repos/<owner>/<repo> --jq '{fork:.fork, parent:.parent.full_name}'
```

- `fork: true` → **`.forks/<repo>`** under that owner (personal or org).
- `fork: false` → **`<owner>/<repo>`** at hive root for that owner.

Normalize stale remotes when comparing paths (`devcntr-app/*` → `dev-centr/*`, `git@` → `https://`).

## Duplicate detection and reconciliation

When the same remote URL appears in more than one path:

| Situation | Keep | Remove / move |
| --- | --- | --- |
| Fork at org root **and** under `.forks/` | `.forks/<repo>` | Org-root copy (usually a bad bulk sync) |
| Owned at root **and** duplicate elsewhere | `<owner>/<repo>` | Extra copy |
| Upstream in `.clones/` **and** fork copy | Both may be valid if remotes differ (fork vs upstream) | Only remove when **same normalized URL** |
| Same URL, diverged HEAD | Pause — merge or ask | Do not delete the copy with unique commits |

**Never** treat “org root wins” as a shortcut. **Forks belong in `.forks/`** for personal and org accounts alike.

Skill **`hive-layout`** — clone missing repos, audit misplaced forks, reconcile duplicates. Distinct from **`hive-watch`** (fetch/status only), **`sync-agent-rules`** (skills/rules install), and **`git-worktrees`** (linked worktree paths under `.worktrees/`).

## Git worktrees (linked checkouts)

Parallel checkouts for agent or branch work live under the **owner**, next to that owner's repos — not at `$CODE_ROOT` root:

`$CODE_ROOT/<host>/<owner>/.worktrees/<repo>-<purpose-slug>`

Examples:

- `$CODE_ROOT/github.com/dev-centr/.worktrees/agent-rules-docs-pass`
- `$CODE_ROOT/github.com/dev-centr/.worktrees/hive-watch-tray-fix`

### Rules

1. **Linked worktrees only** — create from the main clone:
   `git -C <main-clone> worktree add <path> [-b <branch>] <start-point>`
2. **Never** full-clone into `.worktrees` (no `git clone` that creates a second independent `.git` there).
3. Prefer the **hidden** directory name **`.worktrees`** (not `worktrees`).
4. **Forbid** for new worktrees:
   - `$CODE_ROOT/.worktrees/...`
   - `$CODE_ROOT/worktrees/...`
5. **Naming:** `<repo>-<purpose-slug>` — kebab-case purpose slug after the repo name.
6. Branches often `agent/<purpose>`; **path policy is the main thing** (branch naming is secondary).

| Kind | Path |
| --- | --- |
| Linked worktree (preferred) | `$CODE_ROOT/<host>/<owner>/.worktrees/<repo>-<purpose-slug>` |
| Main clone (owned / fork / upstream) | unchanged — see decision order above |
| Global hive root `.worktrees` / `worktrees` | **forbidden** for new worktrees |

Skill **`git-worktrees`** — add, move, or migrate linked worktrees. Placement schema lives here; how-to lives in the skill.

Practitioner docs (Dev-Centr general-knowledge): org-scoped how-to and long-range redesign — https://docs.devcentr.org/general-knowledge/how-to/org-scoped-git-worktrees.html and https://docs.devcentr.org/general-knowledge/explanation/infrastructure/git-worktrees-long-range.html


## Where

- **`CODE_ROOT`** — base code directory (define per machine in `profiles/`)
- **`<host>`** — Git host (e.g. `github.com`, `gitlab.com`)
- **`<owner>`** — organization or user that owns the repository on the host
- **`<repo>`** — repository name
- **`.worktrees/<repo>-<purpose-slug>`** — linked worktrees for that owner (see Git worktrees above)

### Org membership checks

GitHub:

- List orgs: `gh api user/memberships/orgs --jq '.[].organization.login'`
- Membership: `gh api orgs/<org>/memberships/<username>`

GitLab:

- List groups: `glab api "groups?min_access_level=10" --jq '.[].full_path'`
- Membership: `glab api "groups/<group_id>/members/all" --jq '.[] | select(.username=="<your_username>")'`

---
*This file serves as a reminder for AI agents to maintain consistency within the workspace.*
