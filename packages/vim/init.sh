#!/bin/bash

source ./helpers.sh

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

banner

nvimbin='nvim'
vimbin='vim'
brewbin='brew'
nvmbin="nvm"
nodeVersion="16.13.0"
nvimconfigdir="$HOME/.config/nvim"

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

if ! commandExist $nvmbin; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  checked "NVM installed"
fi

nvm install $nodeVersion

npm install -g typescript typescript-language-server diagnostic-languageserver

brew install exa

packagedone "Editors are ready to be used."


