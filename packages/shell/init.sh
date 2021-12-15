#!/bin/bash

source ./helpers.sh

VERSION="1.2.0"

function banner() {
 echo "      _          _ _ "
 echo "     | |        | | |"
 echo "  ___| |__   ___| | |"
 echo " / __| '_ \ / _ \ | |"
 echo " \__ \ | | |  __/ | |"
 echo " |___/_| |_|\___|_|_|"
 echo "  "
 echo " -- Configure working shell (zsh) "
 echo "  "
}

shellConfig="$HOME/.zshrc"
shellConfigBackup="$shellConfig.backup"
zshCustom="$HOME/.zshrc_custom"
package="$PWD/$(dirname "$0")"

brewbin="brew"

function setup() {
  if ! [ $SHELL == '/bin/zsh' ]; then
    checked "Change the shell to ZSH"
    chsh -s $(which zsh)
  fi

  if ! commandExist $brewbin; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    checked "Brew is installed"
  fi

  if fileExist "$HOME/.oh-my-zsh/oh-my-zsh.sh"; then
    checked "OH MyZSH is installed - skip this step"
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    checked "Installing zsh plugin"
  fi

  if fileExist $shellConfig; then
    checked "ZSH configuration already exist - need to backup $shellConfigBackup"
    cp -f "$shellConfig" "$shellConfigBackup"
  fi

  if directoryExist $zshCustom; then
    checked "ZSH Custom directory exists - creating backup"

    mv "$zshCustom" "$zshCustom.backup"
    mkdir "$zshCustom"
  else
    checked "ZSH Custom directory don't exist - will create one"
    mkdir "$zshCustom"
  fi


  cp "$package/files/zshrc" "$shellConfig"
  checked "ZSH configuration is created $shellConfig"

  cp "$package/files/alias.zsh" "$zshCustom"
  cp "$package/files/functions.zsh" "$zshCustom"
  checked "Creating alias.zsh and function.zsh"

  cp "$package/files/logo.txt" "$zshCustom/logo.txt"
  checked "Installing startup LOGO"

  checked "Install additional packages used in the above configurations"
  brew install exa

  packagedone "Shell is configure and ready to use."
}

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  checked "Sync .zshrc"
  cp -f "$shellConfig" "$package/files/zshrc"

  checked "Sync alias.zsh"
  cp -f "$zshCustom/alias.zsh" "$package/files/alias.zsh"

  checked "Sync functions.zsh"
  cp -f "$zshCustom/functions.zsh" "$package/files/functions.zsh"

  checked "Sync LOGO"
  cp -f "$zshCustom/logo.txt" "$package/files/logo.txt"

  packagedone "Shell is sync back to dotfiles - require review and commit."
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Setup ZSH and install Homebrew."
  helptext "This include command line aliases, theme, automation and more"
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
