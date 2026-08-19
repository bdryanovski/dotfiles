# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/bdryanovski/.zsh/completions:"* ]]; then export FPATH="/Users/bdryanovski/.zsh/completions:$FPATH"; fi
#
# Global Variables
#
export EDITOR=nvim
export VISUAL=nvim

# Would you like to use another custom folder than $ZSH/custom?
export ZSH_CUSTOM=~/.zshrc_custom

# Macbook M1 FIX
if [[ $(uname -m) == 'arm64' ]]; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  fpath=( "${ZDOTDIR:-$HOME}/.zfunctions" $fpath )
fi

# Autocomplete case-insensitive
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

autoload -U promptinit && promptinit
autoload -Uz vcs_info && vcs_info

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

#
# Starship
#
# Website: https://starship.rs/guide/
#
# Install starship if not installed
if ! command -v starship &> /dev/null
then
    echo "Installing Starship prompt ..."
    curl -fsSL https://starship.rs/install.sh | bash -s -- -y
fi
#
eval "$(starship init zsh)"

#
# Extend zsh with Syntax Colors
#
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]
then
  echo "Installing Syntax Highlighting ..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

#
# Loading AutoSuggestions
#
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]
then
  echo "Installing AutoSuggestions"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

source "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

#
# Loading additional plugins
#
# DEPRECATED: soon to be removed
#
source "$ZSH_CUSTOM/plugins/git.plugin.zsh"

#
MWFT="$(cat "$ZSH_CUSTOM/logo.txt")"
echo "$MWFT"

#
# Aliases
#
source "$ZSH_CUSTOM/alias.zsh"

#
# Helper functions
#
source "$ZSH_CUSTOM/functions.zsh"


#
# ZSH History settings
#
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#
# Integrate FZF
#
# Ctrl+r - find in previous command
#
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi


if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

#
# TMUX reatach or create new session
#
#if command -v tmux &> /dev/null && [ -z "${TMUX}" ] && [[ -o interactive ]] && [[ ! "${TERM}" =~ (screen|tmux) ]]; then
#    # attach to an existing session, or create a new one if none exist
#    tmux attach 2> /dev/null || tmux
#fi

source "$ZSH_CUSTOM/externals.zsh"


autoload -U +X bashcompinit && bashcompinit

#
# Load and track local device env that are globally set
# but never version control them
#
if [[ -f "$ZSH_CUSTOM/local.env.zsh" ]]
then
  source "$ZSH_CUSTOM/local.env.zsh"
fi

# tmux-spotlight standalone launch
alias tsp='/Users/bdryanovski/.config/tmux/plugins/tmux-spotlight/scripts/switcher.sh'
