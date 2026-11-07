# Source this file in Bash. Only Bash builtins and Git are needed.
git_ai_json_string() {
  local value=$1 char code i
  printf '"'
  for ((i=0; i<${#value}; i++)); do
    char=${value:i:1}
    case "$char" in
      '"') printf '\\"' ;;
      '\') printf '\\\\' ;;
      *)
        printf -v code '%d' "'$char"
        if ((code < 32)); then printf '\\u%04x' "$code"; else printf '%s' "$char"; fi ;;
    esac
  done
  printf '"'
}

git_ai_edit() (
  # repo harness model session transcript-json path... -- command args...
  local repo=$1 harness=$2 model=$3 session=$4 transcript=$5
  shift 5
  [[ -n $model && -n $session && -n $transcript && $harness =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || return 2
  local paths='[' separator='' path
  while (($#)) && [[ $1 != -- ]]; do
    path=$(git_ai_json_string "$1")
    paths+="$separator$path"; separator=','; shift
  done
  [[ $paths != '[' && ${1-} == -- ]] || return 2
  paths+=']'; shift
  (($#)) || return 2
  cd -- "$repo" || return
  git rev-parse --show-toplevel >/dev/null || return
  if ! command -v git-ai >/dev/null 2>&1; then
    printf '%s\n' 'git-ai unavailable; edit will have no checkpoint.' >&2
    "$@"; return $?
  fi
  local cwd before after edit_status=0
  cwd=$(git_ai_json_string "$PWD")
  printf -v before '{"type":"human","repo_working_dir":%s,"will_edit_filepaths":%s}' "$cwd" "$paths"
  printf '%s\n' "$before" | git ai checkpoint agent-v1 --hook-input stdin || return
  # A failed command can still have written files: always checkpoint afterward.
  "$@" || edit_status=$?
  printf -v after '{"type":"ai_agent","repo_working_dir":%s,"agent_name":%s,"model":%s,"conversation_id":%s,"transcript":%s,"edited_filepaths":%s}' \
    "$cwd" "$(git_ai_json_string "$harness")" "$(git_ai_json_string "$model")" \
    "$(git_ai_json_string "$session")" "$transcript" "$paths"
  # transcript must be JSON from the harness serializer, sanitized and validated there.
  printf '%s\n' "$after" | git ai checkpoint agent-v1 --hook-input stdin || return
  return "$edit_status"
)
