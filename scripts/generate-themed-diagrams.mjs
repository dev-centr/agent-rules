import { execFileSync } from 'node:child_process'
import { copyFileSync, existsSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { basename, join, resolve } from 'node:path'

const diagrams = ['rules-geography', 'agent-cli-auth-flow']
const imageDir = resolve('docs/modules/ROOT/images')
const config = resolve('docs/mermaid-config.json')
const check = process.argv.includes('--check')
const tools = {
  mmdc: resolve('node_modules/@mermaid-js/mermaid-cli/src/cli.js'),
  adapter: resolve('node_modules/@dev-centr/mermaid-svg-css-vars/bin/mermaid-svg-css-vars.js'),
}
const temporary = mkdtempSync(join(tmpdir(), 'agent-rules-diagrams-'))

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

try {
  const mermaidConfig = JSON.parse(readFileSync(config, 'utf8'))
  if (mermaidConfig.flowchart?.htmlLabels !== false) {
    throw new Error('docs/mermaid-config.json must set flowchart.htmlLabels to false')
  }

  for (const name of diagrams) {
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

    if (!check && !existsSync(fixed)) copyFileSync(adaptive, fixed)

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
  }
} finally {
  rmSync(temporary, { recursive: true, force: true })
}
