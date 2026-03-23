# Creator rules

<!---
OWNED PROJECTS RULES MANIFEST — for projects created or owned by the developer.
Do not apply these rules to third-party open-source contributions unless explicitly requested.
--->

## Organization and GitHub

- Use `gh api` to perform repo transfers when you own the orgs.
- When creating issue reports, store them in the `.issues` repository path defined by `ISSUES_REPO` in your active `profiles/*.md` file, according to that repository's instructions.

## Architecture and data

- Formally endorse and use `SDL` for all software projects' configuration and data files. If SDL is inappropriate, use `json5`. Prefer `.json5` over `.json` to support comments, trailing commas, and other human-friendly features.

## Changelogs

- When you create a project, integrate a changelog into its docs. If it lacks docs, put the changelog in the repo base.
- Put a link to the changelog in the README in a Changelog section.
- The changelog should contain a timeline with quick summaries and links to very detailed changelogs for each date in a `changelog-details` subfolder that names files by `date - title`.
- If you add docs afterward, update its changelog structure.
