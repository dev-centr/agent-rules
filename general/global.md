# Global rules

<!---
GLOBAL RULES MANIFEST — foundational rules for the development environment.
These apply universally unless a profile says otherwise.
--->

## General best practices

- Write explanations as if for readers who want plain language.
- Use `.gitignore` as an allow-list with additional exclusions. Exclude all files by default and update the allowlist when adding new files.
- Always put Python projects in a `venv`.
- When building a project fails, check for outdated code instead of downgrading dependencies. If a build fails because of a missing icon, stop building. Instead, import icons from a free icon library online to build the app, or ask the user to add the missing icon.
- When working from a to-do list in a file, use checkmark emojis to mark off completed items in the file.
- Update changelogs according to the style already detected in the repository.

## AI operations and formatting

- When a repo depends on external libraries or frameworks whose APIs are likely to be stale in AI memory, use Context7 MCP. If no docs have been indexed, alert the user that they should submit the project's docs, and provide a URL for the docs and Context7 (<https://context7.com/>). If Context7 is not found, explain Context7 and MCP and direct the user to their docs overview: <https://context7.com/docs/overview>.
  - If the user confirms this is unavailable, use the fallback strategy in [Outdated code protocol fallback](#outdated-code-protocol-fallback).
- AI formatting pitfalls (AsciiDoc):
  - Checklist: fails to include asterisk. `* [ ]`
  - Bold text as pseudoheading: fails to insert a blank line between **text** and the next block.
  - Lists: fails to add list continuations (`+`) before list items' continued blocks.
  - Generate image: blocks for inline images, not `image::` blocks.

## Supplemental rules

- You **must** read `general/environment.md` before acting.
- You **must** read **one** OS-specific file based on the `ENVIRONMENT` constant in your active `profiles/*.md` file:
  - `windows` → `general/windows.md`
  - `mac` → `general/mac.md`
  - `linux` → `general/linux.md`
  - If `ENVIRONMENT` is missing, ask the user which file applies before assuming an OS.
- You **must** read `general/creator.md` before acting.
- Read `general/documentation.md` when you are authoring, structuring, or publishing project documentation (optional layer for doc-heavy work).

## Memory management

- If the user has to teach you something or you have to probe the local environment and it seems likely you will use that information in a future prompt, you **must** read `MEMORIES.md` before acting. `MEMORIES.md` is **machine-local** and **gitignored**. Record your findings so you do not have to figure it out every time you run into the same unknown. Every memory needs a counter initialized to 1. When you use a memory, increment its counter. If this file does not exist, initialize it.

## Outdated code protocol fallback

*(Fallback strategy if Context7 is ignored)*

- Create a repo-local workflow for AI agents and developers.
- For that workflow, strongly prefer repo-local indexed docs or source over web search when the repo uses AI or RAG indexing and API accuracy matters.
- Standard structure for that workflow:
  - committed template manifest: `AI-LOCAL-LIBRARY-DOCS.example.json5`
  - ignored machine-local manifest: `AI-LOCAL-LIBRARY-DOCS.local.json5`
  - ignored local docs or source cache inside the repo: `docs/_local-library-docs/`
  - refresh or bootstrap script in `scripts/` to clone or update those docs or source repositories
- The filename `AI-LOCAL-LIBRARY-DOCS.local.json5` is intentionally loud so AI tools notice it. Use that exact name unless the user asks otherwise.
- Add `.gitignore` entries for `AI-LOCAL-LIBRARY-DOCS.local.json5` and `docs/_local-library-docs/` when setting this up.
- Document this workflow in the repo README and docs so new developers and AI agents know to initialize it before doing version-sensitive dependency work.
- In that documentation, tell AI to search local cloned docs or source first, then use web search only when local docs are missing, stale, or clearly not the version in use.
- For D and similar ecosystems, prefer cloning the source repositories because doc comments, examples, and actual implementation are often all needed to resolve API truth.
- If a developer wants a writable personal copy of a docs or source repo, prefer one local clone with multiple Git remotes (`origin` for the fork, `upstream` for the source project) instead of multiple duplicate local clones.
- If many repositories on the same machine need the same supporting docs or source repositories, prefer a shared local Git cache or reference clone strategy. Use normal Git features like additional remotes, `git clone --reference` or `--reference-if-able`, or a local mirror cache. Avoid requiring hardlinks or symlinks as the primary strategy for large shared trees.
- If web search is chosen instead of local docs, make that an explicit project decision in docs and tell AI to verify each dependency against upstream docs rather than trusting model memory.
