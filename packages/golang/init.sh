#!/bin/bash

source ./interface.sh

VERSION="1.0.0"

function banner() {
    echo "                               ,▄╗@φ▓▓╠▒░░░▒█▓▓╗▄,                               "
    echo "                           ,#█░░╬╬╬╬╬╬╬▒╬╬╬╬╬╬╬╬╬░░╬▓M▄                          "
    echo "                         ▄╬░╬╬╬╬╬╬╬╬╬╬╬▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬░█▄                       "
    echo "                      ▄Θ▒▒╬╬╬╬╬╬╬╬╬╬╬╬╬█╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬░╬╗                     "
    echo "                   ▄▓█░╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▒╬╬░╬▄                  "
    echo "                  █▒╬║▒╬╬╬╬▒▄▄Å##▀▀▀▀▀▀╚╚╚╚╚▀▀▀▀▀▀###▄▒▒╬╬╬╬╬╬░▌                 "
    echo "              ,▄▄╫▄▒╬╬█#▀╚░░▒▄▄▄▒▒╬╬╬╬╬╬╬╬╬╬╬░▄╫╝╝╝╝█▄▄░╚▀▒▒╬╬║█ææ▄,             "
    echo "            █└   ▄▒▒█╬░░▄█▀└     ╙▀╣▒╬╬╬╬╬╬▄▀         ╙╣╙╣▒╚█▒╠█   └█▄,          "
    echo "           ╫  ╒██░║╬▒╠▀█─           ╙█╬╬╬╬█             ╙▄╙▒╬║▒░███  ▌           "
    echo "           ╟   ╟▒╠▒╬║⌐╟         ,▄██▄╙▌╬╬╟¬        ╒████ ▓ ╙▒╬║▒╠▌  ▄⌐           "
    echo "            ╙▓▄█▒█▒╬▌ █         ███╙█ █╬╬╟⌐        ╙██▄█⌐█  ▒╬╬█╫███             "
    echo "             ║╬╬╬█╬╬▌ ╙▌         ╙▀▀└á▒╬╬╬█          └└ ▄¬ ▐▒╬╬▌╬╬╬█             "
    echo "              ╟▒▄▓▒╬╚▄ ╙█          ,█▒█████╬█╖       ,▄▀  ▄░╬╬╠█##▓¬             "
    echo "              █╬╬░█▒╬░█▄ '▀▀╗▄▄▄▄██▒╝▀▀███▀▀▀╣╬██████▄▄╗▓░╬╬╬▓▒╬╬╬▓              "
    echo "              █╬╬╬╬╚▓▒╬╬░╚╬▓▓█╬░░▄█           ╟╫▒▒╬╬╬╬╬╬╬╬▒╝▀▌╬╬╬╬╠█             "
    echo "              ╟▒╬╬╬╬╬╫╙╝╫╬▄▒╣╝╩╙─ ╙W▄æª▀█▀≈ªmª▀   ╙╙╙▀▀▀╙    ╫╠╬╬╬╬║             "
    echo "               ▌╬╬╬╬╬▌              ╫   █   ▌                 █╬╬╬╬║             "
    echo "              ]▒╬╬╬╬╠▌              █  ,█  ╓▌                 █╬╬╬╠▌             "
    echo " å▓           █╬╬╬╬╬║▀               └└   ¬                  ]▒╬╬φ▀         ,╓╖, "
    echo "╚▒╠▌         █░╬╬╬▄╩                                         ╚▒╬╬░█▄      ▄╬█▒α╜ "
    echo " ╙╬╚##Θ█▒▒▒╠╠▒╝╝▀╙j▌                                          '╙█▄╬╬░█▄ ,╬║▀     "
    echo "   └╙╙             ▌                                           j▌  ╙╣▄▒▒░▒▀      "
    echo "                   '                                            ▌       '        "
    echo "  "
}

gopath="$HOME/golang"
gobin="go"
zshconfig="$HOME/.zshrc_custom/languages/golang.zsh"
package="$PWD/$(dirname "$0")"

function setup() {

  if commandExist $gobin; then
    checked "GOlang is already installed"
  else
    error "GOlang is not installed - trying to fix this"

    brew install golang
    checked "Go is installed"
  fi


  if directoryExist $gopath; then
    checked "GOHOME already exist and it's located here: $gopath"
  else
    mkdir $gopath
    checked "GOHOME directory is created here: $gopath"
  fi

  update

  packagedone "GOlang is ready to be used"
}

function help() {
  helptext " "
  helptext "Description:"
  helptext "Configure golang environment"
  helptext "This include installing and configuring golang for ZSH"
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

  cp -f $zshconfig $package/files/golang.zsh
  checked "Synced $zshconfig"

  packagedone "GOlang is sync back to dotfiles - require review and commit."
}

function update() {

  mkdir -p $HOME/.zshrc_custom/languages
  cp "$package/files/golang.zsh" "$zshconfig"
  checked "Updated $zshconfig"

  updateVersion 'golang' $VERSION  
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
