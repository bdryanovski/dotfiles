#!/usr/bin/env bash
#
# install.sh - Install tools, then sync their config. One entry point.
#
# Cross-platform and idempotent. It bootstraps the platform (Homebrew on macOS,
# pacman and yay on Arch), installs the tools you list below, then hands config
# over to ./sync.sh (stow). Safe to run many times. Installed tools are skipped.
#
# Usage:
#   ./install.sh                Bootstrap, install every wanted tool, then sync
#   ./install.sh atuin tmux     Only the named tools (and their config)
#   ./install.sh --no-sync      Install tools only, skip the stow step
#   ./install.sh --list         Show wanted tools and their config package
#   ./install.sh -h | --help    Show this help
#
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"
cd "$DOTFILES_DIR"

# =========================================================================== #
#  What I want on this machine.  Edit these lines.
#
#    want <cmd> <install> [stow-pkg]
#
#    <cmd>       the command used to check "is it installed?"
#    <install>   pm                     package manager, same name
#                pm:brew:apt:pacman     per-manager names (empty = reuse <cmd>)
#                cask                    GUI app (brew cask on macOS, AUR on Arch)
#                sh:<command>           run this shell command
#    [stow-pkg]  config package to stow (default: <cmd>, use '-' for none)
#
#    want_config <pkg>   config only, nothing to install (just stow it)
# =========================================================================== #
declare_wants() {
    # Base tools
    want stow     pm                            -
    want git      pm                            git
    want zsh      pm                            zshrc
    want tmux     pm                            tmux
    want btop     pm                            btop
    want gh       pm:gh:github-cli:github-cli   gh
    want eza      pm                            -
    want fzf      pm                            -

    # Tools with their own installer
    want atuin    "sh:curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh"   atuin
    want opencode "sh:curl -fsSL https://opencode.ai/install | bash"                       opencode

    # GUI apps
    want ghostty  cask                          ghostty

    # Language toolchains
    want node     pm:node:nodejs:nodejs         -
    want python3  pm:python:python:python       -
    want cargo    pm:rust:rust:rust             -

    # Config-only packages (no tool to install)
    want_config agents
    want_config docs
    want_config fonts

    # Linux desktop (Hyprland) — only on Arch
    if $IS_ARCH; then
        want waybar pm waybar
        want wofi   pm wofi
        want Hyprland pm:::hyprland hypr   # binary is "Hyprland"; package is "hyprland"
    fi
}

# =========================================================================== #
#  want engine
# =========================================================================== #
WANT_CMD=(); WANT_INSTALL=(); WANT_PKG=()

want() {
    WANT_CMD+=("$1")
    WANT_INSTALL+=("$2")
    WANT_PKG+=("${3:-$1}")
}
want_config() {
    WANT_CMD+=("")           # empty cmd = nothing to install
    WANT_INSTALL+=("none")
    WANT_PKG+=("$1")
}

install_one() {
    local cmd="$1" spec="$2"
    info "Installing $cmd..."
    case "$spec" in
        pm)   pm_install "$cmd" ;;
        pm:*) local _ b a p d z k; IFS=: read -r _ b a p d z k <<<"$spec"
              pm_install "${b:-$cmd}" "$a" "$p" "$d" "$z" "$k" ;;
        cask) cask_install "$cmd" ;;
        sh:*) eval "${spec#sh:}" ;;
        *)    warn "Unknown install spec for $cmd: $spec"; return 1 ;;
    esac
}

