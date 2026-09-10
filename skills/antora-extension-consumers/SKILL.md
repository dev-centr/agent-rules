---
name: antora-extension-consumers
description: >-
  Use when updating Antora extension consumers, bumping extension pins,
  discovering dependents after a release, GitHub topics for extensions,
  antora-search-chat consumers, valentus-theme consumers, page-context
  consumers, recursive consumer fan-out, uses-antora topic rename,
  topic:antora-search-chat, SemVer git pins for antora-supplemental.
---

# Antora extension consumers

House convention for **discovering and updating** dependents of Antora extensions, themes, and compose packs under `antora-supplemental` (and owned hubs that consume them). Pair with skill **`antora-org-site`** (wiring) and **`tag-release`** (cutting tags).

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

**Discover:**

```powershell
gh search repos "topic:antora-search-chat" --json fullName,url
```

Skip the producer itself (`owner/repo` of the package you released). Fallback when topics are missing: hive `package.json` / playbook grep, then **add the missing topics**.

This naming is intentional for Antora ecosystem packages where the repo name *is* the product id. It is not a universal open-source rule for every library on GitHub.

## Git pins

Prefer **immutable SemVer tags** on git deps:

```text
github:antora-supplemental/antora-search-chat#v0.1.4
```

Rolling lines (`#v0.1`, `#v2` for UI bundles) are allowed when the product documents them (e.g. Valentus `v2` ui-bundle). Do not leave bare `github:org/repo` without a ref unless the hub explicitly floats `main` and accepts lockfile churn.

## Recursive fan-out (required)

After releasing or bumping package **P**, update consumers **recursively** — not only direct dependents.

```
queue ← [P]
visited ← ∅
while queue not empty:
  X ← dequeue
  for each consumer C of topic(X) (plus hive fallback), skip X itself:
    if C ∈ visited: continue
    visited ← visited ∪ {C}
    bump C’s pin/lockfile (or UI bundle ref) for X to the new tag/line
    ensure topic(X) on C
    changelog note when the repo keeps one
    if C is itself a consumable package (extension, theme, compose pack, publishable lib)
       AND C changed in a way dependents must pick up
       (new tag, moved rolling line, or lockfile that ships inside C’s artifact):
         cut/move tags per skill tag-release when a release is warranted
         enqueue C
```

**Leaf playbook hubs** (org `docs` repos): bump + topic + stop — they are not enqueued.

**Intermediate packages** (example: `valentus-theme` depends on `antora-search-chat`):

1. Bump the intermediate’s pin of P.
2. If the intermediate **ships** that change to *its* consumers (UI bundle, published files, compose fragment), release/retag the intermediate, then fan out to `topic:<intermediate-repo-name>`.
3. If the change is **dev-only** (demo playbook dep that does not alter the published UI bundle), still bump + topic the intermediate; **do not** enqueue UI-only hubs solely for that dep — unless those hubs also depend on P directly (then they appear in P’s own topic search).

Never stop after the first layer when an intermediate published artifact moved.

## Agent checklist

1. Load this skill when the user asks to update consumers, or after cutting an Antora extension/theme release.
2. Resolve **P**’s repo name → topic string; resolve new pin (`vX.Y.Z` or documented rolling line).
3. BFS fan-out per § Recursive fan-out.
4. Commit/push each consumer per `push-code` / `github-repo-access`.
5. Report: direct consumers updated, intermediates released (if any), second-hop hubs updated, topics added/fixed.

## Anti-patterns

- `uses-antora-search-chat` (or any `uses-*`) — rename to the bare repo name
- Updating only hive clones you remember and skipping topic search
- Bumping an intermediate package and skipping *its* consumers when a release/rolling tag moved
- Floating unpinned `github:org/repo` after a SemVer release without refreshing lockfiles
