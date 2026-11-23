# One canonical form

## Rule

Where humans must learn and recall a token by memory — config keys, AsciiDoc roles, CLI subcommands, API names, or house terminology — define **one** canonical, semantic form. Do not add synonym aliases.

## Why

Synonyms for a memorized token actively hurt learning:

- **Recall interference:** competing spellings (`linkinator-skip` vs `skip-linkinator`) force people to second-guess which form is real.
- **False semantic distinction:** learners encountering two names assume there is a subtle behavioral difference and waste time checking docs.
- **Fragmented corpus:** examples, repos, and searches drift across mixed spellings.

## Naming bar

Refusing aliases raises the bar on naming the first time:

- Choose **semantic, domain-level names** over tool-coupled or abbreviated ones (for example, `role=archival` rather than `role=lini-skip`).
- In `0.x` or owned internal tools, rename cleanly instead of accumulating backward-compatibility aliases.

## Boundaries (where this does not apply)

1. **Discovery and intent matching:** search indexes, `SKILL.md` trigger `description` fields, and natural-language matchers *should* carry synonyms — users are not expected to memorize an exact phrase to trigger discovery.
2. **Distinct ergonomic tiers:** systematic short flags paired with long flags (`-f` / `--force`) or separate modalities (GUI button, keyboard shortcut, CLI command) serve different ergonomics rather than competing synonyms in the same recall slot.
3. **External-consumer migrations:** when a stable public API or CLI has real external users, prefer a loud, **time-boxed deprecation** with an explicit removal version — and omit the old name from teaching docs and examples so new learners only ever see the canonical form.
