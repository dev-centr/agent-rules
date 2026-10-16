---
name: owned-changelog
description: >-
  Use when adding a changelog, writing changelog-details, backfilling a
  changelog from git, wiring a changelog into docs, or recording a functional
  change in an owned project.
---

# Owned-project changelog

Applies to repositories the user **owns or created**, not third-party contributions unless they ask.

If the repo already has a changelog, **match that style** (layout, tense, headings). The structure below is the house default when you are creating or repairing one.

## Always

- Record **functional** changes.
- Link the changelog from the README (Changelog section).
- Index page named **changelog** (timeline of dates + short summaries + links).
- Detail pages under `changelog-details/` named `date - title` (ASCII hyphen in **filenames** only).
- Wire into the active docs system (Antora nav, etc.) when docs exist. If the project has no docs, put the changelog at the repo base.
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

## Create or backfill

If none exists: **create it** and **backfill** from observed functional changes in git history. Unpack commits when the subject line is too thin.

When you add docs later, update the changelog structure so it still fits.

## Cross-repo wiring

Wiring may need commits in **related** repositories (org docs hub playbook). If those repos cross **org** boundaries and CI/docs fetch needs auth, **alert the user** which secret must be added on which org/repo — do not invent credentials.
