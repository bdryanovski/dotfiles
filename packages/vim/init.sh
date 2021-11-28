#!/bin/bash

source ./helpers.sh

VERSION="1.0.1"

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

function setup() {

  if commandExist $nvimbin; then
    checked "NeoVim is installed"
  else

    if ! commandExist $brewbin; then
      missing "brew is missing need to install it before that"
      exit;
    fi

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

  brew install exa

  packagedone "Editors are ready to be used."
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

banner
setup
