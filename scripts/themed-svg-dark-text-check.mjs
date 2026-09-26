/**
 * Adaptive Themed SVG dark-mode text completeness checks.
 * Used by scripts/generate-themed-diagrams.mjs and documented for hub Antora WARN scans.
 *
 * Borrow-from-light: authors may keep selected dark-preset token values identical to
 * light (intentional light islands). Optional manifest.borrowFromLight lists those
 * token ids explicitly. Parent→child: if a surface/canvas token is borrowed, nested
 * text for that region should also borrow — do not force dark-mode text recoloring
 * inside a light-stable region. WARN when a changed (non-borrowed) surface/canvas
 * still has light-mode text left behind.
 */

function normalizeColor(value) {
  if (typeof value !== 'string') return ''
  return value.trim().toLowerCase().replace(/\s+/g, '')
}

function sameColor(a, b) {
  return normalizeColor(a) !== '' && normalizeColor(a) === normalizeColor(b)
}

/** Tokens whose dark value equals light, plus optional borrowFromLight ids. */
export function borrowedTokenIds(manifest) {
  const out = new Set()
  if (!manifest?.presets?.light || !manifest?.presets?.dark) return out
  const { light, dark } = manifest.presets
  for (const id of Object.keys(light)) {
    if (Object.prototype.hasOwnProperty.call(dark, id) && sameColor(light[id], dark[id])) {
      out.add(id)
    }
  }
  const explicit = manifest.borrowFromLight || manifest['x-devcentr-borrow-from-light'] || []
  if (Array.isArray(explicit)) {
    for (const id of explicit) out.add(id)
  }
  return out
}

/**
 * Infer text tokens that live inside a surface/canvas token (naming convention).
 * color.canvas → color.text.primary (and color.text.muted)
 * color.surface.note → color.text.on-note, color.text.note
 */
export function textTokensInside(surfaceToken, allTokenIds) {
  const ids = allTokenIds instanceof Set ? allTokenIds : new Set(allTokenIds)
  const related = []
  if (surfaceToken === 'color.canvas') {
    for (const id of ids) {
      if (id === 'color.text.primary' || id === 'color.text.muted' || id.startsWith('color.text.')) {
        // Prefer primary/muted for canvas; region-specific on-* stay with surfaces
        if (id === 'color.text.primary' || id === 'color.text.muted') related.push(id)
      }
    }
    return related
  }
  const m = surfaceToken.match(/^color\.surface\.(.+)$/)
  if (!m) return related
  const leaf = m[1]
  for (const candidate of [`color.text.on-${leaf}`, `color.text.${leaf}`, `color.text.on.${leaf}`]) {
    if (ids.has(candidate)) related.push(candidate)
  }
  return related
}

function isDarkerBackground(lightHex, darkHex) {
  const lum = (hex) => {
    const h = normalizeColor(hex).replace('#', '')
    if (!/^([0-9a-f]{3}|[0-9a-f]{6})$/.test(h)) return null
    const full = h.length === 3 ? h.split('').map((c) => c + c).join('') : h
    const r = parseInt(full.slice(0, 2), 16) / 255
    const g = parseInt(full.slice(2, 4), 16) / 255
    const b = parseInt(full.slice(4, 6), 16) / 255
    return 0.2126 * r + 0.7152 * g + 0.0722 * b
  }
  const a = lum(lightHex)
  const b = lum(darkHex)
  if (a == null || b == null) return darkHex !== lightHex
  return b < a - 0.05
}

