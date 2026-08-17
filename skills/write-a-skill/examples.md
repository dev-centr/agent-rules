# Description rewrites

Keep capability prose in the skill body. Put only **trigger words** in YAML `description`.

## Blurb vs matcher

User never says “processes spreadsheets and generates reports.” They say “pivot this xlsx.”

| Kind | Example |
| --- | --- |
| Lay description (wrong) | `Helps with GitHub organizations and project scaffolding.` |
| WHAT + WHEN sandwich (wrong) | `Stand up a GitHub organization and public site. Use when bootstrapping an org.` |
| Trigger words (right) | `Use when the user asks to bootstrap an org, create a GitHub organization, start a company or nonprofit, scaffold a CLI/library/Tauri/desktop/web app, set up .github or github.io, pick a bootstrap profile, or paste a profile { } block.` |

## House skills (pattern, not a rewrite ticket)

These are the shapes to copy. Rewrite an existing skill’s `description` only when you are already editing that skill.

**create-skill’s PDF sample — sandwich**

```yaml
# avoid
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
```

```yaml
# prefer
description: >-
  Use when working with PDF files, .pdf, form fill, merge PDFs, or
  extracting text or tables from a PDF.
```

**Capability-first (common agent default)**

```yaml
# avoid
description: >-
  Write Dev-Centr news body copy — outward shared record, inverted pyramid,
  neutral attribution, scene-based narrative. Use when drafting a news item…
```

```yaml
# prefer
description: >-
  Use when drafting a news item, ship note, org announcement, release
  narrative, or status post for the news channel.
```

The inverted-pyramid rules stay in the skill body. They are not match keys.

## Construction

1. List 5–15 things the user (or a routing agent) might actually type.
2. Add filenames and product names that imply the job (`SKILL.md`, `dub.json`, `â€œ` in AsciiDoc).
3. Add a short exclusion only when a neighbor skill would otherwise steal the match (`transcode corruption, not a refactor`).
4. Delete any sentence that would belong on a README.
