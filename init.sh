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

if test -z "$1"; then

  while true; do
    read -p "🤌  Do you wish to install dotfiles? [yn]: " yn
    case $yn in
      [Yy]* ) start; exit; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac
  done

else

  if [ "$1" == "--help" ]; then
    echo "Need to write help"
  fi

  if [ "$1" == "--packages" ]; then

    infod "Packages: "
    for i in $(ls -d packages/*); do 
      if test -f "${i%%/}/init.sh"; then
        echo "  ${i%%/}"
      fi
    done

    echo "  "

    packagedone "Above is the list of supported packages"
    exit
  fi

  if test -f "packages/$1/init.sh"; then
    bash "packages/$1/init.sh" $2
  fi
fi




