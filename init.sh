#!/bin/bash

source ./helpers.sh

VERSION='1.3.0'

# Run all packages one by one untill they all are done.
function all() {
  infod "Starting to install packages one by one: "
  for i in packages/*; do
    if test -f "${i%%/}/init.sh"; then
      bash "${i%%/}/init.sh"
    fi
  done
}


function setup() {
  # Make sure to ask the hard question
  while true; do
    read -p "🤌  Do you wish to installall dotfiles? [yn]: " yn
    case $yn in
      [Yy]* ) all; exit; break;;
      [Nn]* ) exit;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}


function version() {
  helptext "Package version: $VERSION"
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
  echo "                                                   -- one tool to rule them all"
}

# Always show the main banner
banner;

if test -z "$1"; then
  # No arguments are passed
  setup
else

  # First argument is --help
  if [ "$1" == "--help" ]; then
    helptext " "
    helptext "Install, setup and sync dotfiles - grouped by packages"
    helptext " "
    helptext "Arguments: "
    helptext "  --help      - this documentation"
    helptext "  --version   - dotfiles version"
    helptext "  --packages  - list of all available packages"
    helptext "  --sync      - copy configrations back to dotfiles (require git push to share)"
    helptext "  "
    helptext "! Running it without any argument or package name will ask you to install everything."
    helptext " "
    helptext "A specific package could be run by using there name for example for package named 'shell' :"
    helptext "  "
    helptext "  bash ./init.sh shell"
    helptext "  "
    helptext "All of the packages support additional arguments to provide information for themself"
    helptext "  --help     - package description and help information"
    helptext "  --version  - package version"
    helptext "  "
    helptext "Any additional arguments will be found in the --help for the specific package"
    helptext "  "
    exit;
  fi

  if [ "$1" == "--version" ]; then
    version
    exit
  fi

  # First argument is --packages
  if [ "$1" == "--packages" ]; then
    infod "Available packages to run: "
    for i in packages/*; do
      if test -f "${i%%/}/init.sh"; then
        echo "  ${i%%/}"
        bash "${i%%/}/init.sh" --help
      fi
    done

    echo "  "

    packagedone "Above is the list of supported packages"
    exit
  fi

  # First argument is one of the packages name
  if test -f "packages/$1/init.sh"; then
    bash "packages/$1/init.sh" $2
  fi
fi

