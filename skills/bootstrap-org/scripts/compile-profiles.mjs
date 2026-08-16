#!/usr/bin/env node
/**
 * Compiles profiles/catalog.sdl + sibling .sdl overlays → catalog.json
 * for the website selector. Author only the .sdl files.
 */
import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import {
  collectNamed,
  deepMerge,
  nodeToObject,
  parseSdlDocument,
} from "./parse-sdl.mjs";

const here = dirname(fileURLToPath(import.meta.url));
const profilesDir = process.argv[2]
  ? dirname(process.argv[2].endsWith(".sdl") ? process.argv[2] : join(process.argv[2], "catalog.sdl"))
  : join(here, "..", "profiles");
const catalogSdl = join(profilesDir, "catalog.sdl");
const outPath = process.argv[3] ?? join(profilesDir, "catalog.json");

function asList(v) {
  if (v == null || v === true) return [];
  return Array.isArray(v) ? v.map(String) : [String(v)];
}

function loadNodes(path) {
  return parseSdlDocument(readFileSync(path, "utf8"));
}

const catalogNodes = loadNodes(catalogSdl);
const defaultsNode = collectNamed(catalogNodes, "defaults")[0];
if (!defaultsNode) throw new Error("catalog.sdl: missing defaults { }");
const defaults = nodeToObject(defaultsNode);
delete defaults.id;

const profiles = [];
for (const pNode of collectNamed(catalogNodes, "profile")) {
  const id = String(pNode.values[0] ?? pNode.attrs.id ?? "");
  const file = pNode.attrs.file;
  if (!id || !file) throw new Error(`catalog entry missing name or file=`);
  const catalogMeta = nodeToObject(pNode);
  const fileNodes = loadNodes(join(profilesDir, file));
  const bodyNode = collectNamed(fileNodes, "profile")[0];
  if (!bodyNode) throw new Error(`${file}: missing profile { }`);
  const body = nodeToObject(bodyNode);
  const overlay = { ...body };
  delete overlay.id;
  const merged = deepMerge(defaults, overlay);
  profiles.push({
    id,
    kind: String(merged.kind ?? catalogMeta.kind ?? ""),
    summary: String(merged.summary ?? ""),
    useWhen: asList(catalogMeta.use_when ?? catalogMeta.useWhen),
    sessionScope: asList(merged.session_scope),
    skip: asList(merged.skip),
    file,
    merged,
  });
}

const catalog = {
  sourceRepo: "https://github.com/dev-centr/agent-rules",
  sourcePath: "skills/bootstrap-org/profiles",
  skill: "bootstrap-org",
  defaults,
  profiles,
};

writeFileSync(outPath, JSON.stringify(catalog, null, 2) + "\n");
console.log(`Wrote ${outPath} (${profiles.length} profiles)`);
