---
name: outdated-code-protocol
description: >-
  Use when Context7 is unavailable, library APIs are stale in model memory,
  AI-LOCAL-LIBRARY-DOCS.local.json5, AI-LOCAL-LIBRARY-DOCS.example.json5,
  docs/_local-library-docs, or cloning library source for Dlang API truth.
---

# Outdated code protocol

Fallback when Context7 MCP is missing or ignored. Prefer **local indexed docs or source** over web search when API accuracy matters.

## Layout

| Path | Role |
| --- | --- |
| `AI-LOCAL-LIBRARY-DOCS.example.json5` | Committed template manifest |
| `AI-LOCAL-LIBRARY-DOCS.local.json5` | Ignored machine-local manifest (loud name on purpose) |
| `docs/_local-library-docs/` | Ignored local docs or source cache |
| `scripts/` | Refresh / bootstrap clone of those docs or source repos |

Use that exact local filename unless the user asks otherwise.

## Setup

1. Add `.gitignore` entries for `AI-LOCAL-LIBRARY-DOCS.local.json5` and `docs/_local-library-docs/`.
2. Document the workflow in README/docs so humans and agents initialize it before version-sensitive dependency work.
3. Instruct agents: search local cloned docs/source **first**; web search only when local docs are missing, stale, or the wrong version.
4. **D and similar:** prefer cloning **source** (doc comments + examples + implementation).
5. Writable personal copy: **one** local clone with remotes (`origin` fork, `upstream` source) — not duplicate trees.
6. Many repos needing the same docs: shared Git cache / `git clone --reference` / `--reference-if-able` / local mirror. Do not require hardlinks or symlinks as the primary strategy.
7. If web search is the project choice instead, say so in docs and verify each dependency against upstream — do not trust model memory.

Stale APIs when Context7 **is** available: use the Context7 plugin skill; this file is the fallback.
