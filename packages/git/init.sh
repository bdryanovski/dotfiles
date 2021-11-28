#!/bin/bash

source ./helpers.sh

VERSION="1.0.0"

function banner() {
  echo "   _____ _____ _______ "
  echo "  / ____|_   _|__   __|"
  echo " | |  __  | |    | |   "
  echo " | | |_ | | |    | |   "
  echo " | |__| |_| |_   | |   "
  echo "  \_____|_____|  |_|   "
  echo "  "
  echo " -- Intalling & Setup control version tool"
  echo "  "
}

banner

gitbin='git'
package="$PWD/$(dirname "$0")"
gitconfig=$HOME/.gitconfig
gitconfigbackup=$HOME/.gitconfig.backup

function setup() {

  if commandExist $gitbin; then
    checked "git is already installed on this system"
  else
    missed "git command is not found - trying to install it"
  fi


  if fileExist $gitconfig; then
    checked "git configuration file exist already - creating backup $gitconfigbackup"
    cp -f "$gitconfig" "$gitconfigbackup"
  fi


  cp "$package/files/gitconfig" "$gitconfig"
  checked "git configuration file created: $gitconfig"


  if commandExist 'npm'; then
    helpblock
    helpline "Node & NPM are not installed, yet"
    helpline "Internal diff tool must be installed"
    helpline "npm install -g diff-so-fancy"
    helpend
  fi

  helpblock
  helpline "GPG need manual work so it could run"
  helpline "Visit this page: https://gpgtools.org"
  helpline "Install the package and get the SIGNKEY"
  helpline "Setup the signkey into the $gitconfig so we could automatically sign them"
  helpend

  packagedone "Git is ready to be used"
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Configure control version tooling"
  helptext "This include git configuration, additional commands"
  helptext "Also instructions how to setup GPG Signing"
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

setup


