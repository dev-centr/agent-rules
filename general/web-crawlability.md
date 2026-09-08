# Public web crawlability

Public websites and public content routes must be discoverable and useful without running client JavaScript. A sitemap helps crawlers find URLs; it does not replace readable page content.

## Rendering contract

- Render meaningful HTML for public landing, documentation, news, blog, changelog, product, and article routes through SSR or build-time static generation (SSG/prerendering).
- Prefer SSG for content that changes only at deploy time. Use request-time SSR when the response genuinely depends on request-time data.
- Client hydration, navigation, page transitions, theme transitions, and interactive islands may enhance that HTML. They are not reasons to ship an empty app container.
- Route-level CSR is acceptable for authenticated tools or highly interactive application surfaces, but provide a server-visible title, description, purpose, and useful fallback when the route is public.
- Verify important routes from the raw HTTP response, not only a browser DOM after JavaScript execution.

## Sitemap

Every public site must publish `/sitemap.xml` or a sitemap index there.

- Generate it from the canonical route/content source during the build. Do not maintain a second handwritten URL list.
- Include canonical, indexable, HTTP-200 URLs only. Exclude redirects, aliases, private/authenticated routes, error pages, and `noindex` pages.
- Use absolute HTTPS URLs on the production hostname.
- Emit `<lastmod>` only when backed by truthful page/content modification data. Do not stamp every URL with the build time.
- Split with a sitemap index before a sitemap exceeds protocol limits (50,000 URLs or 50 MB uncompressed).
- Update it in the same build that adds, removes, renames, or changes indexability of routes.

## robots.txt

Every public site must publish `/robots.txt`.

- Default public content to crawlable unless the site has a documented reason otherwise.
- Add an absolute `Sitemap: https://<host>/sitemap.xml` line.
- Keep environment-specific hostnames out of production output.
- Do not use `robots.txt` as access control or as a reliable de-indexing mechanism. Protect private content with authentication; use page/header `noindex` when removal from indexes is required.
- Avoid broad generated-asset bans that prevent render-capable crawlers from loading required CSS or JavaScript.

## Editorial feeds

News/blog sites should publish RSS and Atom (or at least one standard feed), advertise them with `<link rel="alternate">`, and include canonical item URLs plus meaningful summaries or full content. Feeds are alternate content surfaces, not substitutes for crawlable HTML or a sitemap.

## CI and maintenance

For production builds:

1. Assert `/sitemap.xml` and `/robots.txt` exist and return HTTP 200 with suitable text/XML content types.
2. Parse the sitemap and sample or validate all URLs at manageable site sizes: canonical host, no duplicates, no redirects, no errors.
3. Fetch representative content routes without executing JavaScript and assert meaningful title, metadata, heading, and body/link text.
4. Validate feed XML and canonical item links when feeds exist.
5. Re-run these checks whenever routing, rendering mode, canonical URL policy, content generation, or deployment hosting changes.

Do not claim that a static host provides statically rendered pages merely because it serves `.html` files. An `.html` file containing only an empty client mount point is CSR.
