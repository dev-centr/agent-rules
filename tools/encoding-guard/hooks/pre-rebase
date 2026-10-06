#!/bin/sh
# encoding-guard global hook dispatcher (dev-centr/agent-rules, tools/encoding-guard).
#
# Installed machine-wide with:
#   node <agent-rules>/tools/encoding-guard/install-global-hooks.mjs
# which sets `git config --global core.hooksPath` to this folder.
#
# On pre-commit it runs check-mojibake.mjs on the staged content, then it chains to:
#   1. a hooks folder that was configured globally before this one
#      (git config --global encodingguard.previousHooksPath), and
#   2. the repository's own .git/hooks/<name>, which is where lefthook, the
#      pre-commit framework, git-lfs and husky v4 install their hooks.
# Every file in this folder except this one is a copy of this script; the hook
# name comes from the file name. Regenerate them with install-global-hooks.mjs --write-hooks.
#
# Bypass everything once:   git commit --no-verify
# Skip only the mojibake check:  ENCODING_GUARD=0 git commit ...
hook=$(basename "$0")
here=$(cd "$(dirname "$0")" && pwd -P)

if [ "$hook" = "pre-commit" ] && [ "${ENCODING_GUARD:-1}" != "0" ]; then
  if command -v node >/dev/null 2>&1; then
    node "$here/../check-mojibake.mjs" --staged || {
      echo "encoding-guard: commit blocked. Fix with --fix (see above), or bypass once with: git commit --no-verify" >&2
      exit 1
    }
  else
    echo "encoding-guard: node is not on PATH; mojibake check skipped" >&2
  fi
fi

same_dir() { [ "$(cd "$(dirname "$1")" 2>/dev/null && pwd -P)" = "$here" ]; }

local_hook=""
common=$(git rev-parse --git-common-dir 2>/dev/null) && {
  candidate="$common/hooks/$hook"
  [ -f "$candidate" ] && [ -x "$candidate" ] && ! same_dir "$candidate" && local_hook="$candidate"
}
prev_hook=""
prev=$(git config --global --get encodingguard.previousHooksPath 2>/dev/null)
if [ -n "$prev" ]; then
  candidate="$prev/$hook"
  [ -f "$candidate" ] && [ -x "$candidate" ] && ! same_dir "$candidate" && prev_hook="$candidate"
fi

if [ -n "$prev_hook" ] && [ -n "$local_hook" ]; then
  # Both want the same stdin (pre-push, post-rewrite): buffer it once.
  tmp=$(mktemp) || exit 1
  cat > "$tmp"
  "$prev_hook" "$@" < "$tmp" || { st=$?; rm -f "$tmp"; exit $st; }
  "$local_hook" "$@" < "$tmp"; st=$?
  rm -f "$tmp"
  exit $st
fi
[ -n "$prev_hook" ] && exec "$prev_hook" "$@"
[ -n "$local_hook" ] && exec "$local_hook" "$@"
exit 0
