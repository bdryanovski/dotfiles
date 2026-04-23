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
# THEME
#
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt/" ]
then
  echo "Installing Spaceship theme ..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"

  # Macbook M1 fix
  if [[ $(uname -m) == 'arm64' ]]; then
    ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh" "$(brew --prefix)/share/zsh/site-functions/prompt_spaceship_setup"

  fi

  # zsh "$ZSH_CUSTOM/themes/spaceship-prompt/scripts/install.sh"
fi

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

# Make sure to recreate the link only if not done already
# if [ ! -f "${ZDOTDIR:-$HOME}/.zfunctions/prompt_spaceship_setup" ]
# then
#   ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh" "${ZDOTDIR:-$HOME}/.zfunctions/prompt_spaceship_setup"
# fi
#
# prompt spaceship
#
# SPACESHIP_PROMPT_ORDER=(
#   user
#   dir
#   git
#   exec_time
#   line_sep
#   battery
#   exit_code
#   char
# )
#
# SPACESHIP_CHAR_SYMBOL=🍺
# SPACESHIP_CHAR_SUFFIX=" "
# SPACESHIP_BATTERY_SHOW=true
# SPACESHIP_BATTERY_THRESHOLD=40
#
# PLUGINS
#

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
# Load and track local device env that are globally set
# but never version control them
#
if [[ -f "$ZSH_CUSTOM/local.env.zsh" ]]
then
  source "$ZSH_CUSTOM/local.env.zsh"
fi

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
eval "$(fzf --zsh)"


if hash zoxide; then
  eval "$(zoxide init zsh)"
fi

source "$ZSH_CUSTOM/externals.zsh"


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform


# Added by Windsurf
export PATH="/Users/bdryanovski/.codeium/windsurf/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/bdryanovski/.lmstudio/bin"
# End of LM Studio CLI section


# pnpm
export PNPM_HOME="/Users/bdryanovski/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"

# bun completions
[ -s "/Users/bdryanovski/.bun/_bun" ] && source "/Users/bdryanovski/.bun/_bun"


# Go bin
export PATH="$PATH:/opt/homebrew/opt/go/libexec/bin:$HOME/go/bin"

export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"

# tuitube
export PATH=/Users/bdryanovski/.termcast/compiled/tuitube/bin:$PATH
. "/Users/bdryanovski/.deno/env"

# Added by GitButler installer
export PATH="/Users/bdryanovski/.local/bin:$PATH"
eval "$(but completions zsh)"
alias get_idf=". $HOME/esp/esp-idf/export.sh"


# opencode
export PATH=/Users/bdryanovski/.opencode/bin:$PATH
