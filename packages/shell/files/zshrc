# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH=/Users/bdryanovski/.oh-my-zsh

plugins=(
  git
  colorize
)

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format usng the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.zshrc_custom

autoload -U promptinit && promptinit
#
# Make sure that theme is there and set it
#
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt/" ]
then
  echo "Installing Spaceship theme ..."
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
  echo "Linking theme so ZSH will find it ..."
  ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme";
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k/" ]
then
  echo "Installing PowerLevel10k theme ..."
  git clone https://github.com/romkatv/powerlevel10k.git  "$ZSH_CUSTOM/themes/powerlevel10k"
  echo "Linking theme so ZSH will find it ..."
  ln -sf "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme" "$ZSH_CUSTOM/themes/powerlevel10k.zsh-theme";
fi

ZSH_THEME="powerlevel10k"

SPACESHIP_PROMPT_ORDER=(
  user
  dir
  git
  exec_time
  line_sep
  battery
  exit_code
  char
)

SPACESHIP_CHAR_SYMBOL=🍺
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_GIT_SYMBOL=
SPACESHIP_BATTERY_SHOW=charged
SPACESHIP_BATTERY_THRESHOLD=40

#
# Adding command colors
#
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]
then
  echo "Installing Syntax Highlighting ..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]
then
  echo "Installing AutoSuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

#
# Start oh-my-zsh`
#
source $ZSH/oh-my-zsh.sh
#
# Extend zsh with Syntax Colors
#
source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#
# Loading AutoSuggestions
#
source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"


#
# User configuration
# New Alias
alias p="cd ~/Projects"
alias b="cd ~/blog"
alias myip='ifconfig | grep "inet " | grep -v 127.0.0.1'
alias getNodeSize='find . -name "node_modules" -type d -prune -print | xargs du -chs'

alias ll="exa -a -l --no-user --no-time --git -s type --icons"
alias l="exa -a -s type --icons"


#
# JavaScript
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


#
# Golang
#
export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH
export PATH=$PATH:$GOROOT/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



#
# NeoVide
#
# Need to be installed and configure 
alias neovide=~/Github/neovide/target/release/neovide --multigrid
