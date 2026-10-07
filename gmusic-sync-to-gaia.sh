#!/usr/bin/env bash
# One-way, entry-by-entry mirror of the G.Music working environment to Gaia.
#
# This script intentionally never uses --delete. It excludes credentials and
# process-local PID/lock files. Each declared path gets its own rsync invocation
# so a transfer can be selected, audited, retried, or stopped independently.
set -Eeuo pipefail

REMOTE="${GMUSIC_SYNC_REMOTE:-gmusic@gaia}"
DEST_ROOT="${GMUSIC_SYNC_DEST_ROOT:-/home/gmusic}"
SOURCE_ROOT="${GMUSIC_SYNC_SOURCE_ROOT:-/home/gmusic}"
TIER="all"
DRY_RUN=0
VERBOSE=0
LIST_ONLY=0
ONLY=()

usage() {
  cat <<'EOF'
Usage: gmusic-sync-to-gaia.sh [options]

One-way sync from /home/gmusic on this host to gmusic@gaia:/home/gmusic.
The default syncs all declared tiers. No destination files are deleted.

Options:
  --tier core|continuity|corpus|all  Select one tier (default: all)
  --only RELATIVE_PATH               Sync exactly one declared entry; repeatable
  --dry-run                          Show rsync changes without writing
  --verbose                          Itemize transferred files
  --list                             List declared entries and exit
  --remote USER@HOST                 Override gmusic@gaia
  --destination PATH                 Override /home/gmusic on the remote
  -h, --help                         Show this help

Examples:
  ./gmusic-sync-to-gaia.sh --dry-run --tier core
  ./gmusic-sync-to-gaia.sh --only .agents
  ./gmusic-sync-to-gaia.sh --only compositions-jamai --verbose
EOF
}

# tier|kind|path relative to /home/gmusic
ENTRIES=(
  "core|dir|.agents"
  "core|dir|.claude/projects/-home-gmusic/memory"
  "core|dir|salix/repos/jamai-core"
  "core|dir|salix/repos/miadi-orchestration-kit"
  "core|dir|workspace/jamai-melody"

  "continuity|dir|.local/state/episode-voice"
  "continuity|file|.config/systemd/user/jamai-watch.service"
  "continuity|file|.config/systemd/user/william-watch.service"
  "continuity|file|salix/production/ngrok-mux/nginx.conf"
  "continuity|dir|salix/production/ngrok-mux/static/jamai"

  "corpus|dir|compositions-jamai"
  "corpus|dir|compositions-william"
  "corpus|dir|compositions-episodes"
  "corpus|dir|compositions-abies"
  "corpus|dir|compositions-aureon"
  "corpus|dir|Recordings-jamai"
  "corpus|dir|Recordings-william"
  "corpus|dir|Recordings-episodes"
  "corpus|dir|Recordings-abies"
  "corpus|dir|Recordings-aureon"
  "corpus|dir|atelier-jerry-origin-1937aa47"
)

