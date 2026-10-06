#!/usr/bin/env node
// check-mojibake: find (and optionally repair) double-encoded UTF-8 ("mojibake").
//
// Canonical source (copy this single file; it has no dependencies):
//   https://github.com/dev-centr/agent-rules/blob/main/tools/encoding-guard/check-mojibake.mjs
// Docs: https://github.com/dev-centr/agent-rules/blob/main/general/text-encoding.md
//
// Mojibake happens when UTF-8 bytes are read as a legacy code page (Windows-1252,
// or the console's IBM437) and written back as UTF-8. Example: an em dash
// (bytes E2 80 94) becomes the three characters a-circumflex, euro sign,
// right double quote. Windows PowerShell 5.1 Get-Content / Set-Content without
// -Encoding is the most common cause.
//
// Low false positives: a run of characters is only flagged when mapping them
// back to their legacy-code-page bytes yields one valid UTF-8 character in a
// plausible range. Ordinary accented text does not round-trip that way.
//
// Usage:
//   node check-mojibake.mjs                 scan all git-tracked files
//   node check-mojibake.mjs --staged        scan staged content (pre-commit hook)
//   node check-mojibake.mjs path/ file.md   scan given files / directories
//   node check-mojibake.mjs --fix [...]     repair in place (verified round-trip only)
//   options: --json  --quiet  --allow-non-utf8 (only warn on files that are not valid UTF-8)
//   Files that are not valid UTF-8 fail by default; --fix re-decodes their stray bytes as
//   Windows-1252 (what PowerShell 5.1 Set-Content writes) when every byte is defined there.
//
// Opt-outs for intentional examples:
//   - a line containing "mojibake-guard: allow" is skipped
//   - a file whose first 10 lines contain "mojibake-guard: allow-file" is skipped
//   - .encoding-allow at the repo root: one glob per line (# comments)
//
// Exit codes: 0 clean, 1 problems found (or left after --fix), 2 usage error.

