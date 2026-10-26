---
name: antora-registry-ready
description: >-
  Use when creating, scaffolding, releasing, renaming, or editing an Antora
  extension, Antora UI theme, UI bundle, paint, body-kit, color scheme pack,
  compose pack, or asciidoctor extension for Antora; antora-supplemental repo;
  registry.antora-supplemental.org; antora extensions registry; "add to the
  registry", "show up in the registry", "registry listing", "registry card",
  "registry detail page", antoraRegistry block, package.json antoraRegistry,
  @color-schemes, colorSchemes, scheme swatches, preview.png, registry/previews,
  GitHub topics antora-extension / antora-theme / antora-light-theme /
  antora-dark-theme / antora-paint, engines.antora, +antora.N tag, Antora 3 vs
  Antora 4 / antora-solid compatibility, catalog-sync, "why isn't my theme listed".
---

# Antora registry readiness

**Rule:** every Antora extension, theme, or paint an agent creates or touches
ships registry-ready in the same change. Do not leave it for later.
Registry: https://registry.antora-supplemental.org (repo
`antora-supplemental/antora-extensions-registry`; metadata reference
`docs/modules/ROOT/pages/registry-metadata.adoc` there).

## Checklist

- [ ] **GitHub topics** - kind (`antora-extension`, `antora-theme`, `antora-paint`,
      `antora-ui-bundle`, ...) plus `antora-light-theme` / `antora-dark-theme`
      for every mode the theme really ships. Topic = repo name rules: skill
      `antora-extension-consumers`.
- [ ] **About description** (`gh repo edit --description`) and `package.json`
      `description` say the same thing, name products in full ("Valentus theme",
      not "Valentus"), and claim only what the package bundles. Too long for a
      card: end with "(and N more features)" using the real count.
- [ ] **homepage** - repo About website and `package.json` `homepage` point at the
      live demo / docs, not the GitHub repo.
- [ ] **package.json metadata** - `name`, `version`, `license`, `repository`,
      `keywords`, and an `antoraRegistry` block: `layers` (e.g. `paint`,
      `body-kit`, `bolt-on`), `antora` (repo-default major), `previews`, and for
      themes/paints `colorSchemes` (path to the CSS holding `@color-schemes`).
- [ ] **Previews** - `preview.png` at repo root (16:10, ~1400x875, light mode
      first) plus `registry/previews/<scheme>.png` for other schemes. Real
      screenshots of the demo; never placeholders.
- [ ] **Scheme declarations** - the `@color-schemes` JSON comment (id -> label,
      slots, base) and one CSS block per scheme so swatches (canvas, accent,
      link, ink) resolve. Declare light before dark; mode slots must match the
      light/dark topics.
- [ ] **Antora compatibility** - declare it so per-release compat resolves.
      Precedence the registry uses: tag build metadata (`vX.Y.Z+antora.3`,
      `+antora-solid` = 4) > `engines.antora` > `@antora/*` peer dependency >
      `antoraRegistry.antora` repo default > undeclared. Set `engines.antora`
      and tag releases per skill `tag-release`; attach `ui-bundle.zip` to UI
      releases.
- [ ] **Package relations** - in `antoraRegistry`, declare `requires`,
      `worksWith`, `conflictsWith` as `{ "<package name | owner/repo>": "<semver>" }`
      (`requires` implies works-with). Only relations you have tested or that
      the code depends on.
- [ ] **Contracts** - `provides` / `uses` as `{ "<contract>": "<version>" }`,
      e.g. `color-scheme-tokens@0.5`, `light-dark-slots@0.1`,
      `valentus-layout-markup@4`, `default-ui-markup@2`, `antora-ui-model@3`.
      The registry marks a cross-layer chain A->B->C **guaranteed** only under
      strict layering (A's uses met by B or C at compatible versions, B's uses
      met by C, A not reaching C directly, same B range declared by both);
      otherwise **likely** with a reason. Same-layer packages are alternatives,
      never inferred compatible. Precedence: declared conflict > Antora
      mismatch > declared/curated > guaranteed > likely.
- [ ] **Sync and verify** - push, then run the registry "Sync catalog to
      database" workflow (or wait for the scheduled one) and open the live card
      and detail page: preview, swatches, Antora badges, releases table, Works with / Conflicts with.

## Do not

- Ship a theme with no preview, no topics, or a GitHub URL as homepage.
- Claim features or Antora versions the package does not declare.
- Patch registry overrides to hide bad upstream metadata - fix it at the source.
