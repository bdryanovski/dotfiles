# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package      | Description                             | Platforms   |
| ------------ | --------------------------------------- | ----------- |
| **atuin**    | Shell history sync                      | Arch, macOS |
| **btop**     | System monitor                          | Arch, macOS |
| **gh**       | GitHub CLI                              | Arch, macOS |
| **ghostty**  | Terminal emulator                       | Arch, macOS |
| **git**      | Git config and hooks                    | Arch, macOS |
| **hypr**     | Hyprland, hyprlock, hypridle            | Arch only   |
| **opencode** | OpenCode AI tool                        | Arch, macOS |
| **tmux**     | Terminal multiplexer                    | Arch, macOS |
| **zshrc**    | Zsh shell config                        | Arch, macOS |
| **agents**   | Codding Agents skills and configuration | Arch, macOS |

## Scripts

| Script           | Job                                                        |
| ---------------- | ---------------------------------------------------------- |
| `install.sh`     | Install tools for this platform, then sync config          |
| `sync.sh`        | Symlink (stow) the config into `$HOME`                      |
| `lib/common.sh`  | Shared helpers. Sourced by the others. Do not run directly  |

## Quick Setup

Clone the repo and run one command. It works on macOS and Arch Linux.

```bash
git clone git@github.com:bdryanovski/dotfiles.git ~/Github/dotfiles
cd ~/Github/dotfiles
./install.sh
```

What `install.sh` does:

- Bootstraps the platform. macOS: Xcode CLI, Homebrew, macOS defaults. Arch: pacman update, yay, Hyprland ecosystem.
- Installs each wanted tool. It skips tools that are already present.
- Syncs config with `sync.sh`.
- Sets zsh as the default shell.

It is idempotent. Run it again any time.

```bash
./install.sh              # bootstrap + install all wanted tools + sync
./install.sh atuin tmux   # only these tools (no bootstrap)
./install.sh --no-sync    # install tools only, skip stow
./install.sh --list       # show wanted tools and their config package
```

## Choose what you want

Edit the `declare_wants` section near the top of `install.sh`. Add or remove one
line per tool.

```bash
#   want <cmd> <install> [stow-pkg]
want tmux     pm                            tmux
want gh       pm:gh:github-cli:github-cli   gh
want atuin    "sh:curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh"   atuin
want ghostty  cask                          ghostty
want_config   agents                        # config only, nothing to install
```

Install methods:

- `pm` - package manager, same name on every platform.
- `pm:brew:apt:pacman` - per-manager names. An empty slot reuses `<cmd>`.
- `cask` - GUI app. Homebrew cask on macOS, AUR on Arch.
- `sh:<command>` - run this shell command (for tools with their own installer).

The optional third field is the stow package to link. Use `-` for none.

## Sync (one command)

Use `sync.sh` to make this machine match the repo. It skips Linux-only packages
on macOS and is safe by default. On a conflict (a real file where a symlink
should go) it aborts and lists the files. Nothing gets deleted.

```bash
cd ~/Github/dotfiles
./sync.sh              # sync all packages for this platform
./sync.sh git tmux    # sync only named packages
./sync.sh --dry-run   # preview, change nothing
```

Resolve conflicts:

```bash
./sync.sh --backup    # move machine files to ~/.dotfiles-backup, repo wins
./sync.sh --adopt     # pull machine files into the repo, machine wins
./sync.sh --delete    # remove the symlinks (unstow)
```

- `--backup` keeps your old files in a timestamped dir under `~/.dotfiles-backup`.
- `--adopt` overwrites repo files. Review with `git diff` before you commit.

## Uninstall

Remove all symlinks:

```bash
cd ~/Github/dotfiles
./sync.sh --delete
```

## Sync back

Pull local changes into the repo. This overwrites repo files with your local
versions. Review with `git diff` before you commit.

```bash
cd ~/Github/dotfiles
./sync.sh --adopt
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
