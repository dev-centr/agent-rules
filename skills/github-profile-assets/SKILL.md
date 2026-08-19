---
name: github-profile-assets
description: >-
  Use when creating or updating GitHub org profile assets, `{org}/.github`
  profile images, `profile/assets/`, `profile/README.md` image paths, org avatar
  PNG 256, profile logo SVG/PNG/ICO, brand asset archive, or exporting rasters
  from profile assets; when the user asks where `.github` logos live or wants
  profile/assets to become standard.
---

# GitHub org profile assets

GitHub renders the **public org profile** from `{org}/.github` → `profile/README.md` only. Repo-root `README.md` is for maintainers.

## Standard layout

```text
{org}/.github/
  profile/
    README.md                 # visitor-facing Markdown (images use ./assets/…)
    assets/
      README.md               # index for maintainers
      <hero>.png              # optional flat file referenced by profile README
      brand/                  # revision archive (SVG + rasters)
        <revision>/
          *.svg | *.png | *-256.png | *.ico
          SOURCE.txt
      scripts/
        export-brand-rasters.ps1   # org-specific; optional
```

**Rules**

- Profile-facing images live under **`profile/assets/`**, not repo-root `assets/`.
- `profile/README.md` references **`./assets/...`** (relative paths GitHub can render).
- Harbor **all revisions** under `profile/assets/brand/<revision>/` with `SOURCE.txt` provenance.
- Export **500 PNG**, **256 PNG**, and **multi-size ICO** for each SVG revision (ImageMagick or Inkscape on maintainer machine).
- Upload **`…-256.png`** (or dedicated avatar export) to GitHub **Settings → Organization profile → Avatar** manually — GitHub does not read it from the repo.
- Copy canonical revision into product repos (site `public/images/`, `app/favicon.ico`) via script or explicit sync — do not fork diverging masters.

Org bootstrap context: skill **`bootstrap-org`** (`.github` creation, minimal profile copy). This skill is **assets + discovery + export** only.

## Discovery (agent)

When the user asks about org logos, favicons, or `.github` images:

1. Clone or open `{org}/.github`.
2. Read `profile/README.md` for which `./assets/…` files are live on the profile.
3. Read `profile/assets/README.md` and `profile/assets/brand/*/SOURCE.txt` for revisions.
4. Product site copies may live in `{org}/ftn-site/site-nextjs/public/images/` (or sibling app repo) — trace back to a `brand/` revision.

Do **not** assume repo-root `assets/` — prefer **`profile/assets/`**.

## Creating a new revision folder

1. Add `profile/assets/brand/<revision-id>/`.
2. Copy source SVG (or PNG) from design export.
3. Run the org export script if present, or:

```powershell
magick -background none -density 300 source.svg -resize 500x500 foodtrucknerdz.png
magick -background none -density 300 source.svg -resize 256x256 foodtrucknerdz-256.png
magick foodtrucknerdz-256.png -define icon:auto-resize=256,128,64,48,32,16 foodtrucknerdz.ico
```

4. Write `SOURCE.txt` (`revision`, `note`, `source_*`, `exported` ISO timestamp).
5. Update `profile/assets/brand/README.md` table.
6. Point `profile/README.md` at the hero path if this revision goes live on the profile.

## FoodTruckNerdz reference

- Repo: `FoodTruckNerdz/.github`
- Archive: `profile/assets/brand/` (`shaded-production`, `flat-illustrator`, `shaded-docs`, `gemini-profile`, …)
- Export script: `profile/assets/scripts/export-brand-rasters.ps1` (syncs to `ftn-site` site packages + Next favicon)

## Checklist

- [ ] Assets under `profile/assets/`, not repo-root `assets/`
- [ ] `profile/README.md` uses `./assets/…` paths
- [ ] Each revision has SVG/PNG/256/ICO + `SOURCE.txt`
- [ ] Maintainer README documents regenerate command
- [ ] Avatar 256 uploaded to GitHub org settings when brand changes
