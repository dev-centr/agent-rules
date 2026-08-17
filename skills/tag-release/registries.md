# Package registries (range rolling)

npm, DUB, Cargo, PyPI, and NuGet **compute** "latest matching 2.x" from published versions. Do **not** publish a fake `2.x` / `v2` version on the registry — that is the GitHub workaround in [github.md](github.md).

Cut the immutable `vX.Y.Z` tag first ([SKILL.md](SKILL.md)). Then publish or refresh if the user asked.

## + on the registry version

Prefer **`+` on the GitHub/changelog label** even when the registry version must stay pure SemVer.

| Registry | `+` on the published version | Rolling without GitHub aliases |
| --- | --- | --- |
| **npm** | Avoid. Two publishes that differ only in build metadata are not a reliable line; use a new PATCH when you need a newer tarball. Dist-tags (`latest`, `next`) are extra floats, not `^2`. | `^2.0.0` (minor+patch), `~2.0.0` (patch). |
| **DUB** | Tags the registry indexes should be `vX.Y.Z`. Do not rely on `+` for precedence. After tags: skill `publish-to-dub` (`dubx update`). | Recipe version + `~>2.0.0` / `>=2.0.0 <3.0.0` in dependents. |
| **Cargo** | Build metadata is **ignored for uniqueness** — you cannot publish `1.2.3+foo` as a second crate version. Bump PATCH. | `cargo` semver reqs (`^2.0`, `~2.0`). |
| **PyPI** | **No.** PEP 440 *local* (`1.2.3+foo`) **cannot** be uploaded. Keep `+` off `setup`/`pyproject` version. | Compatible release `~=2.0.12` or `>=2.0,<3`. |
| **NuGet** | No SemVer build metadata in the package id/version you push. PATCH bump. | `[2.0,3.0)` / floating in `Directory.Packages.props`. |

**Still use `+` on GitHub Release titles and the changelog** when a peer/engine axis exists. That is how consumers subscribe to the *product* line and still see the *dep* axis.

## When a registry is enough (skip GitHub rolling)

Skip moving `v2` / `v2.0` when:

- Install is only `npm i`, `dub add`, `cargo add`, `pip install`
- CI pins the registry, not `actions/checkout` of this repo and not `releases/download`

Keep GitHub rolling if **any** documented install path is a GitHub URL or `uses: this/repo@…`.

## Dist-tags vs SemVer ranges (npm)

- `npm dist-tag latest` ≈ GitHub `releases/latest` (crosses majors when you publish one).
- Do not use dist-tag `v2` as a substitute for `^2.0.0` unless you maintain it by hand (then you are back to the GitHub "move an alias" strategy — cheaper to let the registry resolve `^`).

## After publish

- Confirm the version appears (`npm view`, `dubx status`, crates.io, PyPI).
- DUB: registry poll is slow; `dubx update -n <pkg>` if they asked to publish.
- Dependent install docs: show **range** (`^2` / `~>2.0`) as the default, exact pin as the reproducibility option — matching SKILL.md consumer table.
