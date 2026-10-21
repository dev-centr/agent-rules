# Project font lock

Users may choose **open/OSS** faces, **paid retail** faces, or **mixed** roles (OSS body + retail display, etc.). Dev-Centr does not mandate free fonts; it mandates **license honesty**, **version pins**, and **correct install targets** (OS vs web bundle).

## Two layers

| Layer | File | Scope |
| --- | --- | --- |
| **Catalog** | `catalogs/project-typefaces.sdl` in agent-rules (synced into Visual App Editor core) | Curated faces, providers, Fontsource npm ids, retail checkout links |
| **Project lock** | `.devcentr/fonts.sdl` at repo root (or path in `devcentr.project.json5`) | This repo’s chosen faces per role |

Suite chrome (DevCentr Appearance) stays separate: OS monos for *DevCentr’s* terminal — see DevCentr spec Appearance. Project lock is for **the product repo** (web app, Flutter app, docs site).

## User preference

| `preference` | Meaning |
| --- | --- |
| `oss` | Only catalog faces with `tier oss`; agents suggest OSS recommendations |
| `retail` | User supplies licenses; catalog links to foundry checkout — **no auto-download of retail files** |
| `mixed` | Default: OSS for code/long text unless user pins retail for brand display |

Agents still apply **`self-host-fonts`** for web (Fontsource / local `woff2`), never production Google Fonts CDN as the primary path.

## Project lock SDL (`.devcentr/fonts.sdl`)

```sdl
fonts {
  preference mixed
  role ui_sans face "dm-sans" tier oss
  role ui_mono face "jetbrains-mono" tier oss install os
  role text_serif face "literata" tier oss install web
  // Retail example — user must own license; paths are local only after purchase
  // role display face "graphik" tier retail license_ref "type-network:account" install local
}
```

| Field | Notes |
| --- | --- |
| `preference` | `oss` \| `retail` \| `mixed` |
| `role` | `ui_sans`, `ui_mono`, `code`, `text_serif`, `display`, … |
| `face` | Id from `project-typefaces.sdl` |
| `tier` | Must match catalog `tier` for that face |
| `install` | `web` (Fontsource/npm), `os` (Scriptbook playbook), `local` (user Dropped licensed files) |
| `license_ref` | Optional opaque id for retail (account / invoice), not a secret |

## Install targets (operationalize)

| Stack | OSS default | Skill step |
| --- | --- | --- |
| Vite / Solid / React | `@fontsource*` + CSS import + preload | `font-project-lock` → `self-host-fonts` |
| Antora / static docs | Fontsource in theme package or supplemental | same |
| Flutter | `google_fonts` only for dev preview; ship `assets/fonts` + `pubspec` for release | `font-project-lock` |
| Visual App Editor | `visual_app_editor.sdl` `typography { … }` preview + lock ids | VAE Theme panel |
| DevCentr | Project wizard reads `.devcentr/fonts.sdl` (panel **later**) | spec `project-typography` |
| Editor/terminal mono | Scriptbook + equivalence-rules-cli catalog | team-docs font-lock |

Retail: document **foundry_url** / Type Network checkout from catalog; copy `woff2`/`otf` into `assets/fonts/` with license file; CI checks license sibling exists.

## OSS recommendations (starting set)

Prefer variable Fontsource packages when available. See catalog entries tagged `recommend oss_ui_sans`, `oss_code_mono`, `oss_text_serif`.

Broader foundry patterns: `general/type-foundries-and-font-quality.md`. Team partnership pages: team.docs font-lock + foundries.

## Related skills

| Skill | Job |
| --- | --- |
| `typeface-selection` | Choose face + tier |
| `font-project-lock` | Write lock file + run stack-specific install |
| `self-host-fonts` | Web bundling |

Load **`font-project-lock`** when pinning or applying fonts to a repo.
