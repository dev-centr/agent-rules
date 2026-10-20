---
name: agent-workspace-migrate
description: >-
  Use when migrating agent workspace, cleaning profile agent litter, legacy
  AgentTemp, flat AgentTemp to AgentWorkspace, organize agent garbage,
  agent utilities in home directory, consolidate agent scripts, workspace
  cleanup, agent-workspace-migrate, PLAN.md manifest.csv, quarantine-secrets,
  spill must not move, parallel agents cleanup safety, open file handles
  before migrate, harness-setup found old AGENT_TEMP_ROOT.
---

# Agent workspace migrate

Read **`general/agent-workspace-migrate.md`** plus **`general/agent-workspace.md`** and **`general/agent-temp.md`**.

## Trigger

Load this skill when the user wants agent-related **cleanup/migration**, or when probe shows **legacy layout** (flat temp root, utilities still in `$HOME` / profile root).

## Workflow (do not skip)

1. **Explain** workspace vs scratch vs utilities vs spill (harness-native `agent-tools`). State what you will **not** touch.
2. **Inventory** this machine — explicit paths; build **`manifest.csv`** (no generic extension heuristics alone).
3. **Safety probes** (cross-platform):
   - Lock/writability dotfile probe on every directory to rename/delete (see general doc).
   - Optional `lsof` / `fuser` / `handle` / `openfiles` only if probe failed and tool exists.
4. **Parallel agents:** Ask the user to confirm **no other agent sessions or workers** are using those paths. If they cannot confirm, **wait**.
5. **Plan:** Write **`$AGENT_TEMP_ROOT/scratch/YYYY-MM-DD/agent-workspace-migrate/PLAN.md`** summarizing policy, probes, manifest counts, and ordered steps. **Get approval** before destructive moves.
6. **Execute** per general doc execution order; update **`$CODE_ROOT/harness.md`** and **`LOCAL_RULES_DIR`** overlays.
7. **Verify** manifest destinations; report profile/home keepers vs moved counts.

## During normal work

- **Writing scratch:** skill **`agent-temp`** — not this skill.
- **Spill paths in tool output:** do not move; optional registry update only (`harness-registry.json5`).

## No repo scripts

Do not add cleanup scripts under agent-rules. Machine-local helpers belong only under **`scratch/…/agent-workspace-migrate/`** if the user wants a reusable script on that PC.
