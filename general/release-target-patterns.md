# Release target patterns

Named **build/release target sets** — which OS×CPU triplets an owned project ships by default.
Machine-readable catalog: `skills/release-targets/patterns.sdl`. Skill: `release-targets`.
Published: https://docs.devcentr.org/general-knowledge/latest/explanation/architecture/release-target-patterns.html

## Rule

1. Owned apps/CLIs **default to pattern `common`** (alias `default`) for the **current** pattern year in `patterns.sdl`.
2. GUI / desktop apps that ship a Mac binary use **`desktop`** (= `common` + `macos-arm64`) unless the user said otherwise.
3. Do not invent ad-hoc matrices when a named pattern fits — load skill `release-targets` / `polyglot-ci`.
4. When the user names a pattern with a year (`common 2025`, `common/2025`), freeze to that year’s definition — do **not** silently upgrade to the living bare name.
5. Pattern **`omnibus`** / **`all`** is unusual: every triplet in the living catalog. Ask before enabling.

## Drift (Gentoo-like dating)

Bare names (`common`, `desktop`, `lab`) always mean **latest** as defined under `current_year` in `patterns.sdl`.

Frozen citations:

| Form | Example | Meaning |
| --- | --- | --- |
| Slash | `common/2026` | Prefer in SDL, CI comments, AGENTS.md |
| Prose | “common 2026” | Chat / docs |

If `common` gains POWER in 2027, a 2025-era project that said only “default” still meant **`common/2025`** when reconstructed. Agents reconstructing old pubs must ask or use the dated form.

## Pattern names (etymology)

Names borrow from Gentoo Portage profiles (`default/linux/amd64/23.0/desktop`), Debian stability vocabulary, and plain English:

| Pattern | Also | Etymology / intent | Who for |
| --- | --- | --- | --- |
| `common` | `default` | Gentoo “default” + “what most consumers need” | Floor for every owned ship |
| `desktop` | — | Gentoo `…/desktop` overlay | GUI apps needing macOS |
| `cloud` | — | Cloud VMs / containers | Linux-only services |
| `lab` | `hpc` | Research / HPC lab benches | POWER, RISC-V, s390x + dual-ISA Linux |
| `edge` | — | Edge / SBC | arm64 + riscv Linux |
| `omnibus` | `all` | Victorian “omnibus” = carries everyone | Exhaustive catalog (rare) |
| `heritage` | — | Museum / long-tail ISA | Documented; opt-in only |

## Agent obligations

- New release workflows: expand the chosen pattern via `patterns.sdl` → GitHub `runs-on` map in skill `polyglot-ci`.
- Prefer Binary Tailor one-download packaging when the skill’s pack job applies.
- macOS Intel (`macos-x64` / `macos-13`) is **not** in any current pattern — GitHub-hosted Intel Mac is unsupported.

## Related

- Skill `polyglot-ci` — CI matrix mechanics
- Skill `tag-release` — version tags
- Skill `ship-app` — Band A installers still required on top of zip slices
- `general/end-of-run.md` — commit/push after editing patterns
