---
name: public-readme
description: >-
  Use when creating or revising a public README, README.md, or README.adoc;
  GitHub-facing repo face; GitLab README; Best-README; Explore the docs;
  shields.io badges; Built With; contrib.rocks; for-the-badge chrome;
  visitor-facing README; naive reader repo face.
---

# Public README

Repo **face** layout for owned / org repositories. Not product docs (those stay in `docs/`). Blanks: [dev-centr/readme-template](https://github.com/dev-centr/readme-template). Hand-edit per repo — do not batch-script rewrites.

**Audience:** the forge visitor / downstream user — never the chat commissioner. Apply **Audience / point of view** in `general/documentation.md` before drafting. Lead with who the README is for. Wrong voice = maintainer notes, session TODOs, or agent briefing paste.

**GitHub is the default adapter** (known to work). Other forges: same sections and chrome; swap metric URLs; do not copy GitHub-only AsciiDoc `ifdef::env-github[]` unless that host needs it.

Full templates and trapped-badge notes: [reference.md](reference.md).

## Portable job

- Centered header: badges + title + one-liner + quick links in **one** block
- Linked metric badges (destination = the thing represented, never the shield image URL)
- Org repos with a docs hub: **Explore the docs »** text link → hub component URL, not a second per-repo Antora Pages site. No extra Docs/CI shield that fights the established chrome
- Align GitHub **About homepage** with that same hub component URL for ordinary project repos (exceptions: org main/marketing site, or a product with its own domain/subdomain — skill `bootstrap-org`)
- TOC when more than three sections
- **Built With** grouped by role (runtime / UI / docs / packaging), not a sticker row
- Section back-to-top; Contact from real profile fields; omit empty Roadmap/Acknowledgments
- Do not add a Docs/CI chip to the header unless that repo already uses one

## Repo root hygiene

The root is the repo face: README, LICENSE, contributor guides (`CONTRIBUTING`, `STYLE.adoc`, `SECURITY`), build/manifest files, and at most a changelog. Saved prompts, generated reports, analyses, and migration notes never sit loose in the root - file them in `changelog-details/history/` (root in repos without a docs site; `docs/modules/<module>/pages/changelog-details/history/` in Antora repos) (skill `owned-changelog`, *History artifacts*). Throwaway verification files stay in agent scratch (skill `agent-temp`). In Antora repos a root `CHANGELOG` is only a stub linking the published Antora changelog.

## Host adapters

| Host | Metric badges / links | Markup notes |
| --- | --- | --- |
| **GitHub (default)** | `shields.io/github/…`; dest `github.com/OWNER/REPO/{graphs/contributors,network/members,stargazers,issues,blob/BRANCH/LICENSE}` | HTML `<a href><img>` **inside** `<div align="center">` — GFM does not resolve Markdown links there. `contrib.rocks` optional on full tier. AsciiDoc face: HTML passthrough header; keep `link=` on local `image:` macros. |
| **GitLab / others** | Equivalent host badge APIs and forge paths (`/-/issues`, forks, stars). shields.io has GitLab metrics. | `<div align="center">` usually works. Native AsciiDoc is often fine without `env-github`. Skip contrib.rocks unless that host is supported. |

**Registry listing copy** (npm, crates.io): keep or add Markdown even if deep docs are AsciiDoc. Do not delete a Markdown README that exists for a registry.

**Fork of upstream:** retain upstream’s face format.

## Tiers

| Audience | Layout |
| --- | --- |
| User-facing / downstream | Full chrome |
| Internal / non-downstream | Simplified shields + About + install/usage + License/Contact |
| Skip | School, org `.github` profiles, archived, tap/registry-instruction-only, empty repos |
