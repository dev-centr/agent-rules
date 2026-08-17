# GitHub (Releases, Actions, zip URLs)

GitHub does **not** resolve semver ranges and does **not** expose a computed "latest 2.x".
`releases/latest` is one repo-wide pointer and **crosses majors**.

For a rolling 2.x (or 2.0.x) line you must **create a completely separate release** (`v2` / `v2.0`) and **update it continuously** so it always points at the newest matching immutable tag.

Reference implementation: `antora-supplemental/valentus-theme` `release.yml` + `.github/scripts/post-release.mjs`.

## Two GitHub subtypes

| Consumer | What to move | Assets |
| --- | --- | --- |
| **GitHub Actions** `uses: owner/repo@v2` | Git tags `v2` and optionally `v2.Y` to the release SHA | Optional. Many actions ship from the tag tree only. |
| **Release downloads** `…/releases/download/v2/file.zip` | Git **and** a GitHub Release named `v2` / `v2.0` with the same files as `vX.Y.Z` | Required. Recreate the Release so assets bind to the new tag SHA. |

Do both when the repo has Actions *and* binaries/zips.

Rolling alias exception: moving `v2` / `v2.Y` **requires** deleting the old alias (or force-updating that tag). That is allowed **only** for these alias names. Never force-push `vX.Y.Z` or `main`.

## Immutable release (`vX.Y.Z`)

After `git push origin vX.Y.Z`:

```powershell
gh release create "v$Version" --title "$Label" --generate-notes --latest
# with assets:
# gh release create "v$Version" path\to\artifact.zip --title "$Label" --latest
```

- `--title` is the **public label** (`2.0.12+antora.3`). Tag name stays `v2.0.12`.
- `--latest` on the immutable tag only (or omit if this is an older major).
- Do **not** use `--prerelease` on a real ship.

If CI already creates the Release on tag push, do not double-create; wait for the workflow, then move aliases.

## Rolling aliases (`vX`, `vX.Y`)

Create/update **two** aliases when you ship `X.Y.Z`:

- `vX` — latest `X.y.z` (minors + patches in that major). Recommended default pin for GitHub consumers.
- `vX.Y` — latest `X.Y.z` (patches only). For people who refuse a minor float.

**Do not** move `v1` when tagging `v2.0.0`. Start a new `v2` / `v2.0` line.

Mark rolling Releases as **prerelease** and **not** Latest so `releases/latest` still tracks immutable tags:

```powershell
$sha = git rev-list -n 1 "v$Version"
$notes = @"
Rolling alias for the latest **v$Major.x.x** (currently **$Label**, tag ``v$Version``).
This GitHub Release is updated when a new $Major.x ships. It is prerelease so Latest stays on immutable semver tags.
Pin: ``https://github.com/$Owner/$Repo/releases/download/v$Major/<artifact>``
"@

gh release delete "v$Major" --yes --cleanup-tag
gh release create "v$Major" --target $sha --title "v$Major (rolling → $Label)" --notes $notes --prerelease --latest=false
# upload the same artifacts as the immutable release when this is a download URL

gh release delete "v$Major.$Minor" --yes --cleanup-tag
gh release create "v$Major.$Minor" --target $sha --title "v$Major.$Minor (rolling → $Label)" --notes $notes --prerelease --latest=false
```

First time an alias exists, `gh release delete` fails — create it. `--cleanup-tag` drops the old moving tag so the new Release is not stuck on a stale SHA.

**Actions-only** (no Release assets):

```powershell
git tag -f "v$Major" $sha
git push origin "refs/tags/v$Major" --force-with-lease
```

`--force-with-lease` on the **alias ref only**. Prefer delete+recreate of the GitHub Release when assets exist (`gh release delete --cleanup-tag` then `create`) instead of `git tag -f` plus a stale Release.

If a `post-release` script already exists in the repo, **run that**; do not invent a second alias scheme.

## Workflow triggers

Tag-push CI must match **pure** semver only:

```yaml
on:
  push:
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
```

Reject `+` in `github.ref_name` so optional `vX.Y.Z+dep.N` discoverability tags do not republish. Do not glob `v*` — that fires on `v2`.

## Optional discoverability tag

```powershell
git tag -a "v$Version+$Dep" -m "$Label" $sha
git push origin "v$Version+$Dep"
```

Same SHA as `vX.Y.Z`. Docs and changelog cite the label; download URLs stay on `vX.Y.Z` or rolling `vX`.

## What to tell consumers

| They want | GitHub pin |
| --- | --- |
| Inherit 2.x minors/patches | `…/releases/download/v2/…` or `uses: org/repo@v2` |
| Patches only within 2.0 | `v2.0` |
| Bitwise exact | `v2.0.12` |
| Always newest including majors | `releases/latest` — say the major-cross risk |

Antora UI bundles that float a zip URL need `snapshot: true` so Antora re-fetches (that flag is **not** range resolution).