import { execFileSync } from "node:child_process";
import { readFileSync, writeFileSync, existsSync, statSync, readdirSync } from "node:fs";
import { join, relative, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

export const VERSION = "1.1.0";

// ---------------------------------------------------------------- code pages
const CP1252_HIGH = [
  0x20ac, 0x0081, 0x201a, 0x0192, 0x201e, 0x2026, 0x2020, 0x2021, 0x02c6, 0x2030, 0x0160, 0x2039, 0x0152, 0x008d, 0x017d, 0x008f,
  0x0090, 0x2018, 0x2019, 0x201c, 0x201d, 0x2022, 0x2013, 0x2014, 0x02dc, 0x2122, 0x0161, 0x203a, 0x0153, 0x009d, 0x017e, 0x0178,
];
const CP437_HIGH = [
  0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, 0x00ea, 0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x00ec, 0x00c4, 0x00c5,
  0x00c9, 0x00e6, 0x00c6, 0x00f4, 0x00f6, 0x00f2, 0x00fb, 0x00f9, 0x00ff, 0x00d6, 0x00dc, 0x00a2, 0x00a3, 0x00a5, 0x20a7, 0x0192,
  0x00e1, 0x00ed, 0x00f3, 0x00fa, 0x00f1, 0x00d1, 0x00aa, 0x00ba, 0x00bf, 0x2310, 0x00ac, 0x00bd, 0x00bc, 0x00a1, 0x00ab, 0x00bb,
  0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x2561, 0x2562, 0x2556, 0x2555, 0x2563, 0x2551, 0x2557, 0x255d, 0x255c, 0x255b, 0x2510,
  0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x255e, 0x255f, 0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x2567,
  0x2568, 0x2564, 0x2565, 0x2559, 0x2558, 0x2552, 0x2553, 0x256b, 0x256a, 0x2518, 0x250c, 0x2588, 0x2584, 0x258c, 0x2590, 0x2580,
  0x03b1, 0x00df, 0x0393, 0x03c0, 0x03a3, 0x03c3, 0x00b5, 0x03c4, 0x03a6, 0x0398, 0x03a9, 0x03b4, 0x221e, 0x03c6, 0x03b5, 0x2229,
  0x2261, 0x00b1, 0x2265, 0x2264, 0x2320, 0x2321, 0x00f7, 0x2248, 0x00b0, 0x2219, 0x00b7, 0x221a, 0x207f, 0x00b2, 0x25a0, 0x00a0,
];

function reverseMap(high, latin1Tail) {
  const m = new Map();
  high.forEach((cp, i) => m.set(cp, 0x80 + i));
  if (latin1Tail) for (let b = 0xa0; b <= 0xff; b++) m.set(b, b);
  return m;
}
const CODEPAGES = [
  { name: "cp1252", map: reverseMap(CP1252_HIGH, true) },
  { name: "cp437", map: reverseMap(CP437_HIGH, false) },
];

const CP437_GREEK = new Set([0x192, 0x3b1, 0x393, 0x3c0, 0x3a3, 0x3c3, 0x3c4, 0x3a6, 0x398, 0x3a9, 0x3b4, 0x3c6, 0x3b5]);

// Decoded characters we accept as "this was really mojibake".
function plausible(cp, nbytes, cpName, allowC1) {
  if (cp >= 0xd800 && cp <= 0xdfff) return false;
  if (cp >= 0xe000 && cp <= 0xf8ff) return false; // private use
  if (cp >= 0xfdd0 && cp <= 0xfdef) return false;
  if ((cp & 0xfffe) === 0xfffe) return false;
  if (cpName === "cp437") {
    // Box-drawing art must not trip this: only Latin-1, typography/symbol blocks, emoji.
    // Latin-1 plus the non-box characters IBM437 itself contains (Greek letters, f-hook), so
    // text that went through the console code page twice unwinds layer by layer.
    if (nbytes === 2) return (cp >= 0xa0 && cp <= 0xff) || CP437_GREEK.has(cp);
    if (nbytes === 3) return cp >= 0x2000 && cp <= 0x2bff;
    return cp >= 0x1f000 && cp <= 0x1faff;
  }
  // C1 controls only as an intermediate step of multi-layer damage (see analyzeText).
  if (nbytes === 2) return (allowC1 && cp >= 0x80 && cp <= 0x9f) || (cp >= 0xa0 && cp <= 0x17f) || (cp >= 0x370 && cp <= 0x3ff);
  if (nbytes === 3) return cp >= 0x800;
  return cp >= 0x10000 && cp <= 0x10ffff;
}

const utf8 = new TextDecoder("utf-8", { fatal: true, ignoreBOM: true });

function seqLen(lead) {
  if (lead >= 0xc2 && lead <= 0xdf) return 2;
  if (lead >= 0xe0 && lead <= 0xef) return 3;
  if (lead >= 0xf0 && lead <= 0xf4) return 4;
  return 0;
}

// Find mojibake runs in one string. Returns [{start, end, replacement, codepage, heuristic}]
export function findMojibake(text, allowC1 = false) {
  const hits = [];
  const chars = Array.from(text); // code points
  // Map code-point index -> string offset.
  const offs = new Array(chars.length + 1);
  let o = 0;
  for (let i = 0; i < chars.length; i++) { offs[i] = o; o += chars[i].length; }
  offs[chars.length] = o;
  let i = 0;
  outer: while (i < chars.length) {
    const c0 = chars[i].codePointAt(0);
    if (c0 < 0x80) { i++; continue; }
    for (const page of CODEPAGES) {
      const lead = page.map.get(c0);
      if (lead === undefined) continue;
      const n = seqLen(lead);
      if (!n) continue;
      const bytes = [lead];
      let ok = true;
      for (let k = 1; k < n; k++) {
        const ch = chars[i + k];
        const b = ch === undefined ? undefined : page.map.get(ch.codePointAt(0));
        if (b === undefined || b < 0x80 || b > 0xbf) { ok = false; break; }
        bytes.push(b);
      }
      if (ok) {
        let dec;
        try { dec = utf8.decode(Uint8Array.from(bytes)); } catch { ok = false; }
        if (ok) {
          const cp = dec.codePointAt(0);
          if (Array.from(dec).length === 1 && plausible(cp, n, page.name, allowC1)) {
            // UTF-8 BOM that got double-encoded: drop it.
            const replacement = cp === 0xfeff ? "" : dec;
            hits.push({ start: offs[i], end: offs[i + n], replacement, codepage: page.name, heuristic: false });
            i += n;
            continue outer;
          }
        }
      }
      // cp1252 lost the undefined 0x9D byte of a right double quote (E2 80 9D): "a-circ + euro" left alone.
      if (page.name === "cp1252" && lead === 0xe2 && chars[i + 1] === "\u20ac") {
        const nx = chars[i + 2];
        const nb = nx === undefined ? undefined : page.map.get(nx.codePointAt(0));
        if (nb === undefined || nb < 0x80 || nb > 0xbf) {
          hits.push({ start: offs[i], end: offs[i + 2], replacement: "\u201d", codepage: page.name, heuristic: true });
          i += 2;
          continue outer;
        }
      }
    }
    i++;
  }
  return hits;
}

function applyHits(text, hits) {
  let out = "";
  let last = 0;
  for (const h of hits) { out += text.slice(last, h.start) + h.replacement; last = h.end; }
  return out + text.slice(last);
}

const ALLOW_LINE = "mojibake-guard: allow";
const ALLOW_FILE = "mojibake-guard: allow-file";

// Scan + repair a whole text. Layered damage (encoded twice) is undone by repeating.
export function analyzeText(text) {
  const head = text.split("\n", 10).join("\n");
  if (head.includes(ALLOW_FILE)) return { allowed: true, findings: [], fixed: text, replacementChars: 0 };
  const lines = text.split("\n");
  const findings = [];
  const fixedLines = lines.map((line, idx) => {
    if (line.includes(ALLOW_LINE)) return line;
    const run = (allowC1) => {
      let cur = line;
      let first = null;
      for (let pass = 0; pass < 4; pass++) {
        const hits = findMojibake(cur, allowC1);
        if (!hits.length) break;
        if (pass === 0) first = hits;
        cur = applyHits(cur, hits);
      }
      return { cur, first };
    };
    const c1 = /[\u0080-\u009f]/g;
    const before = (line.match(c1) || []).length;
    let r = run(true);
    if ((r.cur.match(c1) || []).length > before) r = run(false); // a C1 control must never be the end result
    if (r.first) for (const h of r.first) findings.push({ line: idx + 1, col: h.start + 1, bad: line.slice(h.start, h.end), good: h.replacement, codepage: h.codepage, heuristic: h.heuristic });
    return r.cur;
  });
  let replacementChars = 0;
  lines.forEach((line, idx) => {
    if (line.includes(ALLOW_LINE)) return;
    const n = (line.match(/\uFFFD/g) || []).length;
    if (n) { replacementChars += n; findings.push({ line: idx + 1, col: line.indexOf("\uFFFD") + 1, bad: "\uFFFD", good: null, codepage: "replacement-char", heuristic: false }); }
  });
  return { allowed: false, findings, fixed: fixedLines.join("\n"), replacementChars };
}

// ---------------------------------------------------------------- files
const BINARY_EXT = new Set(("png jpg jpeg gif webp avif ico icns bmp tif tiff psd xcf heic jxl pdf zip gz tgz bz2 xz 7z rar zst jar war " +
  "exe dll so dylib a lib o obj pdb bin dat db sqlite sqlite3 woff woff2 ttf otf eot mp3 mp4 m4a wav ogg flac webm mov avi mkv " +
  "class pyc wasm msi msix appx cab dmg pkg deb rpm apk aab ipa keystore jks p12 pfx der crt cer nupkg snupkg").split(" "));
const DEFAULT_SKIP = [/(^|\/)node_modules\//, /(^|\/)\.git\//, /\.min\.(js|css)$/, /\.map$/, /(^|\/)(package-lock\.json|pnpm-lock\.yaml|yarn\.lock|Cargo\.lock|pubspec\.lock|dub\.selections\.json)$/];
const MAX_BYTES = 4 * 1024 * 1024;

function globToRegExp(glob) {
  let g = glob.trim().replace(/\\/g, "/");
  if (g.startsWith("/")) g = g.slice(1);
  else if (!g.includes("/")) g = "**/" + g;
  if (g.endsWith("/")) g += "**";
  let re = "";
  for (let i = 0; i < g.length; i++) {
    const c = g[i];
    if (c === "*") {
      if (g[i + 1] === "*") { re += g[i + 2] === "/" ? "(?:.*/)?" : ".*"; i += g[i + 2] === "/" ? 2 : 1; }
      else re += "[^/]*";
    } else if (c === "?") re += "[^/]";
    else re += c.replace(/[.+^${}()|[\]\\]/g, "\\$&");
  }
  return new RegExp("^" + re + "$");
}

export function loadAllow(root) {
  const p = join(root, ".encoding-allow");
  if (!existsSync(p)) return [];
  return readFileSync(p, "utf8").split(/\r?\n/).map((l) => l.trim()).filter((l) => l && !l.startsWith("#")).map(globToRegExp);
}

export function isSkippedPath(rel, allow) {
  const r = rel.replace(/\\/g, "/");
  const ext = r.includes(".") ? r.slice(r.lastIndexOf(".") + 1).toLowerCase() : "";
  if (BINARY_EXT.has(ext)) return true;
  if (DEFAULT_SKIP.some((re) => re.test(r))) return true;
  if (r === ".encoding-allow") return true;
  return allow.some((re) => re.test(r));
}

// Decode bytes as UTF-8, falling back to Windows-1252 for bytes that are not valid UTF-8
// (files that Windows PowerShell 5.1 Set-Content wrote in the ANSI code page).
const CP1252_UNDEFINED = new Set([0x81, 0x8d, 0x8f, 0x90, 0x9d]);
export function rescueLegacyBytes(buf) {
  let text = "";
  const bad = [];
  let line = 1, col = 1, i = 0, chunkStart = 0;
  const flush = (end) => { if (end > chunkStart) text += utf8.decode(buf.subarray(chunkStart, end)); };
  while (i < buf.length) {
    const b = buf[i];
    let n = b < 0x80 ? 1 : seqLen(b);
    let ok = n > 0 && i + n <= buf.length;
    for (let k = 1; ok && k < n; k++) if ((buf[i + k] & 0xc0) !== 0x80) ok = false;
    if (ok && n > 1) { try { utf8.decode(buf.subarray(i, i + n)); } catch { ok = false; } }
    if (ok) {
      if (b === 0x0a) { line++; col = 1; } else if (n === 1 || true) col++;
      i += n; continue;
    }
    flush(i);
    const good = CP1252_UNDEFINED.has(b) ? null : String.fromCodePoint(b >= 0xa0 ? b : CP1252_HIGH[b - 0x80]);
    bad.push({ line, col, bad: `\\x${b.toString(16).toUpperCase()}`, good, codepage: "not-utf8", heuristic: false });
    text += good ?? "\uFFFD";
    i += 1; col++; chunkStart = i;
  }
  flush(buf.length);
  return { text, bad };
}

// Analyze raw bytes. Returns null for binary / oversized content.
export function analyzeBuffer(buf) {
  if (buf.length > MAX_BYTES) return null;
  const probe = buf.subarray(0, 8000);
  if (probe.includes(0)) return null;
  let text, rescue = null;
  try { text = utf8.decode(buf); } catch { rescue = rescueLegacyBytes(buf); text = rescue.text; }
  const bom = text.charCodeAt(0) === 0xfeff ? "\ufeff" : "";
  const res = analyzeText(bom ? text.slice(1) : text);
  if (!rescue) return { notUtf8: false, ...res, fixed: bom + res.fixed };
  if (res.allowed) return { notUtf8: true, ...res, findings: [], fixed: null };
  const fixable = rescue.bad.every((f) => f.good !== null);
  return { notUtf8: true, ...res, findings: [...rescue.bad, ...res.findings], fixed: fixable ? bom + res.fixed : null };
}

function git(args, cwd) {
  return execFileSync("git", args, { cwd, encoding: "buffer", maxBuffer: 1 << 30, stdio: ["ignore", "pipe", "pipe"] });
}

// Read many objects with a single `git cat-file --batch` process. Returns Buffers in input order.
export function catFileBatch(cwd, shas) {
  if (!shas.length) return [];
  const out = execFileSync("git", ["cat-file", "--batch"], { cwd, input: shas.join("\n") + "\n", maxBuffer: 1 << 31 - 1, stdio: ["pipe", "pipe", "pipe"] });
  const res = [];
  let pos = 0;
  for (let i = 0; i < shas.length; i++) {
    const nl = out.indexOf(10, pos);
    const header = out.subarray(pos, nl).toString("utf8");
    const parts = header.split(" ");
    if (parts[1] === "missing") { res.push(Buffer.alloc(0)); pos = nl + 1; continue; }
    const size = Number(parts[2]);
    res.push(out.subarray(nl + 1, nl + 1 + size));
    pos = nl + 1 + size + 1;
  }
  return res;
}

function repoRoot(cwd) {
  try { return git(["rev-parse", "--show-toplevel"], cwd).toString("utf8").trim(); } catch { return null; }
}

function walk(dir, out) {
  for (const e of readdirSync(dir, { withFileTypes: true })) {
    if (e.name === ".git" || e.name === "node_modules") continue;
    const p = join(dir, e.name);
    if (e.isDirectory()) walk(p, out);
    else if (e.isFile()) out.push(p);
  }
}

// ---------------------------------------------------------------- CLI
function selfPath(cwd) {
  const abs = fileURLToPath(import.meta.url);
  const rel = relative(cwd, abs);
  return (rel.startsWith("..") ? abs : rel).split(sep).join("/");
}

function main(argv) {
  const opts = { fix: false, staged: false, json: false, allowNonUtf8: false, quiet: false, paths: [] };
  for (const a of argv) {
    if (a === "--fix") opts.fix = true;
    else if (a === "--staged") opts.staged = true;
    else if (a === "--json") opts.json = true;
    else if (a === "--allow-non-utf8") opts.allowNonUtf8 = true;
    else if (a === "--strict") {} // kept for compatibility: non-UTF-8 files fail by default since 1.1.0
    else if (a === "--quiet" || a === "-q") opts.quiet = true;
    else if (a === "--version") { console.log(VERSION); return 0; }
    else if (a === "--help" || a === "-h") { console.log(readFileSync(fileURLToPath(import.meta.url), "utf8").split("\n").filter((l) => l.startsWith("//")).map((l) => l.slice(3)).join("\n")); return 0; }
    else if (a.startsWith("--")) { console.error(`check-mojibake: unknown option ${a}`); return 2; }
    else opts.paths.push(a);
  }
  if (opts.staged && opts.fix) { console.error("check-mojibake: --staged and --fix cannot be combined; run --fix on the files, then re-stage"); return 2; }

  const cwd = process.cwd();
  const root = repoRoot(cwd) || cwd;
  const allow = loadAllow(root);
  const items = []; // { rel, read: () => Buffer, abs }

  if (opts.staged) {
    const names = git(["diff", "--cached", "--name-only", "-z", "--diff-filter=ACMR"], root).toString("utf8").split("\0").filter(Boolean);
    const wanted = names.filter((rel) => !isSkippedPath(rel, allow));
    if (wanted.length) {
      // One `git cat-file --batch` for all staged blobs (fast on Windows, where process spawns are slow).
      const entries = [];
      for (const line of git(["ls-files", "-s", "-z", "--", ...wanted], root).toString("utf8").split("\0")) {
        const m = /^(\d+) ([0-9a-f]+) (\d)\t(.*)$/s.exec(line);
        if (m && m[1] !== "160000") entries.push({ sha: m[2], rel: m[4] });
      }
      const blobs = catFileBatch(root, entries.map((e) => e.sha));
      entries.forEach((e, i) => items.push({ rel: e.rel, read: () => blobs[i] }));
    }
  } else if (opts.paths.length) {
    for (const p of opts.paths) {
      const abs = resolve(cwd, p);
      if (!existsSync(abs)) { console.error(`check-mojibake: no such path ${p}`); return 2; }
      const files = [];
      if (statSync(abs).isDirectory()) walk(abs, files); else files.push(abs);
      for (const f of files) items.push({ rel: relative(root, f).split(sep).join("/"), abs: f, read: () => readFileSync(f) });
    }
  } else {
    const names = git(["ls-files", "-z", "--cached"], root).toString("utf8").split("\0").filter(Boolean);
    for (const rel of names) {
      const abs = join(root, rel);
      items.push({ rel, abs, read: () => readFileSync(abs) });
    }
  }

  const report = { version: VERSION, files: [], notUtf8: [], fixedFiles: [] };
  let problems = 0;
  for (const it of items) {
    if (isSkippedPath(it.rel, allow)) continue;
    if (it.abs && (!existsSync(it.abs) || !statSync(it.abs).isFile())) continue; // deleted / submodule
    let buf;
    try { buf = it.read(); } catch { continue; }
    const res = analyzeBuffer(buf);
    if (!res) continue;
    if (res.notUtf8) report.notUtf8.push(it.rel);
    if (res.notUtf8 && opts.allowNonUtf8) res.findings = res.findings.filter((f) => f.codepage !== "not-utf8");
    if (!res.findings.length) continue;
    report.files.push({ path: it.rel, findings: res.findings });
    if (opts.fix && it.abs) {
      const fixable = res.fixed === null ? [] : res.findings.filter((f) => f.good !== null);
      if (fixable.length && res.fixed !== buf.toString("utf8")) {
        writeFileSync(it.abs, Buffer.from(res.fixed, "utf8"));
        report.fixedFiles.push(it.rel);
      }
      problems += res.findings.length - fixable.length; // U+FFFD cannot be repaired automatically
    } else problems += res.findings.length;
  }

  if (opts.json) {
    process.stdout.write(JSON.stringify(report, null, 2).replace(/[\u007f-\uffff]/g, (c) => "\\u" + c.charCodeAt(0).toString(16).padStart(4, "0")) + "\n");
  } else {
    const esc = (s) => s.replace(/[^\x20-\x7e]/g, (c) => `\\u{${c.codePointAt(0).toString(16)}}`);
    for (const f of report.files) {
      for (const x of f.findings) {
        if (opts.quiet) continue;
        const what = x.codepage === "not-utf8" ? `byte ${x.bad} is not valid UTF-8 (file saved in a legacy code page)${x.good === null ? "; fix by hand" : `; --fix writes "${x.good}" [${esc(x.good)}]`}`
          : x.good === null ? "U+FFFD replacement character (data already lost; fix by hand)"
          : `"${x.bad}" should be "${x.good}"  [${esc(x.bad)} -> ${esc(x.good) || "(remove)"}, ${x.codepage}${x.heuristic ? ", heuristic" : ""}]`;
        console.log(`${f.path}:${x.line}:${x.col}: ${what}`);
      }
    }
    if (opts.allowNonUtf8) for (const p of report.notUtf8) if (!opts.quiet) console.log(`${p}: warning: not valid UTF-8`);
    if (opts.fix && report.fixedFiles.length) console.log(`check-mojibake: repaired ${report.fixedFiles.length} file(s)`);
    if (problems) {
      console.error(`check-mojibake: ${problems} problem(s). Double-encoded UTF-8 usually comes from Windows PowerShell 5.1 ` +
        `Get-Content/Set-Content without -Encoding utf8. Repair with: node ${selfPath(cwd)} --fix <paths>`);
      console.error("Intentional examples: add 'mojibake-guard: allow' on the line or list the path in .encoding-allow.");
    }
  }
  return problems ? 1 : 0;
}

const invokedDirectly = process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url);
if (invokedDirectly) process.exitCode = main(process.argv.slice(2));
