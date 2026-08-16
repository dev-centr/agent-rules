/**
 * Minimal Classic SDL reader for bootstrap-org profile files.
 * Supports: // comments, "strings", """blocks""", bare true/false/numbers,
 * tag values, key="attr", and name "id" { children }.
 */
export function stripLineComments(text) {
  return text.replace(/^\s*\/\/[^\n]*$/gm, "");
}

function isIdentStart(ch) {
  return /[A-Za-z_]/.test(ch);
}

function isIdent(ch) {
  return /[A-Za-z0-9_-]/.test(ch);
}

export function parseSdlDocument(text) {
  const src = stripLineComments(text);
  let i = 0;
  const nodes = [];
  while (true) {
    i = skipWs(src, i);
    if (i >= src.length) break;
    const parsed = parseNode(src, i);
    nodes.push(parsed.node);
    i = parsed.end;
  }
  return nodes;
}

function skipWs(src, i) {
  while (i < src.length && /\s/.test(src[i])) i++;
  return i;
}

function parseString(src, i) {
  if (src[i] === '"' && src[i + 1] === '"' && src[i + 2] === '"') {
    i += 3;
    const start = i;
    while (i < src.length && !(src[i] === '"' && src[i + 1] === '"' && src[i + 2] === '"')) i++;
    const value = src.slice(start, i).replace(/^\n/, "").replace(/\n[ \t]*$/u, "");
    return { value: value.trim(), end: i + 3 };
  }
  if (src[i] !== '"') return null;
  i++;
  let out = "";
  while (i < src.length && src[i] !== '"') {
    if (src[i] === "\\") {
      i++;
      out += src[i] ?? "";
      i++;
      continue;
    }
    out += src[i];
    i++;
  }
  return { value: out, end: i + 1 };
}

function parseBare(src, i) {
  if (src[i] === '"' || isIdentStart(src[i]) === false && src[i] !== "-" && !/[0-9]/.test(src[i])) {
    return null;
  }
  if (isIdentStart(src[i])) {
    const start = i;
    i++;
    while (i < src.length && isIdent(src[i])) i++;
    const tok = src.slice(start, i);
    if (tok === "true") return { value: true, end: i };
    if (tok === "false") return { value: false, end: i };
    return { value: tok, end: i };
  }
  const start = i;
  if (src[i] === "-") i++;
  while (i < src.length && /[0-9.]/.test(src[i])) i++;
  const raw = src.slice(start, i);
  const num = Number(raw);
  return { value: Number.isFinite(num) ? num : raw, end: i };
}

function parseNode(src, i) {
  i = skipWs(src, i);
  if (!isIdentStart(src[i])) {
    throw new Error(`Expected identifier at ${i}: ${src.slice(i, i + 40)}`);
  }
  const ns = i;
  i++;
  while (i < src.length && isIdent(src[i])) i++;
  const name = src.slice(ns, i);

  const values = [];
  const attrs = {};
  i = skipWs(src, i);

  while (i < src.length && src[i] !== "{") {
    if (src[i] === "\n") {
      i++;
      break;
    }
    i = skipWs(src, i);
    if (i >= src.length || src[i] === "{" || src[i] === "\n") break;

    if (src[i] === '"') {
      const s = parseString(src, i);
      values.push(s.value);
      i = s.end;
      continue;
    }

    if (isIdentStart(src[i])) {
      const start = i;
      i++;
      while (i < src.length && isIdent(src[i])) i++;
      const ident = src.slice(start, i);
      const after = skipWs(src, i);
      if (src[after] === "=") {
        i = skipWs(src, after + 1);
        if (src[i] === '"') {
          const s = parseString(src, i);
          attrs[ident] = s.value;
          i = s.end;
        } else {
          const b = parseBare(src, i);
          if (!b) throw new Error(`Expected attribute value after ${ident}=`);
          attrs[ident] = b.value;
          i = b.end;
        }
        continue;
      }
      if (ident === "true") values.push(true);
      else if (ident === "false") values.push(false);
      else values.push(ident);
      continue;
    }

    const b = parseBare(src, i);
    if (b) {
      values.push(b.value);
      i = b.end;
      continue;
    }
    break;
  }

  i = skipWs(src, i);
  const children = [];
  if (src[i] === "{") {
    i++;
    while (true) {
      i = skipWs(src, i);
      if (i >= src.length) throw new Error(`Unclosed { in ${name}`);
      if (src[i] === "}") {
        i++;
        break;
      }
      const child = parseNode(src, i);
      children.push(child.node);
      i = child.end;
    }
  }

  return { node: { name, values, attrs, children }, end: i };
}

function coerceValues(values) {
  if (values.length === 0) return true;
  if (values.length === 1) return values[0];
  return values;
}

export function nodeToObject(node) {
  const obj = {};
  if (node.values.length === 1 && node.children.length === 0 && Object.keys(node.attrs).length === 0) {
    return { [node.name]: node.values[0] };
  }
  if (node.values.length > 1 && node.children.length === 0 && Object.keys(node.attrs).length === 0) {
    return { [node.name]: node.values };
  }
  for (const [k, v] of Object.entries(node.attrs)) obj[k] = v;
  if (node.values.length === 1) obj.id = obj.id ?? node.values[0];
  else if (node.values.length > 1) obj.values = node.values;

  const buckets = {};
  for (const child of node.children) {
    if (!buckets[child.name]) buckets[child.name] = [];
    buckets[child.name].push(child);
  }
  for (const [key, list] of Object.entries(buckets)) {
    const converted = list.map((ch) => {
      if (ch.children.length === 0 && Object.keys(ch.attrs).length === 0) {
        return coerceValues(ch.values);
      }
      const inner = nodeToObject(ch);
      const innerVals = inner[ch.name];
      if (innerVals !== undefined && Object.keys(inner).length === 1) return innerVals;
      const { id, ...rest } = inner;
      if (id != null && Object.keys(rest).length) return inner;
      return inner;
    });
    obj[key] = converted.length === 1 ? converted[0] : converted;
  }
  return obj;
}

export function collectNamed(nodes, name) {
  return nodes.filter((n) => n.name === name);
}

export function deepMerge(base, overlay) {
  if (overlay === undefined) return base;
  if (base === undefined) return overlay;
  if (Array.isArray(overlay)) return overlay;
  if (overlay && typeof overlay === "object" && base && typeof base === "object" && !Array.isArray(base)) {
    const out = { ...base };
    for (const [k, v] of Object.entries(overlay)) out[k] = deepMerge(base[k], v);
    return out;
  }
  return overlay;
}
