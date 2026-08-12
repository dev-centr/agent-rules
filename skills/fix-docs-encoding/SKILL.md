---
name: fix-docs-encoding
description: >-
  Detect and repair double-encoded UTF-8 mojibake and invalid SVG XML in Antora
  docs (transcode corruption, not a refactor). Use when AsciiDoc/SVG shows
  â€œ-style garbage, SVG opens with Encoding/EntityName errors, or after
  authoring hand-written SVGs or Windows-edited .adoc files.
---
# Fix docs encoding (transcode)

**This is a transcode / corruption repair, not a code refactor.** Antora does not generate the hand-authored mock SVGs; bad bytes come from agent/editor writes on Windows.

## When to run

- After creating or editing `*.svg` under `modules/*/images/`
- When the page shows `â€œ` / `â€™` / `â€”` instead of quotes/dashes
- When opening an SVG URL shows XML *Encoding error* or *EntityName*
- Before committing Antora figure work on Windows

## Command

From any docs component (or pass paths):

```powershell
uv run --with ftfy python "$AGENT_RULES_PATH/skills/fix-docs-encoding/scripts/fix_docs_encoding.py" --check docs
uv run --with ftfy python "$AGENT_RULES_PATH/skills/fix-docs-encoding/scripts/fix_docs_encoding.py" --fix docs
```

`ftfy` is optional; the script recovers classic cp1252-mojibake without it. Prefer `uv run` so no global install is required.

Exit non-zero on `--check` when problems remain.

## Agent checklist

1. Run `--check` on touched `docs/` (or specific files).
2. If mojibake: `--fix`, then re-`--check`.
3. If SVG XML still fails: fix unescaped `&` / `<` in labels (`&amp;` / `&lt;`) by hand — that is markup, not encoding.
4. Prefer **ASCII** punctuation in new SVG text (`"`, `--`, `...`, `->`).
5. Do **not** “fix” by re-saving the garbled glyphs as UTF-8 again (double-encodes further).

## Mock SVG chrome (layout, not encoding)

Do not stack a second **stroked** chrome `<rect>` over the breadcrumb. Use one fill-only top-rounded `<path class="chrome">` plus a `<line class="chrome-rule">` **below** the label baseline. See Access mocks in `general-knowledge` `docs/modules/ROOT/images/access-mock-*.svg`.
