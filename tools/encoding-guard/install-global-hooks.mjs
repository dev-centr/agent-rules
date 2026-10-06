#!/usr/bin/env node
// Install the encoding guard as this machine's global git hooks.
//
//   node install-global-hooks.mjs              install (sets git config --global core.hooksPath)
//   node install-global-hooks.mjs --status     show what is configured
//   node install-global-hooks.mjs --uninstall  restore the previous core.hooksPath (or unset it)
//   node install-global-hooks.mjs --write-hooks  regenerate hooks/<name> copies from hooks/_dispatch.sh
//
// An existing global core.hooksPath is kept: it is saved as encodingguard.previousHooksPath
// and the dispatcher chains to it. Repo-local hooks (.git/hooks/<name>) keep running too.
// A repository whose *local* config sets core.hooksPath (husky v9 does this) overrides the
// global value, so the guard does not run there; --status lists the ones it can find under
// a directory you pass with --scan <dir>.
import { execFileSync } from "node:child_process";
import { readFileSync, writeFileSync, readdirSync, existsSync, chmodSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const here = dirname(fileURLToPath(import.meta.url));
const hooksDir = join(here, "hooks");
const HOOKS = ["applypatch-msg", "pre-applypatch", "post-applypatch", "pre-commit", "pre-merge-commit", "prepare-commit-msg",
  "commit-msg", "post-commit", "pre-rebase", "post-checkout", "post-merge", "pre-push", "post-rewrite", "pre-auto-gc",
  "sendemail-validate", "push-to-checkout"];
// Not dispatched on purpose: reference-transaction and post-index-change fire on nearly every
// git command, and a shell spawn each time would slow git down noticeably on Windows.

const fwd = (p) => p.replace(/\\/g, "/");
const git = (args) => { try { return execFileSync("git", args, { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim(); } catch { return ""; } };
const setGlobal = (k, v) => execFileSync("git", ["config", "--global", k, v]);
const unsetGlobal = (k) => { try { execFileSync("git", ["config", "--global", "--unset", k]); } catch {} };

function writeHooks() {
  const body = readFileSync(join(hooksDir, "_dispatch.sh"), "utf8").replace(/\r\n/g, "\n");
  for (const h of HOOKS) { writeFileSync(join(hooksDir, h), body); try { chmodSync(join(hooksDir, h), 0o755); } catch {} }
  console.log(`wrote ${HOOKS.length} hook dispatchers in ${fwd(hooksDir)}`);
}

function scan(dir, out = [], depth = 0) {
  if (depth > 4 || !existsSync(dir)) return out;
  if (existsSync(join(dir, ".git"))) {
    const hp = (() => { try { return execFileSync("git", ["-C", dir, "config", "--local", "--get", "core.hooksPath"], { encoding: "utf8", stdio: ["ignore", "pipe", "ignore"] }).trim(); } catch { return ""; } })();
    if (hp) out.push(`${fwd(dir)}  (core.hooksPath=${hp})`);
    return out;
  }
  for (const e of readdirSync(dir, { withFileTypes: true })) if (e.isDirectory() && e.name !== "node_modules") scan(join(dir, e.name), out, depth + 1);
  return out;
}

const args = process.argv.slice(2);
const target = fwd(resolve(hooksDir));
const current = git(["config", "--global", "--get", "core.hooksPath"]);
const prev = git(["config", "--global", "--get", "encodingguard.previousHooksPath"]);
const scanIdx = args.indexOf("--scan");

if (args.includes("--write-hooks")) writeHooks();
else if (args.includes("--status")) {
  console.log(`core.hooksPath (global): ${current || "(unset)"}`);
  console.log(`encodingguard.previousHooksPath: ${prev || "(unset)"}`);
  console.log(current && fwd(current) === target ? "encoding guard: installed" : "encoding guard: NOT installed");
  if (scanIdx >= 0) {
    const hits = scan(resolve(args[scanIdx + 1] || "."));
    console.log(hits.length ? `repos whose local core.hooksPath bypasses the global guard:\n  ${hits.join("\n  ")}` : "no repos with a local core.hooksPath found");
  }
} else if (args.includes("--uninstall")) {
  if (fwd(current) !== target) { console.log("encoding guard is not the active global hooks path; nothing to do"); process.exit(0); }
  if (prev) { setGlobal("core.hooksPath", prev); unsetGlobal("encodingguard.previousHooksPath"); console.log(`restored core.hooksPath=${prev}`); }
  else { unsetGlobal("core.hooksPath"); console.log("unset global core.hooksPath"); }
} else {
  if (!existsSync(join(hooksDir, "pre-commit"))) writeHooks();
  if (current && fwd(current) === target) { console.log(`already installed: core.hooksPath=${target}`); process.exit(0); }
  if (current) { setGlobal("encodingguard.previousHooksPath", fwd(current)); console.log(`saved previous core.hooksPath=${current} (the dispatcher chains to it)`); }
  setGlobal("core.hooksPath", target);
  console.log(`installed: git config --global core.hooksPath ${target}`);
  console.log("Repo-local .git/hooks/* still run (chained). Bypass once with: git commit --no-verify");
}
