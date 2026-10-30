#!/usr/bin/env bash
#
# common.sh - Shared helpers for the dotfiles scripts.
#
# Source it from any script:
#   source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"
#
# It sets DOTFILES_DIR, logging helpers, platform flags, a package-manager
# wrapper, and the stow helpers. Do not run it directly.

# Source once only.
[[ -n "${_DOTFILES_COMMON:-}" ]] && return 0
_DOTFILES_COMMON=1

# Repo root is the parent of this lib directory.
_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$_LIB_DIR")"

# --------------------------------------------------------------------------- #
# Output
# --------------------------------------------------------------------------- #
if [[ -t 1 ]]; then
    C_RESET=$'\033[0m'; C_BLUE=$'\033[34m'; C_YELLOW=$'\033[33m'
    C_RED=$'\033[31m'; C_GREEN=$'\033[32m'; C_DIM=$'\033[2m'
else
    C_RESET=''; C_BLUE=''; C_YELLOW=''; C_RED=''; C_GREEN=''; C_DIM=''
fi
info() { printf '%s==>%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
ok()   { printf '%s  ok%s  %s\n' "$C_GREEN" "$C_RESET" "$*"; }
skip() { printf '%sskip%s  %s %s(already installed)%s\n' "$C_DIM" "$C_RESET" "$*" "$C_DIM" "$C_RESET"; }
warn() { printf '%s warn%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
err()  { printf '%s fail%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }
die()  { err "$*"; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# --------------------------------------------------------------------------- #
# Platform and package manager
# --------------------------------------------------------------------------- #
OS="$(uname -s)"
IS_MAC=false; IS_LINUX=false; IS_ARCH=false
case "$OS" in
    Darwin) IS_MAC=true ;;
    Linux)  IS_LINUX=true; [[ -f /etc/arch-release ]] && IS_ARCH=true ;;
esac

PM=""
if   have brew;    then PM="brew"
elif have apt-get; then PM="apt"
elif have pacman;  then PM="pacman"
elif have dnf;     then PM="dnf"
elif have zypper;  then PM="zypper"
elif have apk;     then PM="apk"
fi

# pm_install <name> [apt] [pacman] [dnf] [zypper] [apk]
# The first name is the default. Pass a per-manager name only when it differs.
pm_install() {
    local b="${1:?package name required}" a="${2:-}" p="${3:-}" d="${4:-}" z="${5:-}" k="${6:-}"
    case "$PM" in
        brew)   brew install "$b" ;;
        apt)    sudo apt-get install -y "${a:-$b}" ;;
        pacman) sudo pacman -S --needed --noconfirm "${p:-$b}" ;;
        dnf)    sudo dnf install -y "${d:-$b}" ;;
        zypper) sudo zypper install -y "${z:-$b}" ;;
        apk)    sudo apk add "${k:-$b}" ;;
        *)      die "No supported package manager found. Install '$b' manually." ;;
    esac
}

# cask_install <name> : a GUI application.
cask_install() {
    local name="$1"
    if $IS_MAC && [[ "$PM" == "brew" ]]; then
        brew install --cask "$name"
    elif $IS_ARCH; then
        have yay || die "Need an AUR helper (yay) to install '$name'."
        yay -S --needed --noconfirm "$name"
    else
        die "No automatic install for '$name' on this platform."
    fi
}

# --------------------------------------------------------------------------- #
# Stow
# --------------------------------------------------------------------------- #
# Packages that do not belong on this platform.
platform_skip() {
    $IS_MAC && printf '%s\n' hypr waybar wofi
    return 0
}
is_skipped() {
    local p="$1" s
    while IFS= read -r s; do
        [[ "$p" == "$s" ]] && return 0
    done < <(platform_skip)
    return 1
}

# detect_conflicts <pkg> : print absolute machine paths that block the package.
# stow exits non-zero on conflicts, so guard it under pipefail.
detect_conflicts() {
    { stow -t "$HOME" -n --restow "$1" 2>&1 || true; } \
        | sed -nE 's/.* over existing target (.*) since .*/\1/p' \
        | while IFS= read -r rel; do
            [[ -n "$rel" ]] && printf '%s/%s\n' "$HOME" "$rel"
          done
}

# --------------------------------------------------------------------------- #
# Shell
# --------------------------------------------------------------------------- #
set_default_shell() {
    case "$SHELL" in
        */zsh) info "zsh is already the default shell."; return ;;
    esac
    local zsh_bin
    zsh_bin="$(command -v zsh)" || { warn "zsh not found. Skipping shell change."; return; }
    info "Setting zsh as the default shell..."
    if ! grep -qx "$zsh_bin" /etc/shells 2>/dev/null; then
        echo "$zsh_bin" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s "$zsh_bin"
    info "Default shell changed to zsh. Log out and back in to apply."
}
