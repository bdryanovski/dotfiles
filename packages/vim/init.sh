#!/bin/bash

source ./interface.sh

VERSION="2.1.0"

function banner() {
  echo "  "
  echo "                                                      ╔▄▄▄                      "
  echo "                                                      ╚▀▀▀                      "
  echo "    .,  ,▄▄▄,       ╓▄▄▄,       ,▄▄▄▄   ]▓▓▄      ▄▓▓P╔▄▄▄  ▓▓▄ ▄▓██▄  ▄▄██▓▄   "
  echo "    ▐█#▀─   ╙█µ  ,█▀─   └▀▌   ▓▀╙   └╙█▄ ╟██▌    ▐███ ╟███  ████▀▀▀█████▀▀▀███▄ "
  echo "    ▐█       ╟▌  █─       ╟▌ █▌        █▌ ███▄  ]███  ╟███  ███    ▐███    ╟██▌ "
  echo "    ▐█       ▐▌ ▐█╙╙╙╙╙╙╙╙╙└j█         ╫█  ███  ███   ╟███  ███    ]███    ╟██▌ "
  echo "    ▐█       ▐▌  █           █µ        █▌   ███▓██⌐   ╟███  ███    ]███    ╟██▌ "
  echo "    ▐█       ▐▌  ╙█▄      ▄  ╙█▄     ,▓▀    ╙████╛    ╟███  ███    ]███    ╟██▌ "
  echo "    ╙▀       └▀    └╙▀▀▀▀╙     └╙▀▀▀▀╙       ╙╙╙╙     ╙▀▀▀  ▀▀▀     ▀▀▀    ╙▀▀▀ "
  echo "  "
}

nvimbin='nvim'
vimbin='vim'
brewbin='brew'
nvimconfigdir="$HOME/.config/nvim"
package="$PWD/$(dirname "$0")"

function setup() {
  if ! commandExist $brewbin; then
    error "brew is missing need to install it before that"
    exit;
  fi

  if commandExist $nvimbin; then
    checked "NeoVim is installed"

    checked "Try to update NeoVim with the latest version from Homebrew"
    brew upgrade neovim tree-sitter luajit

  else

    brew install tree-sitter luajit neovim

    checked "Installed NeoVim, Tree Sitter and Lua support"

    brew install ripgrep
    checked "Installed ripgrep to assist NeoVim Telescope search"

    python3 -m pip install pynvim --user

    checked "Setup Python3 to work with NeoVim"
  fi

  if commandExist $vimbin; then
    checked "Vim is installed"
  else
    error "Vim is not installed but I prefer nvim so this is on you/me"
  fi

  update

  packagedone "Editors are ready to be used."
}

function update() {
  if fileExist "$nvimconfigdir/init.lua"; then
    checked "NeoVim is already setup - backuping it before continue"
    cp -R "$nvimconfigdir" "$nvimconfigdir.backup"
  fi

  checked "Setuping NeoVim configuration"
  cp -R "$package/files/" "$nvimconfigdir"

  updateVersion 'vim' $VERSION
}

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  checked "Sync $nvimconfigdir"
  cp -Rf "$nvimconfigdir/" "$package/files/"

  packagedone "Shell is sync back to dotfiles - require review and commit."
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Setup NeoVim and Vim as editor"
  helptext "Configure the editors for development by installing additional packages"
  helptext " "
  helptext " --help    - provide this information"
  helptext " --install - install package"
  helptext " --update  - update package"
  helptext " --version - package version"
  helptext " --sync    - copy files back to Dotfile"
  helptext " "
}

function version() {
  echo $VERSION
}

if [ "$1" == "--version" ]; then
  version
  exit;
fi

if [ "$1" == "--sync" ]; then
  sync
  exit;
fi

if [ "$1" == "--update" ]; then
  update;
  exit
fi

if [ "$1" == "--install" ]; then
  banner
  setup
  exit
fi

banner
help
exit
