max_pr_words=120
enforce=false

mode=${1-}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
problems=$tmp/problems
: >"$problems"

problem() { printf '  %s\n' "$*" >>"$problems"; }

# Lints file $1. Line N of file $2 says where line N of $1 came from.
vale_file() {
  vale --no-global --config="$VALE_INI" --output=JSON "$1" |
    jq -r --rawfile locs "$2" '($locs|split("\n")) as $l | .[][] | "  \($l[.Line-1]): \(.Message)"' >>"$problems" || true
}

# Lints the commit messages in $tmp/msg, one file per commit.
vale_msgs() {
  vale --no-global --config="$VALE_INI" --output=JSON "$tmp/msg" |
    jq -r 'to_entries[] | (.key|split("/")|last|rtrimstr(".txt")) as $c | .value[] | "  commit \($c) line \(.Line): \(.Message)"' >>"$problems" || true
}

# Prints the lines added by `git diff ARGS` as "path:line<US>text".
added() {
  git diff -U0 --no-color --no-ext-diff --src-prefix=a/ --dst-prefix=b/ "$@" |
    gawk '/^\+\+\+ /{f=substr($0,7);next} /^@@/{split($3,a,",");n=substr(a[1],2)+0;next} /^\+/{print f":"n"\037"substr($0,2);n++}'
}

