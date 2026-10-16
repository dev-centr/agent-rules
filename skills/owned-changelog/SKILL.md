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

Use a **Unicode em dash** (`—`, U+2014) between the date and a short scan line. Do **not** use `--`, ` - `, or en dash (`–`) in published headings.

**Detail** (Antora level-1):

```asciidoc
= 2026-10-16 — Linkinator hover bar and chrome exclusions
```

### Same calendar day — pick a layout

**A. Peer sections (good for scrolling the page)** — repeat the date when each ship deserves its own one-line summary:

```asciidoc
== 2026-10-16 — Linkinator hover bar and chrome exclusions
== 2026-10-16 — Facto stack and site search
```

**B. Grouped under one date (good when several small same-day items share a day)** — one level-2 date line plus level-3 topics that appear in the **page TOC** (right sidebar):

```asciidoc
:toclevels: 3

== 2026-10-16 — Portal hub updates

=== Linkinator hover bar and chrome exclusions
* …
=== Facto stack and site search
* …
```

Use **A** when each entry is a distinct story users should skim from level-2 headings. Use **B** when one date banner plus topical `===` lines keeps the timeline tidy and TOC still lists each topic. Do **not** merge unrelated ships into one bullet list without subheadings.

Rules:

- Every level-2 or level-3 changelog heading gets a **mini description** after the em dash (not a bare date).
- Do **not** use `(later)` or similar disambiguators on dates — order bullets or sections chronologically (newest-first on the index is fine).
- Sentence case; no trailing period on heading lines.

### Conform older entries

When you **touch** a repo changelog:

1. Normalize headings to ` — ` (em dash) + description.
2. Align detail titles to `YYYY-MM-DD — description`.
3. Do not rename detail **files** unless the user asks (`YYYY-MM-DD - slug.adoc`).

## Create or backfill

If none exists: **create it** and **backfill** from observed functional changes in git history. Unpack commits when the subject line is too thin.

When you add docs later, update the changelog structure so it still fits.

## Cross-repo wiring

Wiring may need commits in **related** repositories (org docs hub playbook). If those repos cross **org** boundaries and CI/docs fetch needs auth, **alert the user** which secret must be added on which org/repo — do not invent credentials.
