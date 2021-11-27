#!/bin/bash

source ./helpers.sh

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


banner

shellConfig="$HOME/.zshrc"
shellConfigBackup="$shellConfig.backup"
package="$PWD/$(dirname "$0")"

brewbin="brew"

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


packagedone "Shell is configure and ready to use."
