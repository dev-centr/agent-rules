# Self-host web fonts

Prefer **self-hosted** webfonts (bundled with the app, e.g. Fontsource / local `woff2`) over Google Fonts or other CDNs.

## Why

CDN `@import` / remote stylesheets add DNS, TLS, and CSS→font waterfalls. Waiting on that for first paint is unreliable and turns FOUC into a blank or delayed page when the network is slow.

## Do

- Ship critical faces as local assets (variable font when the family supports it).
- Import font CSS through the bundler; **preload** the primary Latin `woff2` in the document head (`as="font"`, `crossorigin`).
- Keep system stacks as fallbacks in `font-family`.
- Use `font-display: swap` (or `optional`) on self-hosted faces — do **not** invent a render wait for a remote font.

## Do not

- `@import url("https://fonts.googleapis.com/...")` (or similar) inside app CSS.
- Block first paint / hide content until Google Fonts (or any CDN) loads.
- Rely on `preconnect` + CDN alone when you control the site build — self-host instead.

## Procedure

When adding or fixing site fonts, load skill **`self-host-fonts`**.
