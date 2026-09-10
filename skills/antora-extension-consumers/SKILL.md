---
name: antora-extension-consumers
description: >-
  Use when Antora extension consumers, antora-supplemental dependents,
  GitHub topics for Antora extensions, antora-search-chat consumers,
  valentus-theme consumers, page-context consumers, topic:antora-search-chat,
  SemVer git pins for antora-supplemental, uses-antora topic rename.
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
    - antora-facto
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

**When wiring** an extension/theme into a playbook or package: add the topic (preserve existing topics). **Do not** invent `uses-*` topics.

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
3. **Ensure** topic `<X-repo-name>` on each consumer.
4. **Enqueue** intermediates only when their **published** artifact moves (Valentus UI bundle, compose fragment, etc.). Dev-only demo deps inside a theme: bump the theme repo, do not fan out UI-only hubs unless they also depend on X directly.

## Anti-patterns

- `uses-antora-search-chat` (or any `uses-*`) — rename to the bare repo name
- Duplicating the BFS algorithm here instead of loading `update-consumers`
- Updating only remembered hive clones and skipping topic search
