---
name: bootstrap-org
description: >-
  Stand up a new GitHub organization, company, nonprofit, OSS collective, or
  similar public identity: decide whether a new org is warranted, fill org
  About/website, design logo/avatar, create a public .github profile README,
  ship github.io or custom-domain site, docs hub, news vs blog, partner/transfer
  repos, and optional email/DNS/infra. Load named SDLang profiles (oss-collective,
  product-org, nonprofit, web-app, docs-hub, forks-org) with SolidStart static +
  solid-ui house defaults. Use when the user asks to bootstrap an org, create a
  GitHub organization, start a company or nonprofit, populate org data, add an
  org profile, set up .github, github.io, an Antora docs hub, pick a bootstrap
  profile, or wants a fast-path org/business bootstrap.
---

# Bootstrap a new organization

**Fast path** for GitHub (or peer forge) **identity + public surface**. It is not a substitute for Business Bootstrap literature (email, vault, chat, funding, IaC). Hand those areas off when this session reaches them.

Do **not** invent a banner, legal entity, or domain. **Load a profile first** (named, attached, or pasted SDL). Poll only what the profile and prompt still leave open.

Deep commands, skip-unless table, SDL schema, and pitfalls: [reference.md](reference.md). Profiles: [profiles/catalog.sdl](profiles/catalog.sdl).

## Load a profile

Before Intake, resolve **one** profile. Overlay: catalog `defaults` → named/pasted profile → explicit prompt overrides (prompt wins).

1. **Named in the prompt** (`oss-collective`, `product-org`, `nonprofit`, `web-app`, `docs-hub`, `forks-org`, or “use the product-org profile”) → read `profiles/<name>.sdl`.
2. **Attached / `@`-mentioned `.sdl` file** → read that file. If it has no `profile "…"` wrapper, treat the body as overlays on `defaults`.
3. **Inline SDL** in the prompt (`profile "…" { … }` or a `defaults { }` + tags) → parse and overlay; do not require saving it unless they ask.
4. **None of the above** → AskQuestion (or list) the catalog names. Do not start scaffolding until they pick one **or** say “defaults only” (catalog `defaults`, `oss-collective` session scope).

House site/docs unless the profile overrides: **SolidStart** (`ssr` false, `preset` `"static"`) + **solid-ui** + Tailwind, **pnpm**, **dprint**, allow-list gitignore, **Antora + Valentus v2**, GitHub Pages, Cloudflare **dns-only** in front of github.io. Do not re-poll the framework after a profile loaded.

Announce the loaded profile name and the skip/session_scope tags in one short line, then continue.

## Intake (poll first)

Batch remaining questions (AskQuestion when available). Skip items the profile already set.

**Must know** (not in SDL profiles)

- Org login / slug (or candidates) and **display name**
- One-line purpose; what is **in** vs **out** of this org
- Empty org already created in the UI, or still deciding

**Ask when missing and not skipped by the profile**

- Custom domain bought / verified? (else github.io)
- Sibling / partner orgs to cross-link (do not absorb)
- Repos to transfer vs leave
- Auth/login this session? (`web-app` then Netlify overlay)
- Legal entity needed *this session*? Profile default is no

Forge and stacks come from the profile. Session scope comes from the profile unless they widen/narrow it.

## Gate — should this be a new org?

A new org pays off when there is a **name that belongs on a landing page**, roughly **3–5 projects** they would ship under that banner, and a reason outsiders follow the **org** not the person.

Otherwise keep work on the personal account (topics, lists). Do not fold a sharp sibling org into a vague umbrella. Aligned peers: **cross-link, do not absorb**.

If the gate fails, stop after saying so. If it passes, proceed.

## Stance

- User often **creates the empty org in the GitHub UI**. Populate; do not block on automating org creation (`gh` cannot fully replace that UI).
- Copy is for **visitors**, not the maintainer or the agent. Philosophy and “division of labor” live on the **site/docs**, not as agent notes on the profile.
- **Minimal profile.** Settings + website already hold name, URL, and notable repos. Do not restack those on `profile/README.md`.
- **Allow-list gitignore** (`*` then `!path`). Update it when adding files. Never allow-list `MEMORIES.md`.
- Changelogs, About descriptions, and README hub links belong on new repos.
- **Do not commit or push unless asked.**
- UI-bound: org creation, avatar upload, enabling Pages the first time, buying/verifying a domain, Cloudflare dashboard clicks.

