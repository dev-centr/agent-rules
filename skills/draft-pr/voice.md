# Pull requests (portable)

Read this file when you **open or draft a pull request** (upstream gift, fork PR, or internal review). Complements the mechanical `gh pr create` steps in User Rules.

## Title

- Use **simple, plain language**. A maintainer skimming the list should know the change without decoding jargon.
- Prefer orientation over ticket-speak: what the reader gains, not the internal ticket ID alone.
- Good: `Make dark mode cover the preview and title bar`
- Avoid: `feat(ui): implement WindowChrome DWM-adjacent theming pipeline for #679`

## Summary / intro

Write the opening of the PR body in **plain English** and make it **inviting**—a gift to maintainers, not a lecture.

1. **Lead with the human problem** in one or two sentences (why this matters for someone using the app).
2. **Say what the PR tries to do** in short bullets (preview, title bar, editor sync, …).
3. **Call out surprises** early (e.g. export HTML unchanged; known Win11 snap tradeoff).
4. **Credit inspiration carefully** when you borrowed *ideas* (not code/icons) from elsewhere.
5. **Invite feedback** (“Happy to adjust anything that doesn’t fit the project’s taste.”).
6. Link issues with `Fixes #N` when appropriate.

### Skeleton (adapt; do not paste robotic filler)

```markdown
## Summary

Hi! <plain-English problem>.

This PR tries to <goal>:

- <bullet>
- <bullet>

<optional: inspiration / tradeoffs in one short paragraph>

Happy to adjust anything that doesn’t fit the project’s taste.

Fixes #N

## Screenshots

<!-- UI-visible changes: before/after at minimum -->

## How to try it

1. …
```

## Screenshots

For **UI-visible** changes, include **before/after screenshots at minimum** so the PR feels inviting to review. Prefer: full window, close-up of the changed chrome, and a toggle (e.g. light↔dark) when relevant.

## Tone

- Warm, direct, respectful of maintainer time.
- No policy dumps, no flexing architecture jargon in the intro.
- Detail and tradeoffs can follow under Screenshots / Notes / How to try it.

## Relationship to house title doctrine

News/blog **content** titles still follow site `STYLE.adoc` and `agents/editorial/titles.md`.
**PR titles** optimize for reviewability in a GitHub list—same plain-language spirit, different channel.
