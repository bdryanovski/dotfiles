#
# User configuration
# New Alias
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
#
if [[ "$(uname)" == "Darwin" ]]; then
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
    alias showall='defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
    alias hideall='defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
fi

# Get rid of those pesky .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -print0 | xargs -0 rm'

#
# Git, run inside the git project will change directory to the git root
#
function gitroot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [[ -n "$root" ]]; then
    cd "$root"
  else
    echo "Not in a git repository"
  fi
}

#
# Help me setup the correct name for git repository between personal and work
#
if [[ -v EMAIL ]] && [[ -v FULLNAME ]]; then
    alias personal_git="git config user.email '$EMAIL' && git config user.name '$FULLNAME' && echo 'All Done'"
fi

#
# Configure to use bat for cat files
#
if command -v bat >/dev/null 2>&1; then
  alias cat="bat --theme DarkNeon"
fi
