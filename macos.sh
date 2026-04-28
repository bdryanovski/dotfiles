#!/usr/bin/env bash
#
# macos.sh - macOS setup script
# Installs Homebrew, packages, configures macOS defaults, and stows dotfiles.
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --------------------------------------------------------------------------- #
# Colors
# --------------------------------------------------------------------------- #
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# --------------------------------------------------------------------------- #
# Sanity checks
# --------------------------------------------------------------------------- #
if [[ "$(uname -s)" != "Darwin" ]]; then
    error "This script is intended for macOS only."
fi

if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root."
fi

# --------------------------------------------------------------------------- #
# Install Xcode Command Line Tools
# --------------------------------------------------------------------------- #
install_xcode_cli() {
    if xcode-select -p &>/dev/null; then
        info "Xcode Command Line Tools are already installed."
        return
    fi

    info "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    info "Xcode Command Line Tools installed."
}

# --------------------------------------------------------------------------- #
# Install Homebrew
# --------------------------------------------------------------------------- #
install_homebrew() {
    if command -v brew &>/dev/null; then
        info "Homebrew is already installed."
        return
    fi

    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    info "Homebrew installed."
}

# --------------------------------------------------------------------------- #
# Package lists
# --------------------------------------------------------------------------- #

# Essential CLI tools (matches stow packages)
BREW_FORMULAE=(
    stow
    git
    zsh
    tmux
    btop
    gh
)

# Development tools
BREW_FORMULAE+=(
    node
    python
    rust
)

# Cask apps (GUI applications)
BREW_CASKS=(
    ghostty
)

# --------------------------------------------------------------------------- #
# Install Homebrew packages
# --------------------------------------------------------------------------- #
install_brew_formulae() {
    info "Updating Homebrew and installing formulae..."
    brew update

    local to_install=()
    for pkg in "${BREW_FORMULAE[@]}"; do
        if ! brew list --formula "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        info "Installing formulae: ${to_install[*]}"
        brew install "${to_install[@]}"
    else
        info "All formulae are already installed."
    fi
}

# --------------------------------------------------------------------------- #
# Install Homebrew casks
# --------------------------------------------------------------------------- #
install_brew_casks() {
    local to_install=()
    for app in "${BREW_CASKS[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            to_install+=("$app")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        info "Installing casks: ${to_install[*]}"
        brew install --cask "${to_install[@]}"
    else
        info "All casks are already installed."
    fi
}

# --------------------------------------------------------------------------- #
# macOS defaults (keyboard, trackpad, Finder, etc.)
# --------------------------------------------------------------------------- #
configure_macos_defaults() {
    info "Configuring macOS defaults..."

    # -- Keyboard ----------------------------------------------------------- #
    # Fast key repeat rate (equivalent to repeat_rate = 75 on Hyprland)
    defaults write NSGlobalDomain KeyRepeat -int 1            # fastest repeat
    defaults write NSGlobalDomain InitialKeyRepeat -int 15    # shortest delay before repeat
    # Disable press-and-hold for special characters (enables key repeat everywhere)
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # -- Trackpad ----------------------------------------------------------- #
    # Enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    # Natural scroll direction
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # -- Finder ------------------------------------------------------------- #
    # Show file extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    # Default to list view
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
    # Disable warning when changing file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # -- Dock --------------------------------------------------------------- #
    # Auto-hide dock
    defaults write com.apple.dock autohide -bool true
    # Remove dock auto-hide delay
    defaults write com.apple.dock autohide-delay -float 0
    # Speed up dock animation
    defaults write com.apple.dock autohide-time-modifier -float 0.3
    # Minimize to application
    defaults write com.apple.dock minimize-to-application -bool true

    # -- Screenshots -------------------------------------------------------- #
    # Save screenshots to ~/Screenshots
    mkdir -p "$HOME/Screenshots"
    defaults write com.apple.screencapture location -string "$HOME/Screenshots"
    # Save as PNG
    defaults write com.apple.screencapture type -string "png"
    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    # -- Misc --------------------------------------------------------------- #
    # Disable the "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    info "macOS defaults configured. Some changes require logout or restart."
}

# --------------------------------------------------------------------------- #
# Stow dotfiles
# --------------------------------------------------------------------------- #

# Stow packages to skip on macOS (Linux/Hyprland only)
SKIP_PACKAGES=("hypr", "wofi", "waybar")

stow_dotfiles() {
    info "Stowing dotfiles..."

    # Remove existing files that would conflict with stow symlinks
    local conflicts=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
    )
    for f in "${conflicts[@]}"; do
        if [[ -f "$f" && ! -L "$f" ]]; then
            warn "Removing existing file: $f (not a symlink)"
            rm -f "$f"
        fi
    done

    # Stow all packages except skipped ones
    cd "$DOTFILES_DIR"
    for dir in */; do
        dir="${dir%/}"
        # Skip hidden dirs
        [[ "$dir" == .* ]] && continue

        # Skip Linux-only packages
        local skip=false
        for s in "${SKIP_PACKAGES[@]}"; do
            if [[ "$dir" == "$s" ]]; then
                skip=true
                break
            fi
        done
        if $skip; then
            info "  skip $dir (Linux only)"
            continue
        fi

        info "  stow $dir"
        stow -t "$HOME" --restow "$dir" 2>&1 || warn "Failed to stow $dir"
    done

    info "All dotfiles stowed."
}

# --------------------------------------------------------------------------- #
# Set default shell
# --------------------------------------------------------------------------- #
set_default_shell() {
    if [[ "$SHELL" != */zsh ]]; then
        info "Setting zsh as default shell..."
        # Ensure Homebrew zsh is in /etc/shells
        local brew_zsh
        brew_zsh="$(brew --prefix)/bin/zsh"
        if [[ -x "$brew_zsh" ]] && ! grep -q "$brew_zsh" /etc/shells; then
            echo "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
        fi
        chsh -s "$brew_zsh"
        info "Default shell changed to zsh."
    else
        info "zsh is already the default shell."
    fi
}

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    info "Starting macOS setup from: $DOTFILES_DIR"
    echo ""

    install_xcode_cli
    install_homebrew
    install_brew_formulae
    install_brew_casks
    configure_macos_defaults
    stow_dotfiles
    set_default_shell

    echo ""
    info "Setup complete!"
    info "Some macOS defaults require logout or restart to take effect."
}

main "$@"
