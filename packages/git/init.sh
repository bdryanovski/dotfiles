#!/bin/bash

source ./helpers.sh

VERSION="1.0.3"

function banner() {
  echo "   _____ _____ _______ "
  echo "  / ____|_   _|__   __|"
  echo " | |  __  | |    | |   "
  echo " | | |_ | | |    | |   "
  echo " | |__| |_| |_   | |   "
  echo "  \_____|_____|  |_|   "
  echo "  "
}

gitbin='git'
package="$PWD/$(dirname "$0")"
gitconfig=$HOME/.gitconfig
gitconfigbackup=$HOME/.gitconfig.backup
npmbin='npm'

gitname='Bozhidar Dryanovski'
gitemail='bozhidar.dryanovski@gmail.com'

function setup() {

  if commandExist $gitbin; then
    checked "git is already installed on this system"
  else
    missed "git command is not found - trying to install it"

    brew install git
    checked "Git is installed"
  fi


  if fileExist $gitconfig; then
    checked "git configuration file exist already - creating backup $gitconfigbackup"
    cp -f "$gitconfig" "$gitconfigbackup"
  fi


  cp "$package/files/gitconfig" "$gitconfig"
  checked "git configuration file created: $gitconfig"


  if ! commandExist $npmbin; then
    missing "Node & NPM are not installed, yet"
    helptext " "
    helptext "Internal diff tool must be installed"
    helptext "  "
    helptext "npm install -g diff-so-fancy"
    helptext " "
  else
    checked "Installing additional packages require for git"
    npm install -g diff-so-fancy
  fi

  git config --global user.name $gitname
  git config --global user.email $gitemail
  checked "Git global configuration set the name and email to $gitname <$gitemail>"


  brew install --cask gpg-suite
  checked "Installing GPG Suite"

  helptext " "
  helptext "If for some reason this fail fallow the steps below: "
  helptext " "
  helptext "Visit this page: https://gpgtools.org"
  helptext " "
  helptext "Install the package and get the SIGNKEY"
  helptext "Setup the signkey into the $gitconfig so we could automatically sign them"
  helptext " "

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

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  checked "Sync .gitconfig"
  cp -f "$gitconfig" "$package/files/gitconfig"

  packagedone "Git is sync back to dotfiles - require review and commit."
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