## Phases

Copy the checklist and tick as you go. **Skip** phases the session scope and [reference.md](reference.md) skip-unless table exclude.

```
Org bootstrap:
- [ ] 0 Profile + intake + gate
- [ ] 1 Org identity (About / website / location)
- [ ] 2 Logo + 256px avatar asset
- [ ] 3 Public .github profile
- [ ] 4 Public website
- [ ] 5 Docs hub (one per org)
- [ ] 6 News vs blog (split)
- [ ] 7 Partners, transfers, personal-hub update
- [ ] 8 Domain / email / infra (hand off — optional)
```

### 1. Identity

`gh api user` then `gh api orgs/{org}`. PATCH name, description, `blog` (public **site** URL — not docs, not github.com), company, location.

After repos exist: per-repo About + homepage (`gh repo edit`). Website field on the **org** is the public site.

### 2. Brand

SVG mark in `.github` (and later site/docs). Export a **256×256 PNG** for Settings → General avatar (user uploads). Harbor the SVG in org-wide repos; copy into profile assets, favicon, docs UI.

If a logo already exists, copy all variants — do not redesign unless asked.

### 3. Public `.github` profile

Create **`{org}/.github` as a public repo**. GitHub renders only `profile/README.md` (Markdown). Repo-root `README.md` is for maintainers.

Settled profile recipe:

1. Centered logo
2. Horizontal rule
3. 1–3 centered pitch lines (**no** H1 restating the org name)
4. Optional short affiliation / sibling line
5. Nothing that duplicates Settings or the website nav (no “Start here”, no notable-repo lists, no second copy of site/news/docs URLs unless the site does not exist yet)

`.github-private` only when **member-only text actually differs**. Same copy → do not keep a private profile.

Optional in `.github`: `workflow-templates/` only if they will publish org starters; changelog on bootstrap.

### 4. Public website

| Situation | Default |
| --- | --- |
| No custom domain | `{org}.github.io` |
| Domain bought + TXT verified | CNAME in the Pages repo; DNS **grey-cloud** (not proxied) in front of github.io |
| Canonical site already exists elsewhere | Do **not** invent a competing homepage; optional stub only |
| Product vs org | Separate product hostname from org hub when both exist |

Use the loaded profile’s `site { }` (SolidStart static + solid-ui unless overridden). Wire prominent **Explore the docs »** once a docs hub exists. After org birth, update the **personal** hub/org list if they have one.

### 5. Docs hub

**One public docs site per org.** Product repos contribute `docs/`; they do not each publish a second public docs site.

Use the loaded profile’s `docs { }`. House default is one Antora hub (`{org}/docs`) with Valentus **v2** (not a stray `2.0.0` tag). Playbook start paths must exist on each source’s default branch.

Private sources cannot be cloned with `GITHUB_TOKEN` from another repo — need a PAT / org token.

### 6. News vs blog

Do not mix.

| Lane | Use |
| --- | --- |
| **News** | Dated org chronicle, hello-world, ship notes |
| **Blog / essays** | Stance, philosophy, inward writing |

First news item may be a hello-world. Philosophy is **not** a news article and **not** the GitHub profile. Skip an empty news section.

When drafting those bodies, use skills `writing-news` / `writing-blog` if installed.

### 7. Partners and transfers

Transfer with `gh api` (see [reference.md](reference.md)). Hive paths: `$CODE_ROOT/<host>/<owner>/<repo>`; forks → `.forks/`; clones → `.clones/`. Update remotes, About homepages, personal hub, sibling docs. Delete leftover **personal-account stubs** (`user/{org}`, `user/{org}-private`) that belonged on the org.

### 8. Domain, email, infra (hand off)

Stop fast-path identity work here unless the user asked for mail/DNS/IaC **in this session**.

Keep **human** vs **product** vs **marketing** mail on separate vendors/hosts. Inbound routing ≠ human SMTP ≠ app transactional API. Apex must not mix reputations.

Do not restate those procedures here. Point at Business Bootstrap (email tutorial, stage defaults, org `infra` pattern) and implement only what they confirmed.

## Done when

- Org About is filled; avatar asset exists (uploaded or waiting on user)
- Public `.github` + `profile/README.md` render (`?view_as=public`)
- Session-scoped site and/or docs exist **or** were explicitly skipped
- News/blog not conflated
- Deeper ops linked, not silently skipped as “finished”
