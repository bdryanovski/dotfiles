#!/usr/bin/env bash
#
# arch.sh - Arch Linux setup script
# Installs packages, sets up yay (AUR helper), and stows dotfiles.
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
if [[ ! -f /etc/arch-release ]]; then
    error "This script is intended for Arch Linux only."
fi

if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root. It will use sudo when needed."
fi

# --------------------------------------------------------------------------- #
# Package lists
# --------------------------------------------------------------------------- #

# Essential CLI tools (matches stow packages)
PACMAN_PACKAGES=(
    stow
    git
    zsh
    tmux
    btop
    github-cli
)

# Hyprland + Wayland ecosystem
PACMAN_PACKAGES+=(
    hyprland
    hyprlock
    hypridle
    waybar
    wofi
    swww
    xdg-desktop-portal-hyprland
    polkit-kde-agent
    brightnessctl
    playerctl
    wl-clipboard
    grim
    slurp
    mako
)

# Development tools
PACMAN_PACKAGES+=(
    base-devel
    nodejs
    npm
    python
    python-pip
    rust
)

# AUR packages (installed via yay)
AUR_PACKAGES=(
    ghostty
)

# --------------------------------------------------------------------------- #
# Install pacman packages
# --------------------------------------------------------------------------- #
install_pacman_packages() {
    info "Updating system and installing pacman packages..."
    sudo pacman -Syu --noconfirm

    local to_install=()
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        info "Installing: ${to_install[*]}"
        sudo pacman -S --noconfirm --needed "${to_install[@]}"
    else
        info "All pacman packages are already installed."
    fi
}

# --------------------------------------------------------------------------- #
# Install yay (AUR helper)
# --------------------------------------------------------------------------- #
install_yay() {
    if command -v yay &>/dev/null; then
        info "yay is already installed."
        return
    fi

    info "Installing yay..."
    local tmp_dir
    tmp_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmp_dir/yay"
    (cd "$tmp_dir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmp_dir"
    info "yay installed successfully."
}

# --------------------------------------------------------------------------- #
# Install AUR packages
# --------------------------------------------------------------------------- #
install_aur_packages() {
    if [[ ${#AUR_PACKAGES[@]} -eq 0 ]]; then
        return
    fi

    local to_install=()
    for pkg in "${AUR_PACKAGES[@]}"; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            to_install+=("$pkg")
        fi
    done

    if [[ ${#to_install[@]} -gt 0 ]]; then
        info "Installing AUR packages: ${to_install[*]}"
        yay -S --noconfirm --needed "${to_install[@]}"
    else
        info "All AUR packages are already installed."
    fi
}

# --------------------------------------------------------------------------- #
# Stow dotfiles
# --------------------------------------------------------------------------- #
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

    # Stow all packages (each top-level directory with a dot-prefixed file/dir)
    cd "$DOTFILES_DIR"
    for dir in */; do
        dir="${dir%/}"
        # Skip hidden dirs and non-stow directories
        [[ "$dir" == .* ]] && continue
        info "  stow $dir"
        stow -t "$HOME" --restow "$dir" 2>&1 || warn "Failed to stow $dir"
    done

    info "All dotfiles stowed."
}

# --------------------------------------------------------------------------- #
# Enable services
# --------------------------------------------------------------------------- #
enable_services() {
    info "Enabling services..."
}

# --------------------------------------------------------------------------- #
# Set default shell
# --------------------------------------------------------------------------- #
set_default_shell() {
    if [[ "$SHELL" != */zsh ]]; then
        info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        info "Default shell changed to zsh. Log out and back in for this to take effect."
    else
        info "zsh is already the default shell."
    fi
}

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
    info "Starting Arch Linux setup from: $DOTFILES_DIR"
    echo ""

    install_pacman_packages
    install_yay
    install_aur_packages
    stow_dotfiles
    enable_services
    set_default_shell

    echo ""
    info "Setup complete!"
    info "You may need to log out and back in for some changes to take effect."
}

main "$@"
