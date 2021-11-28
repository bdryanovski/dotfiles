#!/bin/bash

source ./helpers.sh

VERSION="1.0.0"

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

function setup() {
 if ! commandExist $brewbin; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    checked "Homebrew is installed"
  else
    skip "Homebrew is already installed on this system"

    checked "Homebrew update itself "
    brew update

    checked "Homebrew update all installed packages"
    brew upgrade

    checked "Homebrew upgrade all casks"
    brew upgrade --cask

    checked "Homebrew clenup unneeded packages"
    brew cleanup

  fi

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

