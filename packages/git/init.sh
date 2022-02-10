#!/bin/bash

source ./interface.sh

VERSION="1.0.5"

function banner() {
  echo "  "
  echo "                  ╓▒╢╬▒,                                                   ▄████▌                   "
  echo "                ╔╠╬╬╬╬╬╬▒╓                                                ▐██████▌       ,╓╓╓       "
  echo "                ╚╬╬╬╬╬╬╬╬╬╟╖                                               ██████Ü       ████       "
  echo "           ,#╟m   ╙╢╬╬╬╬╬╬╬╬╬╦                                               └└         ▓████       "
  echo "         ,▒╬╬╬╬╢╗     └╚╬╬╬╬╬╬╢▒,                       ,╓╥▄▄╓,,,,,,,,,  ╓▄▄▄▄▄▄▄,  ▄▄▓██████▄▄▄▄▄▄ "
  echo "       ╓╠╬╬╬╬╬╬╬╬╢      ╠╬╬╬╬╬╬╬╬▒,                 ,▄▓████████████████  ████████▌  ███████████████ "
  echo "     ╔╠╬╬╬╬╬╬╬╬╬╬╬╖     └╝╬╬╬╬╬╬╬╬╬▒╓              ▄██████▀▀▀▀██████▀▀╙  └╙▓█████▌  ╙╙╙██████╙╙╙╙╙╙ "
  echo "   φ╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠  ⌠╓   ╚╬╬╬╬╬╬╬╬╬║╖           ▐█████▀      ╫████▌      ▐█████▌     ██████       "
  echo ".#╢╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠  ▐╬╟m     ╙╠╬╬╬╬╬╬╬╦         ▐█████µ      ╟█████      ▐█████▌     ██████       "
  echo "╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠  ▐╬╬╬▒      ╬╬╬╬╬╬╬╬▒         ██████▌▄▄▄▄▓█████▀      ▐█████▌     ██████       "
  echo " ╚╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠  ▐╬╬╬╬┐   ,#╬╬╬╬╬╬╬╜           ╙█████████████▓╙       ▐█████▌     ██████       "
  echo "   ╙╢╬╬╬╬╬╬╬╬╬╬╬╬╬╬╠  ▐╬╬╬╬╬╢╟╟╬╬╬╬╬╬╢╙             ▄████╨▀▀▀▀▀╙└          ▐█████▌     ██████▄      "
  echo "     ╙╟╬╬╬╬╬╬╬╬╬╬╬╩└  '╚╬╬╬╬╬╬╬╬╬╬╬╬╙             ╔█████▌▌▄▄▄▄▄▄▄╖,      ▄▄╫██████▄▄   ╫███████████▄"
  echo "       └╠╬╬╬╬╬╬╬╬╢      ╠╬╬╬╬╬╬╬╬╝└               ╟██████████████████▄   ███████████µ   ╙▓████████▓▀"
  echo "         └╝╬╬╬╬╬╬╬╦    ╔╢╬╬╬╬╬╬╩                   ▄██████████████████▌                      └      "
  echo "            ╚╬╬╬╬╬╬╬╢╢╬╬╬╬╬╬╬╜                    ▓███▓         ╙█████▓                             "
  echo "              ╙╢╬╬╬╬╬╬╬╬╬╬╢╙                      █████▌▄▄╥╓╓▄▄▄▓█████¬                             "
  echo "                ╙╬╬╬╬╬╬╬╬╙                        └▀███████████████▀╨                               "
  echo "                  └╝╬╬╝┘                              └╙╙╙╙▀▀╙╙╙└                                   "
  echo "  "
}

gitbin='git'
package="$PWD/$(dirname "$0")"
gitconfig=$HOME/.gitconfig
gitconfigbackup=$HOME/.gitconfig.backup
gitcommitmessage=$HOME/.gitcommitmessage
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

  update

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
  helptext " --help    - provide this information"
  helptext " --install - install package"
  helptext " --update  - update package"
  helptext " --version - package version"
  helptext " --sync    - copy files back to Dotfile"
  helptext " "
}

function version() {
  echo $VERSION
}

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  cp -f $gitconfig $package/files/gitconfig
  checked "Synced $gitconfig"

  cp -f $gitcommitmessage $package/files/gitcommitmessage
  checked "Synced $gitcommitmessage"

  packagedone "Git is sync back to dotfiles - require review and commit."
}

function update() {
  cp "$package/files/gitconfig" "$gitconfig"
  checked "Updated $gitconfig"

  if fileExist $gitcommitmessage; then
    checked "$gitcommitmessage exist creating backup $gitcommitmessage.backup"
    cp -f "$gitcommitmessage" "$gitcommitmessage.backup"
  fi

  cp $package/files/gitcommitmessage $gitcommitmessage
  checked "Updated $gitcommitmessage"

  updateVersion 'git' $VERSION  
}

if [ "$1" == "--version" ]; then
  version
  exit;
fi

if [ "$1" == "--sync" ]; then
  sync
  exit;
fi

if [ "$1" == "--update" ]; then
  update 
  exit
fi

if [ "$1" == "--install" ]; then
  banner
  setup
  exit
fi

banner
help
exit
