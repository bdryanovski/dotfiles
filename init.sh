#!/bin/bash

source ./interface.sh

VERSION=2.2.0

function setup() {
  askQuestion "🧐 Do you wish to install all dotfiles?"

  info "Starting to install packages one by one: "
  for i in packages/*; do
    if test -f "${i%%/}/init.sh"; then
      bash "${i%%/}/init.sh" --install
    fi
  done
}

function version() {
  echo $VERSION
}

function status() {

  source $DVCFG

  info "Information about installed packaged and the current version on this system. Packages marked with red are out of sync, and the one in green are ok"

  echo "  "

  info "Dotfile version: $VERSION"

  echo "  "

  printf "%10s %10s %10s\n" "Package" "Current" "Dotfile"
  printf "%10s %10s %10s\n" "-------" "-------" "-------"

  for i in packages/*; do
    if test -f "${i%/}/init.sh"; then
      packageName=$(basename $i)
      packageVersion="$(bash "${i%/}/init.sh" --version)" 
      packageCurrentVersion="${!packageName}"
      
      if [[ $packageVersion == $packageCurrentVersion ]]; then 
        printf "${c_green}%10s %10s %10s${c_reset}" $packageName $packageCurrentVersion $packageVersion
      else
        printf "${c_red}%10s %10s %10s${c_reset}" $packageName $packageCurrentVersion $packageVersion
      fi
      echo " "
    fi
  done
  exit
}

function syncVersionDotfile() {
  info "Syncing packages one by one to local dotfile version storage"
  syncVersions
  packagedone "All packages are in sync - check it by passing --version argument"
  exit
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
    helptext "  --help                  - this documentation"
    helptext "  --version               - dotfiles version"
    helptext "  --status                - get information about packages and versions"
    helptext "  --sync-version-dotfile  - sync package version to this machine without installing them (Use in specific cases, like update from v1 to v2)"
    helptext "  --packages              - list of all available packages"
    helptext "  --sync                  - copy configrations back to dotfiles (require git push to share)"
    helptext "  "
    helptext "! Running it without any argument or package name will ask you to install everything."
    helptext " "
    helptext "A specific package could be run by using there name for example for package named 'shell' :"
    helptext "  "
    helptext "  bash ./init.sh shell"
    helptext "  "
    helptext "All of the packages support additional arguments to provide information for themself"
    helptext "  --help     - package description and help information"
    helptext "  --install  - initial install of the package"
    helptext "  --update   - update package with newer version"
    helptext "  --sync     - sync package with the dotfile [optional]"
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

  if [ "$1" == "--status" ]; then
    status
    exit
  fi

  if [ "$1" == "--sync-version-dotfile" ]; then
    syncVersionDotfile
    exit
  fi

  # First argument is --packages
  if [ "$1" == "--packages" ]; then
    info "Available packages to run: "
    for i in packages/*; do
      if test -f "${i%/}/init.sh"; then
        echo "  ${i%/}"
        bash "${i%/}/init.sh" --help
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

