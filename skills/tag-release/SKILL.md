---
name: tag-release
description: >-
  Cut version tags and GitHub/registry releases using SemVer, optional +build
  metadata that decouples the app/lib number from engine/dep numbering, and
  platform-specific rolling channels. Use when the user asks to tag a release,
  ship a version, cut vX.Y.Z, update rolling v2/v2.x, publish GitHub Releases,
  or choose how consumers pin vs float.
---

# Tag a release

**One skill, strategy files — not a router and not per-platform skills.** GitHub vs npm/DUB is the same job (cut a version) with a different channel. Discovery stays one description; read a sibling only when that surface is in play.

- GitHub (Actions `uses:`, zip/download URLs, GitHub Releases): [github.md](github.md)
- Registries that resolve ranges (`^2`, `~>2.0`, Cargo, PyPI, DUB): [registries.md](registries.md)
- After DUB git tags, if they also asked to publish to code.dlang.org: skill `publish-to-dub`

Do **not** invent tags. If they asked only to merge, register, or document, skip tagging.

House example of dual-axis labels + moving GitHub line tags: Valentus Theme (`2.0.0+antora.3`, rolling `v2`).

## Checklist

```
- [ ] User asked to ship/tag (not implied)
- [ ] Surfaces: git, GitHub Releases/Actions, npm, DUB, PyPI, Cargo, other
- [ ] Schema: immutable SemVer + (+label? GitHub rolling aliases? registry ranges?)
- [ ] VERSION / changelog / About --version agree
- [ ] Immutable tag vX.Y.Z pushed
- [ ] Public label X.Y.Z+dep.N where a dep axis exists
- [ ] GitHub rolling vX / vX.Y moved if that platform is a pin path
- [ ] Registry publish / refresh only if they asked
```

## +tags (required when possible)

Always use +tags where possible to allow users to subscribe to a version and inherit any dependency updates, as well as decoupling the app/lib version numbering from the dep numbering.

`+` is **SemVer build metadata** (`1.2.3+antora.3`). It is a second axis, not a fourth SemVer number.

| Do | Do not |
| --- | --- |
| Bump **product** MAJOR/MINOR/PATCH for the product's own contract | Bump product major because a bundled engine/framework/peer major moved |
| Encode the peer as `+name.N` (or `+name.X.Y`) on the **public label** | Fold Antora 4 into "Valentus 4" when Valentus chrome did not break |
| Let rolling channels / registry ranges deliver dep rebuilds | Require every consumer to edit a pin when only the peer moved |

**Skip `+` when it is not carrying an independent axis:** a standalone app or library with no separately versioned engine, framework, runner, or bundled peer. Do not invent `+1` / `+build.1` as a substitute for PATCH.

**Git tag vs public label.** Default git/download tag is **pure SemVer** (`v1.2.3`). Put `+dep.N` on the GitHub Release **title**, changelog, and docs. A second annotated tag `v1.2.3+dep.N` is optional discoverability only — it must **not** trigger release workflows. `+` in the download tag breaks GitHub asset URLs and simple `vX.Y.Z` glob triggers.

## Schemas — when to use which

| Schema | Use when | Skip when |
| --- | --- | --- |
| **Immutable SemVer** `vX.Y.Z` | Every ship. Source of truth for git, CI, registries, exact pins. | Never. |
| **Dual-axis label** `X.Y.Z+dep.N` | Product version and a peer/engine/framework major are independent. | No such peer. Registry forbids `+` on the **published** version (still use the label on GitHub/changelog). |
| **GitHub rolling alias** `vX` and/or `vX.Y` | Consumers pin through GitHub: Actions `@v2`, `releases/download/v2/...`. GitHub does **not** compute `^2` / `latest-2`. Create a **separate** release named `2` / `2.x` (tag `v2` / `v2.0`) and **update it continuously**. | Nobody installs from GitHub tags/URLs; a registry already resolves ranges. |
| **Registry range** `^2.0.0`, `~>2.0`, `~2.0.0` | npm, DUB, Cargo, PyPI, NuGet — the platform calculates rolling. | GitHub zip URLs and `uses:` (no range parser). |
| **Latest across majors** (`releases/latest`, npm `latest`) | They explicitly want every major. | Default production pin. Crossing a major is a migration. |

**Pin vs float (consumers you document):**

- Float a **major line** (`v2`, `^2.0.0`) — inherit patches **and** minors in that major, plus `+dep` rebuilds that keep product MAJOR.
- Float a **minor line** (`v2.0`, `~2.0.0`) — inherit patches only.
- Pin **exact** (`v2.0.12`) — bitwise CI; they opt in to each move.

Recommended default for GitHub-consumed artifacts: document rolling **major** `v2`. For registries: document `^` or `~>` on the current major.

## Bump the immutable tag

From commits since the last `vX.Y.Z`:

1. **MAJOR** — breaking product/API/chrome contract.
2. **MINOR** — additive, backward compatible.
3. **PATCH** — fix; no contract change. Also a **new artifact** that only rebuilds against a peer (registries ignore `+`, so they need a new PATCH). Update the `+dep.N` label. Do **not** bump product MAJOR solely because the peer major moved.
4. Never retag a shipped `vX.Y.Z`. Consumers on rolling `v2` / `^2` inherit the new PATCH without changing their pin.

Prerelease (`v1.2.3-rc.1`): only when they asked for a pre. Do not use GitHub's **prerelease** checkbox on the immutable tag unless it is actually a pre; reserve that checkbox for **rolling aliases** (see [github.md](github.md)).

## Procedure

1. Read repo `AGENTS.md`, existing tags (`git tag -l "v*"`), changelog, `package.json` / `dub.sdl` / Cargo version.
2. Pick the next `X.Y.Z` and, if a peer axis exists, the public label `X.Y.Z+name.N`.
3. Stamp version files + changelog **before** the tag (match repo style). About / `--version` / CI `RELEASE_TAG` stay one truth (skill `ship-app`).
4. Commit if they asked to ship (do not tag dirty trees).
5. Annotated tag; push **that tag**:

```powershell
git tag -a "v$Version" -m "$Label"
git push origin "v$Version"
```

6. If GitHub Releases or Actions consumers exist → [github.md](github.md) (immutable release, then move `vX` / `vX.Y`).
7. If a range-resolving registry is the install path → [registries.md](registries.md).
8. Report: immutable tag URL, public label, which rolling aliases moved, registry URL if any.

## Do not

- Move or retag an immutable `vX.Y.Z` after consumers could have fetched it
- Force-push `main` / `master` as part of tagging
- Treat GitHub `releases/latest` as a substitute for `v2`
- Put `+` in workflow `on.push.tags` globs that would fire twice
- Paste this skill into always-on User Rules
