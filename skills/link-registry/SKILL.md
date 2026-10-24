---
name: link-registry
description: >-
  Use when an external URL repeats across AsciiDoc or Antora pages, link registry,
  named links, {url-...} attributes, url- attribute, links:check, links:fix,
  link-registry check, literal URL rejected in CI, registered link error,
  link-registry-changes.adoc, linkRegistry pack key, outbound link index,
  _/link-registry/index.json, which pages use this link, docs CI gate job,
  sparse-checkout links job, needs: links, seeding a registry for a docs repo.
---

# Link registry

Tool: `antora-supplemental/link-registry` (CLI + composite action + reusable workflow + Antora extension). Docs: https://antora-supplemental.github.io/docs/link-registry/index.html

## Rules

1. **Register shared outside links once.** Any external URL used on 2+ pages gets a memorable attribute name with the `url-` prefix (`url-stripe-billing`, not `url-1`). Write `{url-name}[text]` in pages, never the literal.
2. **Where the registry lives.** Multi-repo hub component: its `docs/antora.yml` `asciidoc.attributes` (travels with the component; scoped to it). Single-repo site: playbook `asciidoc.attributes`, or `docs/link-registry.adoc` registered through the extension `registry:` option / Facto pack key `linkRegistry: { registry: ./docs/link-registry.adoc }`. Point `package.json` `linkRegistry.registry` at the same file.
3. **CI gate = its own first job.** Trigger on `push` (every branch, `main` included) **and** `pull_request`. The `links` job uses `antora-supplemental/link-registry/.github/workflows/check.yml@v0` (sparse checkout of `.adoc`/attribute files, no `pnpm install`). `build` has `needs: links`; `deploy` has `needs: build`. A failing scan must stop the Antora build and Pages deploy from starting. Template: facto-stack `examples/workflows/build-and-deploy.yml`.
4. **CI never auto-fixes.** It fails with a teaching message naming the attribute. Authors run `pnpm links:fix` (rewrites literals, logs to `docs/link-registry-changes.adoc`, separate from the changelog) or edit by hand.
5. **Scripts:** `links:check` = `link-registry check`, `links:fix` = `link-registry fix`. Optional pre-commit hook (`link-registry hook install`, or a lefthook command `link-registry check --staged`); `git commit --no-verify` is the escape hatch. With a global `core.hooksPath` (encoding guard) the installer refuses; use the hooks repo or lefthook.
6. **Seeding an existing repo:** `pnpm exec link-registry suggest --min 2 --write <registry.adoc>`, rename the proposals to memorable names, then `pnpm links:fix`; review the diff.
7. **Deliberate literals** (explaining an old URL): put `// link-registry: ignore-next-line` above the line. Listing/literal blocks are skipped by default.
8. **Docs of link-registry-using repos must pass their own check** before push.

## Agent notes

- The CLI has zero dependencies; the action runs the runner's Node. Don't add an install step to the `links` job.
- The JSON index (`_/link-registry/index.json`) is the data source for the planned Linkinator "which pages use this link" button; don't invent a second index.
