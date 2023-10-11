#!/bin/bash

source ./interface.sh

VERSION="2.1.5"


function banner() {
  echo "  "
  echo "     ▓███▓▀▀▀██████                  ╨████▌                    ▀████  ▀████   "
  echo "     ██└    ▓████▌                    ╫███▌                     ████   ████   "
  echo "     ▀    ,█████╜           ,▄▄▌▄▄▄▌  ╫███▌╓▄▓▌▄,     ▄▄▓▌▄▄    ████   ████   "
  echo "         ▄█████            ▐██▌  ╙██  ╫████▀╨████µ  ▄███  ▓██µ  ████   ████   "
  echo "        ▓████▌             ╟████▌▄,└  ╫███▌  ║███▒ ▐███▌▄▄▓███  ████   ████   "
  echo "      ;█████╜     ▐█        ╙▀█████▓  ╫███▌  ║███▒ ║███▌└└└└└└  ████   ████   "
  echo "     ▄█████      ▄█▌       ╫▌   ╨███Γ ╫███▌  ║███▒ └████Q   ╓▄  ████   ████   "
  echo "    ▓█████▄▄▌▓▓████▒       ╫██▄▄▄██▀ ▄█████▄╔▓████▄ └▀██████▀ .▄████▄:▄████▌~ "
  echo "                               └└                       └└                    "
  echo "  "
}

shellConfig="$HOME/.zshrc"
shellConfigBackup="$shellConfig.backup"
zshCustom="$HOME/.zshrc_custom"
package="$PWD/$(dirname "$0")"

function setup() {
  if ! [ $SHELL == '/bin/zsh' ]; then
    chsh -s $(which zsh)
    checked "Change the shell to ZSH"
  fi

  info "Install additional packages used in the above configurations"
  brew install exa

  checked "Packages are installed"

  update

  packagedone "Shell is configure and ready to use."
}

function sync() {
  warn "Syncking files back to the dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  cp -vf "$shellConfig" "$package/files/zshrc"
  checked "Synced .zshrc"

  cp -vf "$zshCustom/alias.zsh" "$package/files/alias.zsh"
  checked "Synced alias.zsh"

  cp -vf "$zshCustom/functions.zsh" "$package/files/functions.zsh"
  checked "Synced functions.zsh"

  cp -vf "$zshCustom/logo.txt" "$package/files/logo.txt"
  checked "Synced LOGO"

  cp -vf $zshCustom/plugins/*.plugin.zsh "$package/files/plugins/"
  checked "Synced custom plugins"

  packagedone "Shell is sync back to dotfiles - require review and commit."
}

function update() {
  if fileExist $shellConfig; then
    warn "ZSH configuration already exist - need to backup $shellConfigBackup"
    cp -vf "$shellConfig" "$shellConfigBackup"
  fi

  if directoryExist $zshCustom; then
    warn "ZSH Custom directory exists - creating backup"
    mv "$zshCustom" "$zshCustom.backup"
    mkdir "$zshCustom"
  else
    info "ZSH Custom directory don't exist - will create one"
    mkdir $zshCustom
    mkdir $zshCustom/themes/
    mkdir $zshCustom/plugins/
    checked "ZSH Custom directory is ready"
  fi

  cp $package/files/zshrc $shellConfig
  checked "ZSH configuration is created $shellConfig"

  info "Copying additional files"
  cp -v $package/files/alias.zsh $zshCustom
  cp -v $package/files/functions.zsh $zshCustom
  cp -v $package/files/plugins/* $zshCustom/plugins

  cp "$package/files/logo.txt" "$zshCustom/logo.txt"
  checked "Motivation Words For Today are installed"

  updateVersion 'shell' $VERSION
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Setup ZSH and install Homebrew."
  helptext "This include command line aliases, theme, automation and more"
  helptext " "
  helptext " --help      - provide this information"
  helptext " --install   - install package"
  helptext " --update    - update package"
  helptext " --version   - package version"
  helptext " --uninstall - remove all installed files"
  helptext " --sync      - copy files back to Dotfile"
  helptext " --compare   - compare local and remote files"
  helptext " "
}

function version() {
  echo $VERSION
}

function uninstall() {
  warn "Uninstalling is not reversable action, there is no comming back!"

  askQuestion "Are you sure that you want to continue ?: "

  rm -rvf $shellConfig $shellConfigBackup $zshCustom $zshCustom.backup

  packagedone "Uninstall shell package is done."
}

function compare() {
    info "Compare local to remote changes:"

    compareFile $shellConfig $package/files/zshrc

}


if [ "$1" == "--version" ]; then
  version
  exit;
fi

if [ "$1" == "--sync" ]; then
  sync
  exit;
fi

if [ "$1" == "--uninstall" ]; then
  uninstall
  exit;
fi

if [ "$1" == "--install" ]; then
  banner
  setup
  exit
fi

if [ "$1" == "--update" ]; then
  update
  exit
fi

if [ "$1" == "--compare" ]; then
    compare
    exit
fi

banner
help
exit