# Checks the comments and Markdown lines added by `git diff ARGS`.
check_lines() {
  added "$@" -- '*.ts' '*.tsx' '*.js' '*.mjs' '*.cjs' '*.md' ':!*.d.ts' ':!*/fixtures/*' ':!*/expected/*' |
    gawk -F'\037' -v dir="$tmp" -v hist="$problems" '
      { t = $2; c = ""; md = $1 ~ /\.md:[0-9]+$/ }
      md { c = t }
      !md && t ~ /^[ \t]*(\/\/|\/\*|\*)/ { c = t; sub(/^[ \t]*(\/\/+|\/\*+|\*+)[ \t]?/, "", c) }
      !md && c == "" && match(t, /[ \t]\/\/[ \t]/) { c = substr(t, RSTART + 4) }
      c == "" { next }
      { sub(/[ \t]*\*\/[ \t]*$/, "", c) }
      !md && c !~ /@example/ {
        h = tolower(c); gsub(/"[^"]*"|`[^`]*`/, "", h)
        if (h ~ /\y(pr|issue|ticket) ?#?[0-9]+|#[0-9][0-9]+|\y20[0-9][0-9]-[01][0-9](-[0-3][0-9])?([^0-9t-]|$)|\ypreviously\y|\yadded (in|for)\y/)
          print "  " $1 ": comment carries history: " c >> hist
      }
      { out = dir "/" (md ? "docs.md" : "comments.markdown")
        f = $1; sub(/:[0-9]+$/, "", f); l = substr($1, length(f) + 2) + 0
        if (f != pf[out] || l != pl[out] + 1) { print "" > out; print "" > (out ".loc") }
        print c > out; print $1 > (out ".loc"); pf[out] = f; pl[out] = l }'
  for f in "$tmp/docs.md" "$tmp/comments.markdown"; do
    if [ -s "$f" ]; then vale_file "$f" "$f.loc"; fi
    rm -f "$f" "$f.loc"
  done

}

commit_msg() {
  mkdir -p "$tmp/msg"
  sed '/^# -\{24\} >8 -\{24\}$/,$d' "$1" | git stripspace --strip-comments >"$tmp/msg/message.txt"
  vale_msgs
  # A merge brings in other people's lines. Check only its message.
  if [ ! -e "$(git rev-parse --git-path MERGE_HEAD)" ]; then check_lines --cached; fi
}

# Counts words in Markdown, without code, inline code and URLs.
prose_words() {
  gawk '/^[ \t]*```/ { code = !code; next }
    !code { gsub(/`[^`]*`|https?:\/\/[^ )]+|\]\([^)]*\)/, ""); for (i = 1; i <= NF; i++) if ($i ~ /[[:alpha:]]/) n++ }
    END { print n + 0 }'
}

# Checks the title and body of gh pr and issue commands and the body field of gh api calls.
gh_text() {
  local pos=() prev="" a sub title="" body="" file="" refused="" n
  for a in "$@"; do
    if [[ ${#pos[@]} -lt 2 && $a != -* && $prev != -R && $prev != --repo ]]; then pos+=("$a"); fi
    if [ "${pos[0]-}" = api ]; then
      case $prev in -f | -F | --field | --raw-field) a=--field=$a ;; esac
      case $a in
        --field=body=@* | --raw-field=body=@*) file=${a#*=body=@} ;;
        --field=body=* | --raw-field=body=*) body=${a#*=body=} ;;
        --field=title=* | --raw-field=title=*) title=${a#*=title=} ;;
      esac
    else
      case $prev in
        -t | --title) title=$a ;;
        -b | --body) body=$a ;;
        -F | --body-file) file=$a ;;
      esac
      case $a in
        --title=*) title=${a#*=} ;;
        --body=*) body=${a#*=} ;;
        --body-file=*) file=${a#*=} ;;
        --fill | --fill-first | --fill-verbose | -T | --template | --template=*) refused=$a ;;
      esac
    fi
    prev=$a
  done
  sub="${pos[0]-} ${pos[1]-}"
  case $sub in
    "pr create" | "pr edit" | "pr comment" | "pr review" | "issue create" | "issue edit" | "issue comment" | "api "*) ;;
    *) return 0 ;;
  esac
  if [ "$file" = - ]; then refused="text from stdin"; fi
  if [ -n "$refused" ]; then
    problem "gh $sub with $refused: ai-check cannot read this text. Write the text to a file and pass the file."
    return 0
  fi
  if [ -n "$file" ]; then body=$(cat "$file"); fi
  if [ -n "$title$body" ]; then
    { if [ -n "$title" ]; then printf '# %s\n\n' "$title"; fi; printf '%s\n' "$body"; } >"$tmp/text.md"
    gawk '{print "gh text line " NR}' "$tmp/text.md" >"$tmp/text.loc"
    vale_file "$tmp/text.md" "$tmp/text.loc"
  fi
  if [ "$sub" = "pr create" ] || [ "$sub" = "pr edit" ]; then
    n=$(prose_words <<<"$body")
    if [ "$n" -gt "$max_pr_words" ]; then
      problem "PR body has $n words (limit $max_pr_words). Say what changed and why. Details go in the issue."
    fi
  fi
}

case $mode in
  commit-msg) commit_msg "$2" ;;
  gh) gh_text "${@:2}" ;;
  *)
    echo "usage: ai-check commit-msg FILE | gh ARGS..." >&2
    exit 2
    ;;
esac

[ -s "$problems" ] || exit 0
if [ -n "${AI_CHECK_OVERRIDE:-}" ]; then
  state=${XDG_STATE_HOME:-$HOME/.local/state}/ai-check
  { mkdir -p "$state" && printf '%s\t%s\t%s\t%s\n' "$(date -Is)" "$PWD" "$mode" "$AI_CHECK_OVERRIDE" >>"$state/overrides.log"; } || true
  { echo "ai-check: overridden ($AI_CHECK_OVERRIDE). Findings:"; cat "$problems"; } >&2
  exit 0
fi
if [ "$enforce" != true ]; then
  { echo "ai-check: these lines break Arto's writing and code rules. Fix them. For a commit, amend it:"; cat "$problems"; } >&2
  exit 0
fi
{
  echo "ai-check: blocked by Arto's writing and code rules:"
  cat "$problems"
  echo "Fix these and try again. If a finding is wrong, stop and show Arto these findings."
} >&2
exit 1
