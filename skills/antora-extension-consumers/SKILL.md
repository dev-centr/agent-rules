---
name: antora-extension-consumers
description: >-
  Use when Antora extension consumers, antora-supplemental dependents,
  GitHub topics for Antora extensions, antora-search-chat consumers,
  valentus-theme consumers, page-context consumers, topic:antora-search-chat,
  SemVer git pins for antora-supplemental, uses-antora topic rename,
  direct deps only, provider rule, facto-stack as provider, facto-stack compose pack topics,
  hub github topics, do not tag pack members, facto-maint, dedupe hub package.json.
update-consumers:
  when:
    - antora-supplemental
    - antora
    - antora-search-chat
    - valentus-theme
    - valentus
    - page-context
    - site-nav-tree
    - nav-typology
    - nav-typology-diataxis
    - build-stack
    - facto-stack
    - antora-dark-mode
    - antora-ai-help-extension
    - antora-unversioned-component-urls
---

# Antora extension consumers

**Specialization of** skill **`update-consumers`**. Owns Antora / `antora-supplemental` **discovery and pin** rules only. For the recursive walk, **load `update-consumers`** and apply this skill’s rules during discover/bump steps.

Also pair with **`antora-org-site`** (wiring) and **`tag-release`**.

## Topic = repo name

Consumer repos carry a GitHub **repository topic** equal to the **upstream git repo name** (not the npm scope, not a `uses-` prefix):

| Upstream repo | Topic on each consumer |
| --- | --- |
| `antora-supplemental/antora-search-chat` | `antora-search-chat` |
| `antora-supplemental/valentus-theme` | `valentus-theme` |
| `antora-supplemental/page-context` | `page-context` |
| `antora-supplemental/site-nav-tree` | `site-nav-tree` |

Same topic may also appear on the **producer** repo (identity). That is fine.

**When wiring** a **direct** extension/theme into a playbook or package: add the topic (preserve existing topics). **Do not** invent `uses-*` topics.

## Provider rule (facto-stack owns its members)

Playbook / docs-hub repos tag the **provider they declare**, not what that provider supplies.

| Tag | Do not tag (provided by facto-stack) |
| --- | --- |
| `facto-stack` (the hub declares the pack) | Pack members: `page-context`, `site-nav-tree`, `soft-nav-page-toc`, `nav-typology(-diataxis)`, `link-validator`, `linkinator`, `page-edit`, `antora-search-chat`, `build-stack`, `extension-lister`, `orphan-finder`, `unversioned-component-urls` |
| Non-pack extension the hub genuinely `require`s (rare; say why in the hub changelog) | Maint CLIs (`orphan-finder`, `nav-drift`, `stale-page`, `playbook-pin-auditor`, `deep-link-contracts`) — run via `facto-maint` |
| `ui.bundle.url` theme **when no compose pack is used** | `valentus-theme` on a facto-stack hub — the bundle is the pack's paired theme, not a pin |

* **Hub on facto-stack → topic `facto-stack` only.** Hub `package.json` declares `facto-stack` + `antora` (+ local tooling), not members. `supplemental-ui` files are hub-owned copies, not pins.
* Theme-only hub (Valentus, no pack) → `valentus-theme`.
* `facto-stack` does not own the UI bundle: Valentus is a release asset named by the playbook's `ui.bundle.url`, not an npm dependency of the pack.
* `soft-nav-page-toc` (pack extension, build-time) ≠ hub `supplemental-ui/js/soft-nav.js` (browser SoftNav script, hub-owned). Neither is a reason to tag.
* When bumping extension **X**: `topic:X` finds repos that **directly** depend on X; facto-stack hubs are reached via `topic:facto-stack` + a pack release that bumps X.
* Retag with the full list: `$body = @{ names = @('facto-stack') } | ConvertTo-Json -Compress; $body | gh api -X PUT repos/OWNER/REPO/topics --input -` (read current topics first and keep unrelated ones).

Docs: antora-supplemental/docs `hub-github-topics.adoc`; registry contributing (*Provider rule*).

**Discover (for `update-consumers`):**

```powershell
gh search repos "topic:<repo-name>" --json fullName,url
```

Skip the producer itself. Fallback: hive `package.json` / playbook grep, then **add the missing topics**.

This naming fits Antora ecosystem packages where the repo name *is* the product id — not a universal rule for every GitHub library.

## Git pins

Prefer **immutable SemVer tags** on git deps:

```text
github:antora-supplemental/antora-search-chat#v0.1.4
```

Rolling lines (`#v0.1`, `#v2` for UI bundles) are allowed when the product documents them (e.g. Valentus `v2` ui-bundle). Do not leave bare `github:org/repo` without a ref unless the hub explicitly floats `main` and accepts lockfile churn.

## How this plugs into fan-out

When `update-consumers` matches this specialization:

1. **Discover** X’s consumers via `topic:<X-repo-name>` (+ hive fallback).
2. **Bump** pins to the SemVer/rolling ref this product documents.
3. **Ensure** topic `<X-repo-name>` on each **direct** consumer (remove the topic from hubs that only get X through facto-stack; bump the pack instead).
4. **Enqueue** intermediates only when their **published** artifact moves (Valentus UI bundle, compose fragment, etc.). Dev-only demo deps inside a theme: bump the theme repo, do not fan out UI-only hubs unless they also depend on X directly.

## Anti-patterns

- `uses-antora-search-chat` (or any `uses-*`) — rename to the bare repo name
- Duplicating the BFS algorithm here instead of loading `update-consumers`
- Updating only remembered hive clones and skipping topic search
- Tagging pack-provided members (or `valentus-theme`) on facto-stack hub playbooks (pollutes `topic:<extension>` search)
- Pinning members in a facto-stack hub `package.json` just to get a `.bin` or to override a version — bump the pack (or use `facto-maint`)
