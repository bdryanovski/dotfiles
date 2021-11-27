#!/bin/bash

source ./helpers.sh

VERSION='1.0.0'

function start() {
  infod "Packages: "
  for i in $(ls -d packages/*); do 
    if test -f "${i%%/}/init.sh"; then
      bash "${i%%/}/init.sh"
    fi
  done
}

function banner() {
  echo "                                                                               "
  echo "     █████           █████       ██████   ███  ████                    ███████ "
  echo "    ░░███           ░░███       ███░░███ ░░░  ░░███                   ███░░░███"
  echo "  ███████   ██████  ███████    ░███ ░░░  ████  ░███   ██████   █████ ░░░   ░███"
  echo " ███░░███  ███░░███░░░███░    ███████   ░░███  ░███  ███░░███ ███░░    ███████ "
  echo "░███ ░███ ░███ ░███  ░███    ░░░███░     ░███  ░███ ░███████ ░░█████  ░███░░░  "
  echo "░███ ░███ ░███ ░███  ░███ ███  ░███      ░███  ░███ ░███░░░   ░░░░███ ░░░      "
  echo "░░████████░░██████   ░░█████   █████     █████ █████░░██████  ██████   ███     "
  echo " ░░░░░░░░  ░░░░░░     ░░░░░   ░░░░░     ░░░░░ ░░░░░  ░░░░░░  ░░░░░░   ░░░      "
  echo "                                                                   -- v$VERSION"
}

# Init process

banner;

while true; do
  read -p "🤌  Do you wish to install dotfiles? [yn]: " yn
  case $yn in
    [Yy]* ) start; exit; break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done


