---
name: env-names-registry
description: >-
  Use when adding env vars, process.env, .env.example,
  environment-variables.adoc, docs/ENV-VARIABLES.md, ENV.md, a new
  integration, Vercel or Netlify env, or deploy environment setup; names
  only - never store secret values.
---

# Environment variable registry (names only)

The user often skips host env setup. Keep a **name-only** registry per repo. Never store actual API keys.

## Never in git or docs

- Do **not** write real API keys, tokens, or passwords in docs, rules, `machine.md`, `.env.example`, comments, or commits.
- `.env.example` uses **empty** values (or `your-key-here` only if the host requires a non-empty placeholder).
- Do not echo or suggest committing secret values the user pasted in chat.

## Where the registry lives

- **Default:** AsciiDoc page `environment-variables.adoc` - the Antora page `docs/modules/<module>/pages/environment-variables.adoc` when the repo has Antora docs, otherwise `docs/environment-variables.adoc`.
- **Markdown** `docs/ENV-VARIABLES.md` only for repos with no AsciiDoc docs.
- Keep an existing registry file; migrate its table to the columns below when you touch it.

## Table format (5 columns)

| Column | Content |
| --- | --- |
| Variable | Exact env var name |
| Purpose | What it does, in plain language |
| Required | `Yes` (app fails or a core feature breaks) / `No` (working default) / `Optional` (enables an extra feature) |
| If unset | Behavior when missing (error, feature disabled, default used) |
| Source | Where to obtain the value (vendor + console path, never the value) and where to set it (e.g. Vercel project env, local `.env`) |

AsciiDoc row shape:

```asciidoc
[cols="2,3,1,2,3",options="header"]
|===
| Variable | Purpose | Required | If unset | Source

| `EXAMPLE_API_KEY`
| Signs requests to Example.
| Yes
| Example routes return 503.
| https://example.com/[Example] dashboard > API keys. Set in Vercel project env and local `.env.local`.
|===
```

- Group rows by service with a section heading when the table is long.

## Per project

1. **Registry page** - the table above.
2. **`.env.example`** - same names, empty values, a comment linking the registry page.
3. **README** - link the registry wherever setup or deploy instructions live (no specific heading required).

## When adding integrations

Update the registry and `.env.example` (names only) in the **same** change. Tell the user which **variable names** to create in the host UI; values stay in the host / local `.env`.

## Before deploy

Read the registry and list unset `Yes` names - do not assume they are configured.

## New projects

Create the registry page early. Optional: repo `.cursor/rules/env-variables.mdc` pointing at that file.
