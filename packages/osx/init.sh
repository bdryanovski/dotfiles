#!/bin/bash


source ./helpers.sh

function banner() {
echo "   ____   _______   __ "
echo "  / __ \ / ____\ \ / / "
echo " | |  | | (___  \ V /  "
echo " | |  | |\___ \  > <   "
echo " | |__| |____) |/ . \  "
echo "  \____/|_____//_/ \_\ "
echo "  "
echo " -- Setup MacOS "
echo "  "
                      
}

banner

function setup() {

  packagedone "MacOS is setup and ready"
}

if [[ $OSTYPE == 'darwin'* ]]; then
  setup
fi

