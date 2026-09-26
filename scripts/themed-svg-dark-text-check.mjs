/**
 * Adaptive Themed SVG dark-mode text completeness checks.
 * Used by scripts/generate-themed-diagrams.mjs and documented for hub Antora WARN scans.
 */
export function findDarkModeTextGaps(svg, { fileLabel = 'diagram.svg', namespaceHint } = {}) {
  const gaps = []
  if (!/prefers-color-scheme:\s*dark/.test(svg)) {
    gaps.push('missing @media (prefers-color-scheme: dark) preset')
    return gaps
  }

  const ns = namespaceHint || (svg.match(/--themed-svg-([a-z0-9-]+)-color-text-primary/) || [])[1]
  const textVar = ns
    ? new RegExp(`fill:var\\(--themed-svg-${ns}-color-text-primary`)
    : /fill:var\(--themed-svg-[a-z0-9-]+-color-text-primary/

  const rootRule = svg.match(/#my-svg\{[^}]*\}/)
  if (rootRule) {
    if (/fill:\s*#([0-9a-fA-F]{3,8})|fill:\s*rgb\(/.test(rootRule[0]) && !textVar.test(rootRule[0])) {
      gaps.push('root #my-svg fill is a hardcoded color (not color.text.primary var); <text> inherits it in dark mode')
    }
  }

  const labelRule = svg.match(/#my-svg \.label\{[^}]*\}/)
  if (labelRule && /color:\s*#([0-9a-fA-F]{3,8})|color:\s*rgb\(0,\s*0,\s*0\)/.test(labelRule[0]) && !/color:var\(--themed-svg-/.test(labelRule[0])) {
    gaps.push('#my-svg .label color is hardcoded (not a themed-svg text var)')
  }

  if (ns) {
    const darkBlock = svg.match(/@media \(prefers-color-scheme:dark\)\{[^}]*\{([^}]*)\}/)
    if (darkBlock && !new RegExp(`--themed-svg-${ns}-color-text-primary`).test(darkBlock[0])) {
      gaps.push(`dark preset missing --themed-svg-${ns}-color-text-primary`)
    }
  }

  return gaps.map((g) => `${fileLabel}: ${g}`)
}
