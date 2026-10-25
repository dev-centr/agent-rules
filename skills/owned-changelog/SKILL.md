---
name: owned-changelog
description: >-
  Use when adding a changelog, writing changelog-details, backfilling a
  changelog from git, wiring a changelog into docs, or recording a functional
  change in an owned project; save this report, save the prompt, saved prompt,
  generated report, historical context, migration notes, setup notes, analysis
  doc, audit write-up, where do reports go, history folder, changelog-details/history,
  changelog-details history folder, History and reports, stray root files, loose files in repo
  root, root CHANGELOG stub.
---

# Owned-project changelog

Applies to repositories the user **owns or created**, not third-party contributions unless they ask.

If the repo already has a changelog, **match that style** (layout, tense, headings). The structure below is the house default when you are creating or repairing one.

## Always

- Record **functional** changes.
- Link the changelog from the README (Changelog section).
- Index page named **changelog** (timeline of dates + short summaries + links).
- Detail pages under `changelog-details/` named `date - title` (ASCII hyphen in **filenames** only).
- **Antora repos keep the changelog inside Antora.** When the repo has `docs/antora.yml` or `docs/modules/`, the real changelog is `docs/modules/<module>/pages/changelog.adoc` (+ `changelog-details/`) in the component nav. Move an existing root changelog there and repoint README links. A root `CHANGELOG.md` / `CHANGELOG.adoc` may remain **only as a short stub**: one sentence plus the published Antora changelog URL and its source path (`docs/modules/<module>/pages/changelog.adoc`) - no entries. Only repos with no docs site keep the full changelog at the repo base (`CHANGELOG.adoc`).
- **History artifacts never sit loose in the repo root** - see *History artifacts* below.
- Reader-facing summaries assume a stranger scanning the timeline — not chat context (`general/documentation.md` Audience / POV).

## Timeline headings (index + detail)

**Dates and descriptions are separate heading levels** so the page TOC stays regular (date lines do not wrap long em-dash summaries).

### Index (`changelog.adoc`)

Set `:toclevels: 3` when same-day entries use level-3 topics.

```asciidoc
== 2026-10-16

Portal hub updates.

=== Linkinator hover bar and chrome exclusions
* …
=== Facto stack and site search
* …
```

- **`== YYYY-MM-DD`** — date only. No em dash, no description on the date line.
- **`=== Short description`** — every ship gets a level-3 subheading with a **short** scan line (aim for one TOC line; roughly **≤8 words**, like “Portal hub updates”). Sentence case; no trailing period on heading lines.
- **Optional day blurb** — plain text (not a heading) immediately under the date when several same-day items share a theme. Keep it **short**; do not repeat the full `===` titles.
- Single-ship days: still use `== date` + one `=== description` + bullets (do not put the description only on the date line).
- Do **not** use `(later)` or similar disambiguators — order sections chronologically (newest-first on the index is fine).

### Detail (`changelog-details/*.adoc`)

```asciidoc
= 2026-10-16

== Linkinator hover bar and chrome exclusions
```

Level-1 is the date only; level-2 is the same short description as the matching `===` on the index.

**Nav audit:** detail pages are intentionally omitted from `nav.adoc`. Put `:hide-page:` and `:navtree-parent: changelog.adoc` on each `changelog-details/*.adoc` file so `nav-drift --require-in-nav` and SoftNav breadcrumbs/nav injection treat them as deliberate xref-only pages (hidden from left nav tree only; page stays published).

### Same calendar day

One **`== YYYY-MM-DD`** per calendar day on the index. Multiple ships that day get multiple **`===`** sections (and matching detail pages). Do not merge unrelated ships into one bullet list without subheadings.

### Conform older entries

When you **touch** a repo changelog:

1. Normalize index dates to bare `== YYYY-MM-DD` and move descriptions to `===` (or `==` on detail pages).
2. Align detail titles to `= YYYY-MM-DD` + `== description`.
3. Do not rename detail **files** unless the user asks (`YYYY-MM-DD - slug.adoc`).

Do **not** use em dashes in published changelog **headings** for this layout (filenames still use ASCII ` - `).

## History artifacts (reports, saved prompts, analyses, migration notes)

**Rule:** Saved prompts, generated reports, analyses, migration notes, setup records, and similar historical-context documents (things the owner asked for, or that record how the repo was set up and changed) **never sit loose in the repo root**. They are filed in **`changelog-details/history/`** and linked from the changelog. Why `changelog-details/`: the folder name reads as subordinate to the changelog, so readers go to *the* changelog first; never name a folder with the plural `changelogs`.

| Repo shape | Real changelog | History artifacts go in |
| --- | --- | --- |
| Antora docs (`docs/antora.yml`) | `docs/modules/<module>/pages/changelog.adoc` | `docs/modules/<module>/pages/changelog-details/history/YYYY-MM-DD-<slug>.adoc` |
| No docs site of any kind | root `CHANGELOG.adoc` | root `changelog-details/history/YYYY-MM-DD-<slug>.adoc` |

**Antora repos**

- History pages are **unlisted**: never in `nav.adoc`; set `:hide-page:` and `:navtree-parent: changelog.adoc` (same as `changelog-details/`). They stay published and reachable by xref.
- Convert to AsciiDoc where reasonable (headings, lists, tables, code). A verbatim prompt goes in a `[source,text]` or literal block inside the `.adoc` page rather than as a raw `.md`/`.txt`.
- Content meant only to be `include::`d (not a standalone page) goes in `docs/modules/<module>/partials/changelog-details/history/` (house convention; not `partials/history/`).
- Link each page from the changelog entry it explains and/or from a `== History and reports` section at the end of `changelog.adoc` (one bullet per page: date, xref, one-line purpose).

**Repos with no docs site** (no Antora, MkDocs, Docusaurus, or similar)

- Keep the full changelog in root `CHANGELOG.adoc`; history documents go in root **`changelog-details/history/`** - the only convention (no `changelog/history/` or other alternative). Name files `YYYY-MM-DD-<slug>.adoc`.
- Link each from the matching changelog entry and/or a `== History and reports` section of `CHANGELOG.adoc`.

**Not history artifacts**

- Throwaway verification files (one-off playbooks, scratch configs, probe scripts, test outputs) go in the agent scratch dir (`$AGENT_TEMP_ROOT/scratch/YYYY-MM-DD/`, skill `agent-temp`) and are **never committed**.
- Contributor guides (`STYLE.adoc`, `CONTRIBUTING.*`, `CODE_OF_CONDUCT.*`, `SECURITY.*`) are not history; they stay where contributor docs belong (root or `.github/` per forge convention, or the docs component's contributor pages).

**Stray root files:** when you find a loose report / prompt / analysis / migration note in the repo root, `git mv` it into the right `changelog-details/history/` folder (converting to AsciiDoc where reasonable), repoint any links, and add the changelog link in the same commit.

## Create or backfill

If none exists: **create it** and **backfill** from observed functional changes in git history. Unpack commits when the subject line is too thin.

When you add docs later, update the changelog structure so it still fits.

## Cross-repo wiring

Wiring may need commits in **related** repositories (org docs hub playbook). If those repos cross **org** boundaries and CI/docs fetch needs auth, **alert the user** which secret must be added on which org/repo — do not invent credentials.
