#!/bin/bash

source ./helpers.sh

VERSION="1.1.0"

function banner() {
  echo "  ____                  "
  echo " |  _ \                 "
  echo " | |_) | __ _ ___  ___  "
  echo ' |  _ < / _` / __|/ _ \ '
  echo " | |_) | (_| \__ \  __/ "
  echo " |____/ \__,_|___/\___| "
  echo "                        "
}


brewbin="brew"
basersa="~/.ssh/id_rsa"

function setup() {
  if ! commandExist $brewbin; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    checked "Homebrew is installed"

    brew update
    checked "Homebrew is updated"
  else
    skip "Homebrew is already installed on this system"

    brew update
    checked "Homebrew update itself "

    brew upgrade
    checked "Homebrew update all installed packages"

    brew upgrade --cask
    checked "Homebrew upgrade all casks"

  fi


  if ! isMacOS; then
    xcode-select --install
    checked "Xcode basic packages are installed"
  fi

  if ! fileExist $basersa; then
    helptext "Every new machine require to have new SSH key"

    ssh-keygen -t rsa

    helptext "Please go and register this key to Github"
    helptext "https://github.com/account/ssh"
    read -p "Press [Enter] to continue ..."

    checked "New SSH Key generated"
  fi

  helptext "Installing some packages to setup the machine"

  brew install wget

  checked "wget is installed"

  if ! isMacOS; then
    helptext "Install MacOS applications with brew"

    apps=(
      google-chrome
      iterm2
      spotify
      bitwarden
      notion
    )

    brew install --cask --appdir="/Applications" ${apps[@]}
    checked "Brew cask installed few applications ${apps[@]}"

    brew cleanup
    checked "Homebrew clenup packages"

  fi

  brew tap homebrew/cask-fonts
  brew install --cask font-sauce-code-pro-nerd-font
  checked "Installing Fonts for Iterm and NeoVim later on"

  packagedone "Base is setup."
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Basic system setup require for later packages to pass without depending on each other"
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

