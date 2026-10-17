---
name: docs-hub-link-invalidate
description: >-
  Use when wiring repository_dispatch link-cache-invalidate, docs hub surgical
  link validator cache invalidation, LINK_VALIDATOR_INVALIDATE_SOURCES,
  LINK_VALIDATOR_INVALIDATE_URLS, aggregator hub notify, multi-repo Antora
  star topology, DOCS_HUB_DISPATCH_TOKEN, extension-updated sibling pattern,
  dev-centr/docs deploy, content source poke hub after docs/** push.
---

# Docs hub link-cache invalidation

Star topology: **content repos dispatch → org hub rebuilds** with optional surgical link-check bypass. Same family as `docs-source-updated` / `extension-updated`; hub is always `dev-centr/docs` unless `hub_repo` is overridden.

## When to dispatch

* After merging changes under `docs/**` (or other paths that affect outbound links) in a playbook **content source** repo.
* When you know specific **source pages** or **URLs** must be live-rechecked without a full cache bypass (`LINK_VALIDATOR_CACHE_BYPASS`).

Do **not** embed tokens in playbooks or static site output.

## Hub contract (subscriber)

Repo: `dev-centr/docs` — workflow `.github/workflows/deploy.yml`.

| Payload field | Hub build env / behavior |
| --- | --- |
| `sources` | `LINK_VALIDATOR_INVALIDATE_SOURCES` (string or JSON array → comma-separated) |
| `urls` | `LINK_VALIDATOR_INVALIDATE_URLS` |
| `ref` | Checkout ref (default `main`) |
| `source`, `sha` | Caller identity (logging) |

Event type: **`link-cache-invalidate`**.

Hub doc (published): https://docs.devcentr.org/docs-site/notify-docs-hub-link-changes.html — source `dev-centr/docs` `docs-site/notify-docs-hub-link-changes.adoc`.

Link-validator env reference: https://github.com/antora-supplemental/asciidoc-link-validator (v0.2.2+).

## Org secret

Store **`DOCS_HUB_DISPATCH_TOKEN`** at org (or repo) level: fine-grained PAT or GitHub App installation token with permission to create `repository_dispatch` on the hub repo (`actions: write` on `dev-centr/docs` or equivalent).

## Reusable workflow (caller)

Path: `dev-centr/agent-rules/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml`

```yaml
jobs:
  notify:
    uses: dev-centr/agent-rules/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml@main
    secrets:
      DOCS_HUB_DISPATCH_TOKEN: ${{ secrets.DOCS_HUB_DISPATCH_TOKEN }}
    with:
      sources: '' # optional comma-separated paths or page ids
      urls: ''
      hub_repo: dev-centr/docs
      ref: main
```

Exemplar caller: `dev-centr/agent-rules/.github/workflows/notify-docs-hub-link-invalidate.yml` (push `docs/**`, `skills/**` on `main`).

## Agent one-liner (preferred when already pushing)

```shell
gh api repos/dev-centr/docs/dispatches \
  -f event_type=link-cache-invalidate \
  -f client_payload[source]=OWNER/REPO \
  -f client_payload[ref]=main \
  -f client_payload[sha]=$(git rev-parse HEAD) \
  -f client_payload[sources]=path/or/page.adoc
```

## Related skills

* `antora-org-site` — hub playbook wiring, `repository_dispatch` refresh
* `antora-extension-consumers` — bump link-validator pins on release
