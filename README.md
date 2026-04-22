# dotfiles

### Setup

```bash
stow .
```

### Sync back

```bash
stow --adopt -t ~ zshrc git tmux btop atuin gh ghostty opencode
```

### Set

```bash
stow -t ~ zshrc git tmux btop atuin gh ghostty opencode
```

### How to Use

#### Stow all packages at once

```bash
cd ~/dotfiles
stow */
```

#### Or stow individual packages

```bash
stow git ghostty tmux zshrc
```

#### Remove symlinks for a package

```bash
stow -D git
```

#### Preview what would happen (dry run)

```bash
stow -n -v git
```

### Adding New Tools

When adding a new tool, follow this pattern:

#### For ~/.config apps (modern XDG style)

```bash
mkdir -p newtool/.config/newtool
```

put config files in newtool/.config/newtool/

### For traditional dotfiles

```bash
mkdir -p vim
```

put .vimrc directly in vim/
