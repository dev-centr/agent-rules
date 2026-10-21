---
name: font-project-lock
description: >-
  Use when pinning project fonts, .devcentr/fonts.sdl, font lockfile, Fontsource
  npm install, paid vs OSS font choice, retail typeface license, applying
  typography to Vite Flutter Antora Visual App Editor, Scriptbook font install,
  or wiring foundry Fontsource Type Network checkout.
---

# Project font lock

Policy: `general/font-project-lock.md`. Catalog: `catalogs/project-typefaces.sdl`. Quality bar: skill **`typeface-selection`**. Web load: skill **`self-host-fonts`**.

## When to load

- User wants paid **or** free/OSS fonts pinned for a repo.
- Creating `.devcentr/fonts.sdl` or syncing `visual_app_editor.sdl` typography.
- Applying Fontsource to a web/docs app after lock is chosen.
- DevCentr / Visual App Editor project typography (not Appearance OS monos).

## Steps

1. **Ask preference** — `oss`, `retail`, or `mixed` (default `mixed`). OSS: suggest catalog faces with `recommend` tags. Retail: show `foundry_url` / retail provider from catalog; **never** download or scrape retail files.
2. **Pick roles** — ui sans, code mono, text serif, display; map to catalog `face` ids.
3. **Write lock** — `.devcentr/fonts.sdl` at repo root (create `.devcentr/` if needed).
4. **Apply per stack** (only stacks present in the repo):

   | Stack | OSS action |
   | --- | --- |
   | **pnpm/vite/node** | `pnpm add <fontsource npm from catalog>`; import in entry CSS; preload Latin `woff2`; skill `self-host-fonts` |
   | **Antora theme** | Add Fontsource dep to theme/supplemental package; `@font-face` or theme vars |
   | **Flutter** | Copy OFL files to `assets/fonts/`, declare in `pubspec.yaml`, `ThemeData(fontFamily: …)` — prefer bundled assets over runtime CDN |
   | **Visual App Editor** | Set `typography` in `visual_app_editor.sdl` (`preference`, `ui_sans`, `ui_mono` face ids) |
   | **OS code mono** | Scriptbook playbook from catalog `os_install` when `install os` |

5. **Retail** — User places files under `assets/fonts/` (or vendor path); add `OFL.txt` or EULA from foundry; set `install local` and `license_ref` in lock; fail if binary without license sibling.
6. **Verify** — No `fonts.googleapis.com` on production critical path; lock ids exist in catalog; tier matches.

## Providers (integration, not scraping)

| Provider | Use |
| --- | --- |
| **Fontsource** | Default OSS web pin (`npm` column in catalog) |
| **Google Fonts** | Specimen / slug audit only — not runtime `@import` |
| **Type Network / foundry sites** | Retail purchase and license proof |
| **Scriptbook + equivalence-rules-cli** | OS mono install (DevCentr Appearance pattern) |

## Do not

- Auto-download commercial fonts or use scraper hubs (Fontsexpert-class).
- Mix DevCentr Appearance (suite chrome) with project web pins in one file.
- Commit retail `woff2` without license file when tier is `retail`.

## Checklist

- [ ] `preference` recorded in `.devcentr/fonts.sdl`
- [ ] Each role has catalog `face` id and matching `tier`
- [ ] Web stack uses Fontsource/self-host (`self-host-fonts`)
- [ ] VAE/SDL updated when project uses Visual App Editor
- [ ] Changelog in owned repo if functional (skill `owned-changelog`)
