# Creator rules

<!---
OWNED PROJECTS RULES MANIFEST — for projects created or owned by the developer.
Do not apply these rules to third-party open-source contributions unless explicitly requested.
--->

## Organization and GitHub

- Use `gh api` to perform repo transfers when you own the orgs.
- When creating issue reports, store them in the `.issues` repository path defined by `ISSUES_REPO` in your active `profiles/*.md` file, according to that repository's instructions.

## Architecture and data

- Formally endorse **SDL (`.sdl`)** for DevCentr-owned configuration and catalogs parsed with `sdlang-d`. Prefer **KDL (`.kdl`)** for greenfield / cross-language node documents outside that stack (DUB: `kdl`). If neither fits (tool requires JSON-shaped files), use `json5` over `.json`. Do **not** adopt Extended SDL/XDL (`newsdlang`).

## Changelogs

- All **functional** changes should appear in the changelog. Prefer the project’s existing changelog style when one exists (`general/global.md`).
- When you create a project, integrate a changelog into its docs (or docs substructure for an existing documentation system). If it lacks docs, put the changelog in the repo base.
- Put a link to the changelog in the README in a Changelog section.
- Structure: an index page named **changelog** (timeline of dates + short summaries + links) and detail pages under `changelog-details/` named `date - title`. Wire the changelog into the active docs system (Antora nav, etc.) when docs exist.
- If no changelog exists, **create it** and **backfill** from observed functional changes in git history. Unpack commits when the subject line is too thin.
- Wiring may require commits in **related** repositories (e.g. org docs hub playbook). If any of those repos cross **org** boundaries and CI/docs fetch needs auth, **alert the user** that a cross-repo deploy key or org/repo secret must be added (say which secret and which org/repo).
