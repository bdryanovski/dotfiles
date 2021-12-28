#!/bin/bash

source ./interface.sh

VERSION="1.0.1"

function banner() {
  echo "  "
  echo "                                                  ╥                         "
  echo "                                                  ██▓▄                      "
  echo "                                                  ████                      "
  echo "                                                  ████                      "
  echo "         ,                                       █████                      "
  echo "     ,▄▓███▓▄,          ,╗╣╬╣▌╗,          ,▄▓██▓▓█████       ▄▄▓██▓▄,       "
  echo "   ▓███████████▌▄   ,▄▓▓╬╬╬╬╬╬╣╣▓▒╦    ▄▓█████████████   ╓▄▓██████████▌▄    "
  echo "   █████▀▀▀██████   ╟▓▓╬╬╬╬╬╬╣╣▓╣╬▓▒  j██████▀▀███████   ▓█████▓▀▀██████─   "
  echo "   █ ██     █████   ╟▓▓╬╬╬╬╬╬╣╣▓▓▓▓▒  j█████    j█████   ▓████─@╣▓ ██▓▀╙    "  
  echo "   ████     █████   ╟▓▓▓╬╬╬╬╬╣╣▓▓▓▓▒  j█████▄  ,▄█████   ▓████▄▄╙└ └        "
  echo "   ████     █████   ╚▓▓▓▓▓╬╬╬╣╣▓▓▓▓b  j███████████████   ▓███████▓▄,        " 
  echo "   ▀╙         ╙▀█     ╙▀▓▓▓╬╬╣╣▀╨└      ╙▀▓███████▀╙─      ╙▀███████▀¬      "
  echo "                           ▀╜└              ╙▀▀▀└              ╙▀▀└         " 
  echo "  "
}

nvmbin="nvm"
nvmscript="$HOME/.nvm/nvm.sh"
nodeVersion="16.13.0"

function setup() {
  # This for the most part will always run
  # The reason for that is that nvm as command is comming from bashrc/zshrc configuration on runtime
  # this type of information is not part of the script env, so another check is done to be sure
  # that the nvm is already installed
  if ! commandExist $nvmbin && ! fileExist $nvmscript; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    checked "NVM installed"

    nvm install $nodeVersion
    checked "Installing Node version: $nodeVersion and making it default."
  fi

  updateVersion 'nodejs' $VERSION  

  packagedone "NodeJS is ready to be use."
}

function help() {
  helptext " "
  helptext "Setup NodeJS for development"
  helptext "  "
  helptext " --help    - provide this information"
  helptext " --version - package version"
}

function version() {
  echo $VERSION
}

if [ "$1" == "--help" ]; then
  banner
  help
  exit;
fi

if [ "$1" == "--version" ]; then
  version
  exit;
fi

banner
setup