while (($#)); do
  case "$1" in
    --tier)
      [[ $# -ge 2 ]] || { echo "--tier requires a value" >&2; exit 2; }
      TIER="$2"; shift 2 ;;
    --only)
      [[ $# -ge 2 ]] || { echo "--only requires a path" >&2; exit 2; }
      ONLY+=("${2%/}"); shift 2 ;;
    --dry-run) DRY_RUN=1; shift ;;
    --verbose) VERBOSE=1; shift ;;
    --list) LIST_ONLY=1; shift ;;
    --remote)
      [[ $# -ge 2 ]] || { echo "--remote requires USER@HOST" >&2; exit 2; }
      REMOTE="$2"; shift 2 ;;
    --destination)
      [[ $# -ge 2 ]] || { echo "--destination requires a path" >&2; exit 2; }
      DEST_ROOT="${2%/}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$TIER" in core|continuity|corpus|all) ;; *) echo "Invalid tier: $TIER" >&2; exit 2 ;; esac
command -v rsync >/dev/null || { echo "rsync is required locally" >&2; exit 1; }
command -v ssh >/dev/null || { echo "ssh is required locally" >&2; exit 1; }

is_selected() {
  local tier="$1" rel="$2" wanted
  [[ "$TIER" == all || "$TIER" == "$tier" ]] || return 1
  ((${#ONLY[@]} == 0)) && return 0
  for wanted in "${ONLY[@]}"; do
    [[ "$rel" == "$wanted" ]] && return 0
  done
  return 1
}

if ((LIST_ONLY)); then
  printf '%-11s %-4s %s\n' TIER TYPE PATH
  for entry in "${ENTRIES[@]}"; do
    IFS='|' read -r tier kind rel <<<"$entry"
    printf '%-11s %-4s %s\n' "$tier" "$kind" "$rel"
  done
  exit 0
fi

# Reject misspelled --only paths instead of silently doing nothing.
for wanted in "${ONLY[@]}"; do
  found=0
  for entry in "${ENTRIES[@]}"; do
    IFS='|' read -r _ _ rel <<<"$entry"
    [[ "$wanted" == "$rel" ]] && { found=1; break; }
  done
  ((found)) || { echo "Not a declared sync entry: $wanted" >&2; exit 2; }
done

SSH=(ssh -o BatchMode=yes -o ConnectTimeout=15)
RSYNC=(rsync --archive --mkpath --human-readable --partial --stats)
((DRY_RUN)) && RSYNC+=(--dry-run)
((VERBOSE)) && RSYNC+=(--itemize-changes)

# These apply at every tree depth. Secrets are provisioned separately on Gaia.
EXCLUDES=(
  --exclude=.env
  --exclude=.ssh/
  --exclude='*.pid'
  --exclude='*.lock'
  --exclude=__pycache__/
  --exclude=.cache/
  --exclude=node_modules/
  --exclude=.rsync-partial/
)

"${SSH[@]}" "$REMOTE" "test -d '$DEST_ROOT' && command -v rsync >/dev/null" || {
  echo "Remote preflight failed for $REMOTE:$DEST_ROOT" >&2
  exit 1
}

selected=0
failed=0
for entry in "${ENTRIES[@]}"; do
  IFS='|' read -r tier kind rel <<<"$entry"
  is_selected "$tier" "$rel" || continue
  selected=$((selected + 1))
  src="$SOURCE_ROOT/$rel"
  dest="$DEST_ROOT/$rel"

  if [[ "$kind" == dir ]]; then
    [[ -d "$src" ]] || { echo "MISSING directory: $src" >&2; failed=$((failed + 1)); continue; }
    extra_excludes=()
    [[ "$rel" == atelier-jerry-origin-1937aa47 ]] && extra_excludes+=(--exclude=03-rendered/)
    printf '\n[%s] %s/ -> %s:%s/\n' "$tier" "$src" "$REMOTE" "$dest"
    if ! "${RSYNC[@]}" "${EXCLUDES[@]}" "${extra_excludes[@]}" "$src/" "$REMOTE:$dest/"; then
      failed=$((failed + 1))
    fi
  else
    [[ -f "$src" ]] || { echo "MISSING file: $src" >&2; failed=$((failed + 1)); continue; }
    printf '\n[%s] %s -> %s:%s\n' "$tier" "$src" "$REMOTE" "$dest"
    if ! "${RSYNC[@]}" "${EXCLUDES[@]}" "$src" "$REMOTE:$dest"; then
      failed=$((failed + 1))
    fi
  fi
done

((selected > 0)) || { echo "No entries selected" >&2; exit 2; }
if ((failed > 0)); then
  echo "Sync completed with $failed failed entr$( ((failed == 1)) && echo y || echo ies )." >&2
  exit 1
fi
printf '\nSync complete: %d independent entries, destination %s:%s, delete disabled.\n' \
  "$selected" "$REMOTE" "$DEST_ROOT"
