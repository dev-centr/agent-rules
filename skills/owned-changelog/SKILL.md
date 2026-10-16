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

**Index** (Antora level-2):

```asciidoc
== 2026-10-16 — Linkinator hover bar and chrome exclusions
```

**Detail** (Antora level-1): same date + em dash + description (may be slightly longer than the index line; keep the same voice).

```asciidoc
= 2026-10-16 — Linkinator hover bar and chrome exclusions
```

Rules:

- Every index entry gets a **mini description** after the em dash (not a bare `== 2026-09-08`).
- **One `== YYYY-MM-DD —` section per calendar day** on the index. Additional work that lands the same day extends that section (new bullets, detail links)—do **not** add a second date heading or `(later)` disambiguators.
- Same-day **sequence**: order bullets chronologically; say so in prose when it matters (`same day, after …`). Split detail pages are fine; the index stays one section.
- Sentence case for the description; no trailing period on the heading line.

### Conform older entries

When you **touch** a repo changelog for any reason, scan the index and detail pages:

1. Replace legacy ` -- `, bare dates, or wrong dash characters in headings with ` — ` + description.
2. **Merge duplicate date headings** on the index into a single `==` section with ordered bullets and links to each detail page.
3. Align detail page titles to `YYYY-MM-DD — description` (drop prefixes like `Changelog detail:` unless mid-migration).
4. Do not rename detail **files** unless the user asks (paths stay `YYYY-MM-DD - slug.adoc`).

## Create or backfill

If none exists: **create it** and **backfill** from observed functional changes in git history. Unpack commits when the subject line is too thin.

When you add docs later, update the changelog structure so it still fits.

## Cross-repo wiring

Wiring may need commits in **related** repositories (org docs hub playbook). If those repos cross **org** boundaries and CI/docs fetch needs auth, **alert the user** which secret must be added on which org/repo — do not invent credentials.
