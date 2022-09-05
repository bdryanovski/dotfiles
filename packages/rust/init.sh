#!/bin/bash

source ./interface.sh

VERSION="1.0.0"

function banner() {
  echo "RUST"
}

function setup() {

  helptext "Installing Rust from rust-lang.org guide"

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

  updateVersion 'rust', $VERSION

  packagedone "Rust is ready to be used"
}

function version() {
  echo $VERSION
}


function update() {
  checked "Nothing to update"

  updateVersion 'rust', $VERSION
}

function sync() {

  warn  "Sync files back to dotfiles could break it"

  askQuestion "Are you sure that you want to continue?"

  checked "There are no files to sync at this moment"

  packagedone "Rust is sync back to dotfiles - require review and commit."
}

function help() {
  helptext " "
  helptext " Setup and Configure Rust Lang"
  helptext " "
  helptext " --help     - you are looking at it"
  helptext " --install  - install packages"
  helptext " --sync     - sync back to dotfiles"
  helptext " --update   - update package"
  helptext " --version  - package version"
  helptext " "
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
  exit;
fi

if [ "$1" == "--install" ]; then
  banner
  setup
  exit;
fi

banner
help
exit

