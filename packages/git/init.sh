#!/bin/bash

source ./helpers.sh


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
