# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package      | Description                        | Platforms     |
|--------------|------------------------------------|---------------|
| **atuin**    | Shell history sync                 | Arch, macOS   |
| **btop**     | System monitor                     | Arch, macOS   |
| **gh**       | GitHub CLI                         | Arch, macOS   |
| **ghostty**  | Terminal emulator                  | Arch, macOS   |
| **git**      | Git config and hooks               | Arch, macOS   |
| **hypr**     | Hyprland, hyprlock, hypridle       | Arch only     |
| **opencode** | OpenCode AI tool                   | Arch, macOS   |
| **tmux**     | Terminal multiplexer               | Arch, macOS   |
| **zshrc**    | Zsh shell config                   | Arch, macOS   |

## Quick Setup

Clone the repo and run the setup script for your platform. Each script installs all
dependencies, stows every package, and applies platform-specific settings.

```bash
git clone git@github.com:bdryanovski/dotfiles.git ~/Github/dotfiles
cd ~/Github/dotfiles
```

### Arch Linux (+ Hyprland)

```bash
./arch.sh
```

What it does:

- Installs pacman packages (stow, git, zsh, tmux, btop, gh, hyprland ecosystem, dev tools)
- Installs **yay** (AUR helper) and AUR packages (ghostty)
- Stows all packages (including hypr/)
- Sets zsh as the default shell
- Configures fast key repeat via Hyprland (`repeat_rate=75`, `repeat_delay=200`)

### macOS

```bash
./macos.sh
```

What it does:

- Installs Xcode Command Line Tools
- Installs **Homebrew** and formulae (stow, git, zsh, tmux, btop, gh, node, python, rust)
- Installs casks (ghostty)
- Configures macOS defaults (fast key repeat, Finder, Dock, trackpad, screenshots)
- Stows all packages (skips hypr/ — Linux only)
- Sets Homebrew zsh as the default shell

## Manual Install

If you prefer to set things up manually:

```bash
cd ~/Github/dotfiles

# Remove existing config files that would conflict
rm -f ~/.zshrc ~/.gitconfig
rm -rf ~/.git_template ~/.zshrc_custom
rm -f ~/.config/atuin/atuin-receipt.json ~/.config/atuin/config.toml
rm -f ~/.config/gh/config.yml ~/.config/gh/hosts.yml
rm -f ~/.config/ghostty/config
rm -f ~/.config/opencode/opencode.json
rm -rf ~/.config/opencode/agent
rm -rf ~/.config/tmux
rm -f ~/.config/btop.conf ~/.config/btop.log
rm -rf ~/.config/hypr

# Stow all packages
stow -t ~ */
```

## Uninstall

Remove all symlinks:

```bash
cd ~/Github/dotfiles
stow -D -t ~ */
```

## Sync back

Adopt local changes into the repo (overwrites repo files with your local versions):

```bash
cd ~/Github/dotfiles
stow --adopt -t ~ */
```

## Usage

### Stow a single package

```bash
stow -t ~ git
```

### Remove a single package

```bash
stow -D -t ~ git
```

### Dry run (preview changes)

```bash
stow -n -v -t ~ */
```

## Adding new packages

### For `~/.config` apps (XDG style)

```bash
mkdir -p newtool/.config/newtool
# put config files in newtool/.config/newtool/
```

### For traditional dotfiles

```bash
mkdir -p vim
# put .vimrc directly in vim/
```

Then stow the new package:

```bash
stow -t ~ newtool
```
