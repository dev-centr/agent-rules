---
name: web-crawlability
description: >-
  Use when creating, publishing, or maintaining a public website, docs site,
  marketing site, news page, blog, changelog, or public content route; sitemap,
  sitemap.xml, sitemap index, robots.txt, robots directives, crawler, indexing,
  SEO rendering, SSR, SSG, prerender, static HTML, empty app container,
  client-only rendering, RSS, Atom, feed discovery, no-JavaScript HTML,
  schema.org, JSON-LD, structured data, TechArticle, NewsArticle,
  SoftwareApplication, SoftwareSourceCode.
---

# Public web crawlability

Apply [`general/web-crawlability.md`](../../general/web-crawlability.md).

## Workflow

1. Classify each public route as content-first or application-first.
2. Ensure content-first routes return meaningful HTML through SSG/prerendering or SSR. Keep hydration and transitions as enhancements.
3. Generate `/sitemap.xml` from canonical indexable routes and publish `/robots.txt` with the production sitemap URL.
4. State each content page in the raw HTML with Schema.org JSON-LD. Docs pages are `TechArticle`. News is `NewsArticle`. A blog post is `BlogPosting`. A product page is `SoftwareApplication`. A library or source page is `SoftwareSourceCode`. Include `Organization`, `WebSite`, and `BreadcrumbList` when the page shows that trail.
5. For news/blog surfaces, maintain and advertise RSS/Atom feeds with canonical item links and meaningful content.
6. Add build/deployment checks for artifacts, XML validity, URL status/canonicality, representative raw HTML without JavaScript, and a Schema.org JSON-LD script on a representative content page.
7. Update sitemap, feed, and JSON-LD generation whenever routes, slugs, canonical URLs, or indexability change.

Do not treat a sitemap as a content API. It discovers URLs; crawlers still need readable HTML or another content-bearing representation.
