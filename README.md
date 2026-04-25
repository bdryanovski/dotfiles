# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

- **atuin** - shell history sync
- **btop** - system monitor
- **gh** - GitHub CLI
- **ghostty** - terminal emulator
- **git** - git config and hooks
- **opencode** - OpenCode AI tool
- **tmux** - terminal multiplexer
- **zshrc** - zsh shell config

## Install

Clone the repo and run stow. Existing files will be removed and replaced with symlinks.

```bash
git clone git@github.com:bdryanovski/dotfiles.git ~/Github/dotfiles
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
