#
# User configuration
# New Alias
alias p="cd ~/Projects"
alias b="cd ~/blog"
alias myip='ifconfig | grep "inet " | grep -v 127.0.0.1'
alias getNodeSize='find . -name "node_modules" -type d -prune -print | xargs du -chs'

alias ll="exa -a -l --no-user --no-time --git -s type --icons"
alias l="exa -a -s type --icons"
alias ls="l"

#
# Navigation
#
alias cd=z
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Usefull stuff for presentation and seeing dotfiles
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias showall='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
alias hideall='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'

# Get rid of those pesky .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -print0 | xargs -0 rm'

#
# Git, run inside the git project will change directory to the git root
#
alias githome="cd $(git rev-parse --show-toplevel)"

#
# NeoVide
#
# Need to be installed and configure
# alias neovide=~/Github/neovide/target/release/neovide --multigrid
