#!/usr/bin/env bash
#
# sync.sh - Sync this machine with the dotfiles repo.
#
# One command to make $HOME match the repo. It uses GNU Stow to create symlinks.
# By default it ABORTS on conflicts (a real file where a symlink should go) and
# lists them, so nothing gets destroyed. Resolve conflicts with --backup or
# --adopt.
#
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"
cd "$DOTFILES_DIR"

usage() {
    cat <<'EOF'
sync.sh - Sync this machine with the dotfiles repo (stow).

Usage:
  ./sync.sh                 Sync all packages for this platform (safe)
  ./sync.sh git tmux        Sync only the named packages
  ./sync.sh --dry-run       Show what would change, touch nothing
  ./sync.sh --backup        Move conflicting machine files to a backup dir,
                            then symlink the repo version (repo wins)
  ./sync.sh --adopt         Pull conflicting machine files INTO the repo,
                            overwriting repo content (machine wins)
  ./sync.sh --delete        Remove the symlinks (unstow)
  ./sync.sh -h | --help     Show this help
EOF
}

# --------------------------------------------------------------------------- #
# Args
# --------------------------------------------------------------------------- #
MODE="sync"        # sync | dry | backup | adopt | delete
PACKAGES=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n) MODE="dry" ;;
        --backup)     MODE="backup" ;;
        --adopt)      MODE="adopt" ;;
        --delete|-D)  MODE="delete" ;;
        -h|--help)    usage; exit 0 ;;
        -*)           err "Unknown option: $1"; usage; exit 2 ;;
        *)            PACKAGES+=("$1") ;;
    esac
    shift
done

# Default package list: every top-level dir that is not hidden and not the lib.
if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    for dir in */; do
        dir="${dir%/}"
        [[ "$dir" == .* || "$dir" == "lib" ]] && continue
        PACKAGES+=("$dir")
    done
fi

# Drop missing and platform-skipped packages.
ACTIVE=()
for p in "${PACKAGES[@]}"; do
    if [[ ! -d "$p" ]]; then
        warn "No such package: $p (skipped)"
    elif is_skipped "$p"; then
        info "skip $p (not for $OS)"
    else
        ACTIVE+=("$p")
    fi
done
[[ ${#ACTIVE[@]} -eq 0 ]] && { warn "Nothing to do."; exit 0; }

# --------------------------------------------------------------------------- #
# Modes
# --------------------------------------------------------------------------- #
collect_all_conflicts() {
    CONFLICTS=()
    local p c line
    for p in "${ACTIVE[@]}"; do
        c="$(detect_conflicts "$p")"
        [[ -z "$c" ]] && continue
        while IFS= read -r line; do
            [[ -n "$line" ]] && CONFLICTS+=("$line")
        done <<<"$c"
    done
}

run_delete() {
    for p in "${ACTIVE[@]}"; do
        info "unstow $p"
        stow -t "$HOME" -D "$p" && ok "$p removed"
    done
    info "Done. Symlinks removed."
}

run_dry() {
    info "Dry run. No changes will be made."
    local had=0 p c line
    for p in "${ACTIVE[@]}"; do
        c="$(detect_conflicts "$p")"
        if [[ -n "$c" ]]; then
            had=1
            warn "$p has conflicts:"
            while IFS= read -r line; do printf '       %s\n' "$line"; done <<<"$c"
        else
            ok "$p clean"
        fi
    done
    [[ $had -eq 1 ]] && info "Resolve with --backup (repo wins) or --adopt (machine wins)."
}

run_sync() {
    collect_all_conflicts
    if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
        err "Aborting. These machine files block the sync:"
        for f in "${CONFLICTS[@]}"; do printf '       %s\n' "$f"; done
        echo
        info "Choose how to resolve:"
        info "  ./sync.sh --backup   move these to a backup dir, repo wins"
        info "  ./sync.sh --adopt    pull these into the repo, machine wins"
        info "  ./sync.sh --dry-run  review again"
        exit 1
    fi
    for p in "${ACTIVE[@]}"; do
        info "stow $p"
        stow -t "$HOME" --restow "$p" && ok "$p"
    done
    info "Done. Machine is in sync with the repo."
}

run_backup() {
    collect_all_conflicts
    if [[ ${#CONFLICTS[@]} -gt 0 ]]; then
        local backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
        info "Backing up ${#CONFLICTS[@]} conflicting file(s) to:"
        info "  $backup_dir"
        for f in "${CONFLICTS[@]}"; do
            [[ -e "$f" || -L "$f" ]] || continue
            local rel="${f#"$HOME"/}" dest
            dest="$backup_dir/$rel"
            mkdir -p "$(dirname "$dest")"
            mv "$f" "$dest"
            ok "moved $rel"
        done
    else
        info "No conflicts. Nothing to back up."
    fi
    for p in "${ACTIVE[@]}"; do
        info "stow $p"
        stow -t "$HOME" --restow "$p" && ok "$p"
    done
    info "Done. Repo version is now active. Old files kept in the backup dir."
}

run_adopt() {
    warn "Adopt overwrites REPO files with the machine versions."
    for p in "${ACTIVE[@]}"; do
        info "adopt + stow $p"
        stow -t "$HOME" --adopt --restow "$p" && ok "$p"
    done
    info "Done. Machine files adopted into the repo."
    info "Review with: git -C \"$DOTFILES_DIR\" diff   (git checkout to discard)"
}

case "$MODE" in
    delete) run_delete ;;
    dry)    run_dry ;;
    backup) run_backup ;;
    adopt)  run_adopt ;;
    sync)   run_sync ;;
esac
