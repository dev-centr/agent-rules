import { execFileSync } from 'node:child_process'
import { createHash } from 'node:crypto'
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { basename, join, resolve } from 'node:path'
import { findDarkModeTextGaps } from './themed-svg-dark-text-check.mjs'

const diagrams = [
  {
    name: 'rules-geography',
    fixedSha256: 'c676799c5af8066c23df7a68a776d70484da7a4d17b938131d5e4eef094bc90d',
  },
  {
    name: 'agent-cli-auth-flow',
    fixedSha256: '142f5492ca056ba52c0b5d576920068370eceb24867616025f2848550bfc3322',
  },
]
const imageDir = resolve('docs/modules/ROOT/images')
const config = resolve('docs/mermaid-config.json')
const check = process.argv.includes('--check')
const tools = {
  mmdc: resolve('node_modules/@mermaid-js/mermaid-cli/src/cli.js'),
  adapter: resolve('node_modules/@dev-centr/mermaid-svg-css-vars/bin/mermaid-svg-css-vars.js'),
}
const temporary = mkdtempSync(join(tmpdir(), 'agent-rules-diagrams-'))

function warnDarkModeText(path, namespaceHint) {
  const svg = readFileSync(path, 'utf8')
  const gaps = findDarkModeTextGaps(svg, { fileLabel: basename(path), namespaceHint })
  for (const gap of gaps) {
    console.warn(`WARN themed-svg dark-mode text: ${gap}`)
  }
  return gaps.length
}

function assertSafeSvg(path, expectedMode) {
  const svg = readFileSync(path, 'utf8')
  const required = [
    ['SVG namespace', /<svg\b[^>]*\bxmlns="http:\/\/www\.w3\.org\/2000\/svg"/],
    ['viewBox', /<svg\b[^>]*\bviewBox="[^"]+"/],
    ['preserveAspectRatio', /<svg\b[^>]*\bpreserveAspectRatio="[^"]+"/],
    ['image role', /<svg\b[^>]*\brole="img"/],
    ['accessible title', /<title(?:\s[^>]*)?>[^<]+<\/title>/],
    ['accessible description', /<desc(?:\s[^>]*)?>[^<]+<\/desc>/],
    ['ARIA labelling', /<svg\b[^>]*\baria-labelledby="[^"]+"/],
  ]

  for (const [requirement, pattern] of required) {
    if (!pattern.test(svg)) throw new Error(`${basename(path)} is missing ${requirement}`)
  }

  const forbidden = [
    ['active content', /<(?:script|foreignObject|iframe|object|embed|audio|video)\b/i],
    ['event handler', /\son[a-z]+\s*=/i],
    ['external resource', /\b(?:href|src)\s*=\s*["'](?:https?:|\/\/|data:)/i],
    ['external CSS URL', /url\(\s*["']?(?:https?:|\/\/|data:)/i],
  ]

  for (const [risk, pattern] of forbidden) {
    if (pattern.test(svg)) throw new Error(`${basename(path)} contains forbidden ${risk}`)
  }

  if (expectedMode === 'standalone-adaptive' && !/prefers-color-scheme:\s*dark/.test(svg)) {
    throw new Error(`${basename(path)} is missing its dark-mode media preset`)
  }
  if (expectedMode === 'host' && !svg.includes('--themed-svg-')) {
    throw new Error(`${basename(path)} is missing Themed SVG variables`)
  }
}

function normalizeAccessibility(path) {
  const svg = readFileSync(path, 'utf8').replace(/\brole="[^"]*"/, 'role="img"')
  writeFileSync(path, svg, 'utf8')
}

let darkModeWarnCount = 0

try {
  const mermaidConfig = JSON.parse(readFileSync(config, 'utf8'))
  if (mermaidConfig.flowchart?.htmlLabels !== false) {
    throw new Error('docs/mermaid-config.json must set flowchart.htmlLabels to false')
  }

  for (const { name, fixedSha256 } of diagrams) {
    const raw = join(temporary, `${name}.raw.svg`)
    const secondRaw = join(temporary, `${name}.second.raw.svg`)
    const source = join(imageDir, `${name}.mmd`)
    const renderArgs = ['-i', source, '-c', config, '-b', 'transparent']

    execFileSync(process.execPath, [tools.mmdc, ...renderArgs, '-o', raw], { stdio: 'inherit' })
    execFileSync(process.execPath, [tools.mmdc, ...renderArgs, '-o', secondRaw], { stdio: 'inherit' })
    normalizeAccessibility(raw)
    normalizeAccessibility(secondRaw)

    if (readFileSync(raw, 'utf8') !== readFileSync(secondRaw, 'utf8')) {
      throw new Error(`${basename(source)} does not render deterministically`)
    }

    const adaptive = join(imageDir, `${name}.svg`)
    const host = join(imageDir, `${name}.host.svg`)
    const fixed = join(imageDir, `${name}.fixed.svg`)
    const manifest = JSON.parse(readFileSync(join(imageDir, `${name}.theme.json`), 'utf8'))

    const actualFixedSha256 = createHash('sha256').update(readFileSync(fixed)).digest('hex')
    if (actualFixedSha256 !== fixedSha256) {
      throw new Error(`${basename(fixed)} no longer matches the preserved original`)
    }

    execFileSync(process.execPath, [
      tools.adapter,
      '--manifest', join(imageDir, `${name}.theme.json`),
      '--dual-output',
      ...(check ? ['--check'] : []),
      raw,
      '--output', adaptive,
      '--host-output', host,
    ], { stdio: 'inherit' })

    assertSafeSvg(adaptive, 'standalone-adaptive')
    assertSafeSvg(host, 'host')
    darkModeWarnCount += warnDarkModeText(adaptive, manifest.namespace)
  }
} finally {
  rmSync(temporary, { recursive: true, force: true })
}

if (darkModeWarnCount > 0) {
  console.warn(`WARN themed-svg dark-mode text: ${darkModeWarnCount} issue(s) across diagrams (bind #my-svg fill / .label color to color.text.primary)`)
}
