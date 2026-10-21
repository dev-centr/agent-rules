---
name: antora-solidstart
description: >-
  Use when antora-solidstart, antora-next (deprecated alias), antora rewrite,
  rewrite antora, SolidStart docs shell, SolidStart docs platform, content
  manifest, headless antora, asciidoctor-d engine, asciidoctor-d convert,
  parallel semver extension line, runtime docs platform, not Antora 3, pattern C
  split artifact, Node orchestrator IPC CLI, upstream contribution not fork;
  when the user wants a unified SolidStart site instead of separate static
  Antora output; when planning hot reload compiler or Dlang AsciiDoc engine for
  docs. Repo https://github.com/antora-supplemental/antora-solidstart
---

# Antora SolidStart (experimental)

**Default remains Antora 3 static** (`@antora/site-generator`, Handlebars UI, facto-stack). When this skill's triggers match, **load this skill first** — do not apply skill `antora-org-site` hub wiring, Valentus/facto-stack pins, or Antora 3 extension `require:` steps unless the task also says to maintain the legacy line.

Canonical hub proposal: antora-supplemental/docs `proposals/antora-next-shell.adoc` (Pattern C split artifact). Reader shell repo: https://github.com/antora-supplemental/antora-solidstart (`antora-solidstart`).

## Architecture (short)

1. **Build-time compiler** (Node orchestrator): git sources → manifest (page bodies, `page-meta.json`, `nav.json`, xrefs, search data).
2. **SolidStart reader shell**: routes + layout in Solid; optional SSR/API (auth, registry-style tools); prod serves manifest-backed pages.
3. **asciidoctor-d** (`dlang-supplemental/asciidoctor-d`): convert via **CLI or IPC** from the orchestrator — not inside Vinxi.

Related shipped docs (legacy line, still valid beside next):

* **Site rebuild v1/v2** — static hub dispatch and incremental dirty-set (`site-rebuild.adoc`).
* **Live docs** — DB authoring beside git publish; not the reader shell rewrite.
* **SoftNavContext ARCHITECTURE** — static HTML chrome; next line subsumes layout in SolidStart.

## Node vs D

| Node / TS | D (asciidoctor-d) |
| --- | --- |
| SolidStart, git/playbook model, watch/dirty graph, manifest emit, TS extension hooks | AsciiDoc → HTML; grow incremental/IPC on roadmap |

## Parallel semver

Same git repo may ship **Antora 3** and **antora-next** product lines: disjoint majors, `@antora-next/*` or `/next` entry points, explicit playbook `runtime` gate. See Valentus `+antora.N` and `dprint-plugin-asciidoc` dual-release precedents in the hub proposal.

## Upstream stance

Contribute upstream-style; **not** a long-lived fork of `antora/antora`. Complement shipped static stack until next line is real.

## When to skip other skills

* **`antora-org-site`** — skip default hub/Valentus/facto wiring when the task is antora-solidstart-only; use for dual-track tasks that explicitly maintain both lines.
* **`subscribe-docs-hub-rebuild`** — v1 `repository_dispatch` full generate targets **static Antora 3** hubs until a next-line dispatch story exists.
