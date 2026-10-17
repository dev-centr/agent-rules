---
name: docs-hub-link-invalidate
description: >-
  Use when wiring repository_dispatch link-cache-invalidate, docs hub surgical
  link validator cache invalidation, LINK_VALIDATOR_INVALIDATE_SOURCES,
  LINK_VALIDATOR_INVALIDATE_URLS, aggregator hub notify, multi-repo Antora
  star topology, DOCS_HUB_DISPATCH_TOKEN, extension-updated sibling pattern,
  dev-centr/docs, dlang-supplemental/docs, antora-supplemental/docs deploy,
  content source poke hub after docs/** push.
---

# Docs hub link-cache invalidation

Star topology: **content repos dispatch → org hub rebuilds** with optional surgical link-check bypass. Same family as `docs-source-updated` / `extension-updated`.

## Multi-hub registry (Ryan production aggregators)

| Org | Hub repo | Live site | Org secret | Reusable caller workflow | Hub how-to (source) | Exemplar content caller |
| --- | --- | --- | --- | --- | --- | --- |
| dev-centr | `dev-centr/docs` | https://docs.devcentr.org | `DOCS_HUB_DISPATCH_TOKEN` | `dev-centr/.github/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml@main` (also `dev-centr/agent-rules/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml@main`) | `docs-site/notify-docs-hub-link-changes.adoc` | `dev-centr/agent-rules` (`notify-docs-hub-link-invalidate.yml`) |
| dlang-supplemental | `dlang-supplemental/docs` | https://dlang-supplemental.github.io/docs | `DOCS_HUB_DISPATCH_TOKEN` | `dlang-supplemental/.github/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml@main` | `notify-docs-hub-link-changes.adoc` | `dlang-supplemental/asciidoctor-d` |
| antora-supplemental | `antora-supplemental/docs` | https://docs.antora-supplemental.org | `DOCS_HUB_DISPATCH_TOKEN` | `antora-supplemental/.github/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml@main` | `notify-docs-hub-link-changes.adoc` | `antora-supplemental/asciidoc-interactive` |

Override `hub_repo` in the reusable workflow when testing a fork. Link-validator surgical env requires `@antora-supplemental/link-validator` **v0.2.2+** (direct pin or pnpm override through Facto stack).

## When to dispatch

* After merging changes under `docs/**` (or other paths that affect outbound links) in a playbook **content source** repo.
* When you know specific **source pages** or **URLs** must be live-rechecked without a full cache bypass (`LINK_VALIDATOR_CACHE_BYPASS`).

Do **not** embed tokens in playbooks or static site output.

## Hub contract (subscriber)

Each hub workflow `.github/workflows/deploy.yml` listens for **`link-cache-invalidate`**.

| Payload field | Hub build env / behavior |
| --- | --- |
| `sources` | `LINK_VALIDATOR_INVALIDATE_SOURCES` (string or JSON array → comma-separated) |
| `urls` | `LINK_VALIDATOR_INVALIDATE_URLS` |
| `ref` | Checkout ref (default `main`) |
| `source`, `sha` | Caller identity (logging) |

Link-validator env reference: https://github.com/antora-supplemental/asciidoc-link-validator (v0.2.2+).

Cross-hub narrative: https://docs.antora-supplemental.org/antora-deployment/#auto-rebuild-when-content-sources-or-extensions-update

## Org secret (checklist)

**One secret name, one token per org** — always **`DOCS_HUB_DISPATCH_TOKEN`**. Do not share one PAT across orgs; each org’s value must only dispatch into that org’s hub (see multi-hub table).

| Org | Token must dispatch into |
| --- | --- |
| dev-centr | `dev-centr/docs` |
| dlang-supplemental | `dlang-supplemental/docs` |
| antora-supplemental | `antora-supplemental/docs` |

Store at **organization** level (content repos inherit). Fine-grained PAT or GitHub App installation token with `repository_dispatch` on the hub repo. Reusable workflows use `secrets.DOCS_HUB_DISPATCH_TOKEN`; when unset, callers log and skip (exit 0) until admins configure the org secret.

## Reusable workflow (caller)

Pick the row for the org (defaults match that org's hub):

```yaml
jobs:
  notify:
    uses: ORG/.github/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml@main
    secrets:
      DOCS_HUB_DISPATCH_TOKEN: ${{ secrets.DOCS_HUB_DISPATCH_TOKEN }}
    with:
      sources: '' # optional comma-separated paths or page ids
      urls: ''
      ref: main
```

Dev-Centr agent-rules copy (same contract, default `dev-centr/docs`):

`dev-centr/agent-rules/.github/workflows/docs-hub-link-cache-invalidate-dispatch.yml`

## Agent one-liner (preferred when already pushing)

Replace `OWNER/docs` with the hub repo from the table:

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
