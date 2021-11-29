#!/bin/bash

source ./helpers.sh

VERSION="1.0.2"

function banner() {
  echo " __      _______ __  __ "
  echo " \ \    / /_   _|  \/  |"
  echo "  \ \  / /  | | | \  / |"
  echo "   \ \/ /   | | | |\/| |"
  echo "    \  /   _| |_| |  | |"
  echo "     \/   |_____|_|  |_|"
  echo "  "
  echo " -- Setup editor NeoVim and Vim "
  echo "  "
}

nvimbin='nvim'
vimbin='vim'
brewbin='brew'
nvimconfigdir="$HOME/.config/nvim"
package="$PWD/$(dirname "$0")"

function setup() {

  if ! commandExist $brewbin; then
    missing "brew is missing need to install it before that"
    exit;
  fi

  if commandExist $nvimbin; then
    checked "NeoVim is installed"

    checked "Try to update NeoVim with the latest version from Homebrew"
    brew upgrade neovim tree-sitter luajit
  else

    brew install tree-sitter luajit neovim

    checked "Installed NeoVim, Tree Sitter and Lua support"

    python3 -m pip install pynvim --user

    checked "Setup Python3 to work with NeoVim"
  fi

  if commandExist $vimbin; then
    checked "Vim is installed"
  else
    missing "Vim is not installed but I prefer nvim so this is on you/me"
  fi

  if fileExist "$nvimconfigdir/init.vim"; then
    checked "NeoVim is already setup - backuping it before continue"
    cp -R "$nvimconfigdir" "$nvimconfigdir.backup"
  fi

  checked "Setuping NeoVim configuration"
  cp -R "$package/files/" "$nvimconfigdir"

  checked "Installing TypeScript and some additional packages required for type complition"
  npm install -g typescript typescript-language-server diagnostic-languageserver

  packagedone "Editors are ready to be used."
}

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  checked "Sync ~/.config/.nvim"
  cp -f "$nvmconfigdir" "$package/files/"

  packagedone "Shell is sync back to dotfiles - require review and commit."
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Setup NeoVim and Vim as editor"
  helptext "Configure the editors for development by installing additional packages"
  helptext " "
}

function version() {
  helptext "Package version: $VERSION"
}


if [ "$1" == "--help" ]; then
  help
  exit;
fi

if [ "$1" == "--version" ]; then
  version
  exit;
fi

if [ "$1" == "--sync" ]; then 
  sync
  exit;
fi

banner
setup
