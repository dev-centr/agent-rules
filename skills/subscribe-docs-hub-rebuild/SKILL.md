---
name: subscribe-docs-hub-rebuild
description: >-
  Use when wiring a new Antora docs hub or playbook that depends on
  antora-supplemental extensions, themes, compose packs, or remote content
  sources; subscribe docs hub to repository_dispatch; docs-source-updated;
  extension-updated; notify-docs-hub.yml; notify-docs-hub-extension.yml;
  DOCS_DISPATCH_TOKEN; deploy.yml listener; hub rebuild poke; site-rebuild v1;
  antora-github-deploy-template; scaffold hub CI without update-consumers fan-out.
---

# Subscribe docs hub rebuild signals (v1)

Star topology: **sources poke the hub** → hub runs a full Antora generate → Pages. No polling, no subscriber UUID registry. Architecture narrative: antora-supplemental/docs `site-rebuild.adoc` (v1).

## When to load

* **New hub or playbook** in `{org}/docs` (or greenfield from `antora-github-deploy-template`) that aggregates content sources and/or `@antora-supplemental/*` UI.
* **Adding** a new `content.sources` entry or wiring another extension/theme/pack the hub consumes.
* **Fixing** a hub that only rebuilds on `push` to `main` (component pushes never refresh the public site).

Pair with skill **`antora-org-site`** for playbook layout; pair with **`antora-extension-consumers`** for GitHub `topic:*` pins and provider/facto-stack rules only — not for dispatch wiring.

## Subscriber side (required on the hub)

The **Antora playbook repo** (`{org}/docs`) must listen on its deploy workflow.

### Event types

| Type | Meaning |
| --- | --- |
| `docs-source-updated` | A playbook content source pushed docs |
| `extension-updated` | Theme, UI bundle, extension, or compose pack changed |
| `link-cache-invalidate` | Optional surgical link-validator invalidation (skill **`docs-hub-link-invalidate`**) |

### Workflow `on:` block

Add `repository_dispatch` beside existing `push`, `workflow_dispatch`, and PR triggers:

```yaml
on:
  push:
    branches: [main]
  workflow_dispatch:
  repository_dispatch:
    types: [docs-source-updated, extension-updated, link-cache-invalidate]
```

### Deploy job must not be push-only

Pages deploy often gates on `github.ref == refs/heads/main`. **Also allow** `github.event_name == 'repository_dispatch'` so a poke from another repo still publishes.

Example pattern (exemplar: `antora-supplemental/docs` `.github/workflows/deploy.yml`):

```yaml
deploy:
  if: >
    github.event_name != 'pull_request' &&
    (github.ref == 'refs/heads/main' || github.event_name == 'repository_dispatch')
```

Optional: resolve `github.event.client_payload.ref` for checkout when dispatch carries a non-default branch.

### References

* Exemplar hub workflow: https://github.com/antora-supplemental/docs/blob/main/.github/workflows/deploy.yml
* Greenfield template: https://github.com/antora-supplemental/antora-github-deploy-template
* How-to prose: https://docs.antora-supplemental.org/antora-deployment/#auto-rebuild-when-content-sources-or-extensions-update

## Publisher side (optional on source/extension repos)

Automatic push → hub rebuild is **optional**. Agents and humans can always poke with `gh api repos/{org}/docs/dispatches`.

When you want CI notify:

1. Copy from https://github.com/antora-supplemental/antora-workflow-templates
   * **`notify-docs-hub.yml`** — content repos (`docs-source-updated`, usually `docs/**` paths)
   * **`notify-docs-hub-extension.yml`** — extensions/themes/packs (`extension-updated`)
2. Bulk install on many extension repos: `node scripts/install-notify-docs-hub-extension.mjs` (manifest `notify-extension-repos.json` in that repo).
3. Org (or repo) secret **`DOCS_DISPATCH_TOKEN`**: PAT or GitHub App token with permission to `repository_dispatch` on the hub. If unset, notify workflows log and exit 0 (safe for forks).

**Do not** install publisher workflows on a brand-new extension until something actually depends on it — the hub subscription is what matters at scaffold time.

Link-only surgical notify uses **`DOCS_HUB_DISPATCH_TOKEN`** and reusable dispatch workflows; see skill **`docs-hub-link-invalidate`** (same star topology, different payload).

## What this is not

| Do at scaffold / wire | Do after ship (`tag-release`) |
| --- | --- |
| Hub **`repository_dispatch`** listener | Skill **`update-consumers`** (BFS bump pins/changelogs via `topic:*`) |
| Optional notify workflows on sources | Required for **`facto-stack`** tag moves and direct git pin bumps on hubs |
| Manual `gh api …/dispatches` smoke test | Skill **`antora-extension-consumers`** for topic/pin semantics |

**`extension-updated`** triggers a full hub rebuild but **does not** change hub `package.json` / lockfile pins. Notify ≠ consumer fan-out — detail in **`antora-extension-consumers`** § Hub rebuild vs consumer pin fan-out.

**Do not** run **`update-consumers`** BFS when scaffolding a new hub or empty extension with no dependents.

## Checklist (agent)

1. Hub `deploy.yml` (or equivalent) lists all three dispatch types if the hub uses link-validator surgical mode; at minimum `docs-source-updated` and `extension-updated`.
2. Deploy job condition includes `repository_dispatch`.
3. Playbook `content.sources` and extension pins match **`antora-extension-consumers`** topics — separate skill, same hub.
4. Optionally copy notify workflows to repos that should auto-poke; confirm org secret name matches workflow (`DOCS_DISPATCH_TOKEN` for antora-workflow-templates).
5. After wiring, trigger one rebuild deliberately (`workflow_dispatch` or `gh api` dispatch) so new sources and assets go live.

## Related

* **`antora-org-site`** — one site per org, hub location, refresh overview
* **`antora-extension-consumers`** — SemVer git pins, `topic:*`, facto-stack provider rule
* **`docs-hub-link-invalidate`** — `link-cache-invalidate` payload and multi-hub table
* **`update-consumers`** — post-release dependent bumps (not scaffold)
* **`site-rebuild.adoc`** — v1 vs v2 incremental roadmap
