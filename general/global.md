# Global rules

<!---
GLOBAL RULES MANIFEST — foundational rules for the development environment.
These apply universally unless a profile says otherwise.
--->

## General best practices

- Write explanations as if for readers who want plain language.
- **File names in chat:** follow `$CODE_ROOT/harness.md` (`CHAT_FILE_LINKS`, `CODE_CITATION`). Default: highlight the **file name** as a markdown link to the workspace-relative path (forward slashes). Example: [`SKILL.md`](skills/write-a-skill/SKILL.md). Detail: `general/harness.md`.
- Use `.gitignore` as an allow-list with additional exclusions. Exclude all files by default and update the allowlist when adding new files.
- Always put Python projects in a `venv`.
- When building a project fails, check for outdated code instead of downgrading dependencies. If a build fails because of a missing icon, stop building. Instead, import icons from a free icon library online to build the app, or ask the user to add the missing icon.
- When working from a to-do list in a file, use checkmark emojis to mark off completed items in the file.
- Update changelogs according to the style already detected in the repository.
- **Sync with remote before multi-file work:** in each affected git repo, `git fetch` and check `git status -sb` for `behind`. If the branch tracks a remote and is behind, pull/rebase (or merge) **before** coding. Do not invent a large change set against a stale local HEAD.
- **End of agent run:** after file changes, logical commits + push before the final reply — `general/end-of-run.md` (skill `push-code`).
- **Sync skills/rules on drift:** skill `sync-agent-rules` — detail `general/rules-skills-sync.md`. Set version = `$AGENT_RULES_PATH` git SHA stamped in `$CODE_ROOT/harness.md`.

## AI operations and formatting

- When a repo depends on external libraries or frameworks whose APIs are likely to be stale in AI memory, use Context7 MCP when `MCP_CONTEXT7 = available` in `$CODE_ROOT/harness.md`. If no docs have been indexed, alert the user that they should submit the project's docs, and provide a URL for the docs and Context7 (<https://context7.com/>). If Context7 is not found, explain Context7 and MCP and direct the user to their docs overview: <https://context7.com/docs/overview>.
  - If the user confirms this is unavailable, use skill **`outdated-code-protocol`**.
- AI formatting pitfalls (AsciiDoc):
  - Checklist: fails to include asterisk. `* [ ]`
  - Bold text as pseudoheading: fails to insert a blank line between **text** and the next block.
  - Lists: fails to add list continuations (`+`) before list items' continued blocks.
  - Generate image: blocks for inline images, not `image::` blocks.

## Supplemental rules

- You **must** read `general/harness.md` and `general/harness-boundary.md` before acting.
- You **must** read `general/environment.md` before acting.
- You **must** read **one** OS-specific file based on the `ENVIRONMENT` constant in your active `profiles/*.md` file:
  - `windows` → `general/windows.md`
  - `mac` → `general/mac.md`
  - `linux` → `general/linux.md`
  - If `ENVIRONMENT` is missing, ask the user which file applies before assuming an OS.
- You **must** read `general/creator.md` before acting.
- Read `general/documentation.md` when you are authoring, structuring, or publishing project documentation (optional layer for doc-heavy work).
- Heavy curricula are agent skills (not always-on reads): `antora-org-site`, `public-readme`, `ship-app`, `draft-pr`, `owned-changelog`, `issue-reports`, `issues-repo-record`, `harness-setup`, `sync-agent-rules`, `env-names-registry` — see `skills/CATALOG.md`.

## Memory management

- **Harness config:** read and update **`$CODE_ROOT/harness.md`** when discovery paths or chat behaviors change (see `harness.example.md`; skill `harness-setup`).
- **Workstation facts:** if the user teaches you something about **this machine/environment**, or you probe the local environment and will need it again, read and update **`$CODE_ROOT/machine.md`** (create if missing; see `machine.example.md`). Never commit. Every memory needs a counter starting at 1; increment on reuse.
- Project knowledge belongs in the repo (`AGENTS.md`, README, docs, `STYLE.adoc`) — not in `machine.md` at `$CODE_ROOT` and not in a per-repo `machine.md`.

## Outdated code protocol

When Context7 is unavailable or ignored, use skill **`outdated-code-protocol`** (`skills/outdated-code-protocol/`). Do not paste that body here.
