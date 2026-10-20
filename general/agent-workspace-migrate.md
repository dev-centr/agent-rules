# Agent workspace migration and cleanup

<!---
One-off workstation hygiene: move agent litter into AGENT_WORKSPACE_ROOT per
general/agent-workspace.md and general/agent-temp.md. No shared cleanup scripts
in this repo — agents follow skill agent-workspace-migrate.
--->

## When to run

- User asks to **clean**, **migrate**, or **organize** agent profile clutter, legacy **`AgentTemp`**, or home-directory scripts used only by agents.
- **`harness-setup`** or **`sync-agent-rules`** finds **`AGENT_TEMP_ROOT`** still pointing at a **flat** legacy root (no workspace parent) or **`AGENT_WORKSPACE_ROOT`** missing.
- After a **policy change** (workspace + `utilities/` + `temp/`) on a machine that still matches the old layout.

**Do not run** as a substitute for **`owned-changelog`**, repo refactors, or deleting **platform spill** (`agent-tools`, harness hard-coded paths).

## Policy recap (explain to the user first)

| Concept | Where it lives | Agent action |
| --- | --- | --- |
| **Agent workspace** | `AGENT_WORKSPACE_ROOT` | Utilities + temp subfolder |
| **Scratch** | `AGENT_TEMP_ROOT/scratch/YYYY-MM-DD/` | Agent-authored temp; organize litter here |
| **Utilities** | `AGENT_UTILITIES_ROOT/<topic>/` | Scripts agents run (Bitwarden, probes, …) |
| **Spill** | Native harness paths (e.g. `.cursor/…/agent-tools`) | **Never move or mirror** into the workspace |

Read **`general/agent-workspace.md`** and **`general/agent-temp.md`** before proposing moves.

## Safety gates (all platforms)

1. **Explain** the policy change and what will **not** be touched (spill, dotfiles, user shortcuts unless listed in the plan).
2. **Parallel agents:** Ask the user to confirm **no other agent sessions or harness workers** are moving the same paths (Cursor parallel chats, `GIT_CLOSEOUT` swarm workers, background jobs). If uncertain, **stop** until they confirm.
3. **Plan before mutate:** Write **`PLAN.md`** + **`manifest.csv`** under **`$AGENT_TEMP_ROOT/scratch/YYYY-MM-DD/agent-workspace-migrate/`** (create workspace/temp first if missing). User reviews the plan; proceed only after explicit approval unless standing chat authorization already covers this cleanup.
4. **Secrets:** Move credential helpers to **`utilities/<topic>/`** or **`scratch/…/quarantine-secrets/`** — never into git, never paste bodies into chat. Do not delete quarantined secrets without user OK.
5. **Verify manifest:** After moves, every **`move`** row must exist at destination; profile/home must match **`keep`** rows only.

## Automated safety probes (run before approval)

Use the host shell. Probes are **heuristic** — they reduce risk; they do not replace the user confirmation in step 2.

### Lock / writability probe (all platforms)

Try creating and deleting a dotfile **inside each directory you intend to rename or delete** (legacy temp root, folders you will merge):

| OS | Example |
| --- | --- |
| Windows (PowerShell) | `New-Item -Type File -Path (Join-Path $dir '.migrate-lock-probe') -Force; Remove-Item …` |
| Linux / macOS (sh/bash) | `: > "$dir/.migrate-lock-probe" && rm -f "$dir/.migrate-lock-probe"` |

If creation or removal fails, report **likely open handles** and **do not** rename/delete that tree until the user closes harnesses or reboots.

### Optional: open-handle hints

| OS | Command (if available) | Interpretation |
| --- | --- | --- |
| Windows | `openfiles /query /fo csv` (may need admin) | Noisy; use only when probe failed |
| Windows | Sysinternals **`handle.exe`** on path | Strong signal if installed |
| Linux | `fuser -vm "$path"` | PIDs using mount/file |
| Linux / macOS | `lsof +D "$path" 2>/dev/null \| head` | Often needs privileges; show user summary |

Do not install admin-only tools without asking. A failed **lock probe** is enough to pause.

### Layout probe

| Check | Legacy / problem | Target |
| --- | --- | --- |
| Flat temp root | `%LOCALAPPDATA%\AgentTemp` or `$XDG_STATE_HOME/AgentTemp` with `scratch/` at top level | Content under **`…/AgentWorkspace/temp/`** |
| Missing workspace vars | `harness.md` has only `AGENT_TEMP_ROOT` | Add **`AGENT_WORKSPACE_ROOT`**, **`AGENT_UTILITIES_ROOT`**, nest temp |
| Spill mirror | Junction/symlink from `.cursor/…/agent-tools` into workspace | **Restore** native paths (spill stays in harness tree) |
| Profile litter | Non-dot files in **`$HOME`** / **`$env:USERPROFILE`** that are agent scripts or temp | **`utilities/`** or **`temp/scratch/`** per plan |
| Windows typo dir | Literal **`%userprofile%`** folder under profile | Remove when empty after audit |

### Inventory (machine-specific)

Build rows: **`action`** (`keep` \| `move` \| `quarantine`), **`source`**, **`dest`**, **`notes`**. Classify each path — do not bulk-move by extension alone.

**Never `move`:** `NTUSER.*`, `.git`, `.ssh`, `.cursor/skills`, `.cursor/rules`, harness spill, committed project trees, user Desktop/Documents unless user explicitly includes them.

## Execution order

1. Ensure **`AGENT_WORKSPACE_ROOT`** exists (`README.md` at root).
2. Create **`utilities/`**, **`temp/`**, **`temp/scratch/`**, seed **`temp/harness-registry.json5`** (one spill root per harness — keep user **Background** comments if present).
3. Migrate **temp** content from legacy flat root into **`temp/`** (merge, do not duplicate).
4. Migrate **utilities** from profile/home into **`utilities/<topic>/`**; update **`harness.md`** entry paths (e.g. **`BITWARDEN_AGENT_ENTRY`**).
5. Update **`LOCAL_RULES_DIR`** overlays (`agent-temp`, Bitwarden, …) to new paths.
6. Remove **empty** legacy directories when lock probe passes.
7. Re-run inventory; append **`PLAN.md`** “Done” section with counts.

## Cross-platform defaults

| OS | `AGENT_WORKSPACE_ROOT` (when unset) |
| --- | --- |
| Windows | `%LOCALAPPDATA%\AgentWorkspace` |
| Linux / macOS | `$XDG_STATE_HOME/AgentWorkspace` or `~/.local/state/AgentWorkspace` |

Resolve **`$HOME`** / **`$env:USERPROFILE`** in shell — never Windows **`%userprofile%`** as a literal path segment in commands.

## Anti-patterns

- Shared PowerShell/bash **cleanup scripts** committed to agent-rules (machine plans stay in **`scratch/…/agent-workspace-migrate/`** only).
- Moving **`agent-tools`** spill into the workspace.
- Deleting files without a manifest row or user approval.
- Migrating while lock probes fail or the user has not confirmed other agents are idle.