export function findDarkModeTextGaps(svg, { fileLabel = 'diagram.svg', namespaceHint, manifest } = {}) {
  const gaps = []
  if (!/prefers-color-scheme:\s*dark/.test(svg)) {
    gaps.push('missing @media (prefers-color-scheme: dark) preset')
    return gaps.map((g) => `${fileLabel}: ${g}`)
  }

  const ns = namespaceHint || manifest?.namespace || (svg.match(/--themed-svg-([a-z0-9-]+)-color-text-primary/) || [])[1]
  const textVar = ns
    ? new RegExp(`fill:var\\(--themed-svg-${ns}-color-text-primary`)
    : /fill:var\(--themed-svg-[a-z0-9-]+-color-text-primary/

  const borrowed = borrowedTokenIds(manifest)
  const light = manifest?.presets?.light || {}
  const dark = manifest?.presets?.dark || {}
  const allIds = new Set([...Object.keys(light), ...Object.keys(dark)])

  const canvasBorrowed = borrowed.has('color.canvas')
  const textPrimaryBorrowed = borrowed.has('color.text.primary')
  const canvasChangedToDark =
    light['color.canvas'] &&
    dark['color.canvas'] &&
    !canvasBorrowed &&
    isDarkerBackground(light['color.canvas'], dark['color.canvas'])

  // Hardcoded Mermaid root fill / label color — skip only when the whole ink+canvas
  // pair intentionally borrows light (stable light diagram / OS-dark page with light figure).
  const lightStableFigure = canvasBorrowed && textPrimaryBorrowed

  const rootRule = svg.match(/#my-svg\{[^}]*\}/)
  if (rootRule) {
    const hardcoded = /fill:\s*#([0-9a-fA-F]{3,8})|fill:\s*rgb\(/.test(rootRule[0]) && !textVar.test(rootRule[0])
    if (hardcoded && !lightStableFigure) {
      gaps.push('root #my-svg fill is a hardcoded color (not color.text.primary var); <text> inherits it in dark mode')
    }
  }

  const labelRule = svg.match(/#my-svg \.label\{[^}]*\}/)
  if (
    labelRule &&
    /color:\s*#([0-9a-fA-F]{3,8})|color:\s*rgb\(0,\s*0,\s*0\)/.test(labelRule[0]) &&
    !/color:var\(--themed-svg-/.test(labelRule[0]) &&
    !lightStableFigure
  ) {
    gaps.push('#my-svg .label color is hardcoded (not a themed-svg text var)')
  }

  if (ns && !svg.includes(`--themed-svg-${ns}-color-text-primary`) && !textPrimaryBorrowed) {
    const darkBlock = svg.match(/@media \(prefers-color-scheme:dark\)\{[^}]*\{([^}]*)\}/)
    if (darkBlock && !new RegExp(`--themed-svg-${ns}-color-text-primary`).test(darkBlock[0])) {
      gaps.push(`dark preset missing --themed-svg-${ns}-color-text-primary`)
    }
  }

  // Canvas went dark but primary text still borrows light → dark-on-dark
  if (canvasChangedToDark && textPrimaryBorrowed) {
    gaps.push(
      'color.canvas changes in dark mode but color.text.primary still borrows light (dark background with light-mode text)'
    )
  }

  // Parent→child borrow consistency for surfaces
  for (const surfaceId of allIds) {
    if (!surfaceId.startsWith('color.surface.')) continue
    const childTextIds = textTokensInside(surfaceId, allIds)
    if (childTextIds.length === 0) continue

    const surfaceBorrowed = borrowed.has(surfaceId)
    const surfaceChanged =
      light[surfaceId] &&
      dark[surfaceId] &&
      !surfaceBorrowed &&
      !sameColor(light[surfaceId], dark[surfaceId])

    for (const textId of childTextIds) {
      if (!light[textId] || !dark[textId]) continue
      const textBorrowed = borrowed.has(textId)
      if (surfaceBorrowed && !textBorrowed && !sameColor(light[textId], dark[textId])) {
        gaps.push(
          `${surfaceId} borrows light in dark mode but ${textId} still changes — nested text inside a light-stable region should also borrow light`
        )
      }
      if (
        surfaceChanged &&
        isDarkerBackground(light[surfaceId], dark[surfaceId]) &&
        textBorrowed
      ) {
        gaps.push(
          `${surfaceId} changes in dark mode but ${textId} still borrows light (adapted surface with light-mode text left behind)`
        )
      }
    }
  }

  return gaps.map((g) => `${fileLabel}: ${g}`)
}

/** Strip authoring-only keys before passing a manifest to @dev-centr/themed-svg. */
export function manifestForTransformer(manifest) {
  if (!manifest || typeof manifest !== 'object') return manifest
  const { borrowFromLight, 'x-devcentr-borrow-from-light': _x, ...rest } = manifest
  return rest
}