# wanted "$name" : is this cmd/pkg in the selected set? (empty set = all)
wanted() {
    [[ ${#SELECTED[@]} -eq 0 ]] && return 0
    local s
    for s in "${SELECTED[@]}"; do [[ "$s" == "$1" ]] && return 0; done
    return 1
}

STOW_PKGS=(); FAILED=()
process_wants() {
    local i cmd spec pkg
    for i in "${!WANT_PKG[@]}"; do
        cmd="${WANT_CMD[$i]}"; spec="${WANT_INSTALL[$i]}"; pkg="${WANT_PKG[$i]}"

        # Honor a selection by cmd or by package name.
        if [[ ${#SELECTED[@]} -gt 0 ]]; then
            wanted "$cmd" || wanted "$pkg" || continue
        fi

        # Install step (skip when no cmd, already present, or config-only).
        if [[ -n "$cmd" && "$spec" != "none" ]]; then
            if have "$cmd"; then
                skip "$cmd"
            elif ! install_one "$cmd" "$spec"; then
                err "Failed to install $cmd"
                FAILED+=("$cmd")
            fi
        fi

        # Collect its stow package.
        [[ "$pkg" != "-" ]] && STOW_PKGS+=("$pkg")
    done
}

# =========================================================================== #
#  Platform bootstrap
# =========================================================================== #
bootstrap_macos() {
    # Xcode command line tools
    if ! xcode-select -p &>/dev/null; then
        info "Installing Xcode Command Line Tools..."
        xcode-select --install || true
        until xcode-select -p &>/dev/null; do sleep 5; done
    fi
    # Homebrew
    if ! have brew; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
        PM="brew"
    else
        info "Updating Homebrew..."
        brew update || warn "brew update failed (continuing anyway)"
    fi
}

bootstrap_arch() {
    info "Updating system (pacman)..."
    sudo pacman -Syu --noconfirm
    if ! have yay; then
        info "Installing yay (AUR helper)..."
        local tmp; tmp="$(mktemp -d)"
        git clone https://aur.archlinux.org/yay.git "$tmp/yay"
        ( cd "$tmp/yay" && makepkg -si --noconfirm )
        rm -rf "$tmp"
    fi
    # Hyprland ecosystem packages without a checkable binary name.
    info "Installing Hyprland ecosystem..."
    sudo pacman -S --needed --noconfirm \
        hyprlock hypridle swww xdg-desktop-portal-hyprland polkit-kde-agent \
        brightnessctl playerctl wl-clipboard grim slurp mako base-devel
}

configure_macos_defaults() {
    info "Configuring macOS defaults..."

    # Keyboard: fast key repeat, repeat everywhere.
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Trackpad: tap to click, natural scroll.
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # Finder: extensions, hidden files, path and status bar, list view.
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # Dock: auto-hide, no delay, faster animation.
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0.3
    defaults write com.apple.dock minimize-to-application -bool true

    # Screenshots: PNG to ~/Screenshots, no shadow.
    mkdir -p "$HOME/Screenshots"
    defaults write com.apple.screencapture location -string "$HOME/Screenshots"
    defaults write com.apple.screencapture type -string "png"
    defaults write com.apple.screencapture disable-shadow -bool true

    # Misc.
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    info "macOS defaults set. Some changes need a logout or restart."
}

# =========================================================================== #
#  Args
# =========================================================================== #
DO_SYNC=1
SELECTED=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-sync) DO_SYNC=0 ;;
        --list)
            declare_wants
            for i in "${!WANT_PKG[@]}"; do
                printf '%-12s -> %s\n' "${WANT_CMD[$i]:-(config)}" "${WANT_PKG[$i]}"
            done
            exit 0 ;;
        -h|--help) sed -n '3,14p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
        -*)        die "Unknown option: $1" ;;
        *)         SELECTED+=("$1") ;;
    esac
    shift
done

[[ $EUID -eq 0 ]] && die "Do not run as root. The script uses sudo when needed."

# =========================================================================== #
#  Run
# =========================================================================== #
info "Platform: $OS   Package manager: ${PM:-none}"

# Bootstrap only on a full run (no explicit tool selection).
if [[ ${#SELECTED[@]} -eq 0 ]]; then
    $IS_MAC  && bootstrap_macos
    $IS_ARCH && bootstrap_arch
fi

declare_wants
process_wants

[[ ${#FAILED[@]} -gt 0 ]] && warn "Need manual attention: ${FAILED[*]}"

if $IS_MAC && [[ ${#SELECTED[@]} -eq 0 ]]; then
    configure_macos_defaults
fi

if [[ $DO_SYNC -eq 1 && ${#STOW_PKGS[@]} -gt 0 ]]; then
    info "Syncing config (stow)..."
    "$DOTFILES_DIR/sync.sh" "${STOW_PKGS[@]}"
elif [[ $DO_SYNC -eq 0 ]]; then
    info "Skipping sync (--no-sync)."
fi

set_default_shell
info "Done."
