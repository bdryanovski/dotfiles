#!/bin/bash

source ./helpers.sh

VERSION="1.0.1"

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
package="$PWD/$(dirname "$0")"

brewbin="brew"

function setup() {

  checked "Change the shell to ZSH"
  chsh -s $(which zsh)

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
    cp -f "$shellConfig" "$shellConfigBackum"
  fi

  cp "$package/files/zshrc" "$shellConfig"
  checked "ZSH configuration is created $shellConfig"

  checked "Install additional packages used in the above configurations"
  brew install exa

  packagedone "Shell is configure and ready to use."
}

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  checked "Sync .zshrc"
  cp -f "$shellConfig" "$package/files/zshrc"

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

