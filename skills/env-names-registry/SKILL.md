---
name: env-names-registry
description: >-
  Use when adding env vars, process.env, .env.example, docs/ENV-VARIABLES.md,
  ENV.md, a new integration, Netlify env, or deploy environment setup; names
  only — never store secret values.
---

# Environment variable registry (names only)

The user often skips host env setup. Keep a **name-only** registry per repo. Never store actual API keys.

## Never in git or docs

- Do **not** write real API keys, tokens, or passwords in markdown, rules, `MEMORIES.md`, `.env.example`, comments, or commits.
- `.env.example` uses **empty** values (or `your-key-here` only if the host requires a non-empty placeholder).
- Do not echo or suggest committing secret values the user pasted in chat.

## Per project

1. **`docs/ENV-VARIABLES.md`** (or `docs/ENV.md`) — table of **names** only:

   | Column | Content |
   | --- | --- |
   | Variable name | Exact `process.env` name |
   | Service | Vendor + signup link |
   | What it does | Plain language |
   | Required? | Required / Recommended / Optional |
   | Where to obtain a value | Console path — not the value |
   | Set value in | Netlify UI, local `.env`, etc. |
   | If unset | Degraded behavior |

2. **`.env.example`** — same names, empty values, link to `docs/ENV-VARIABLES.md`.
3. **README** — link under Deployment.

## When adding integrations

Update the table and `.env.example` (names only) in the **same** change. Tell the user which **variable names** to create in the host UI; values stay in the host / local `.env`.

## Before deploy

Read `docs/ENV-VARIABLES.md` and list unset Required / Recommended names — do not assume they are configured.

## New projects

Create `docs/ENV-VARIABLES.md` early. Optional: repo `.cursor/rules/env-variables.mdc` pointing at that file.
