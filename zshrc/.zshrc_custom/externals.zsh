
#
# Google Cloud SDK Shell integration
#

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/bdryanovski/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/bdryanovski/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/bdryanovski/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/bdryanovski/tools/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="$PATH:/Users/bdryanovski/.kit/bin"

# export PATH="/opt/homebrew/opt/ruby@2.7/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

eval "$(rbenv init - zsh)"
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init --path)"
#   eval "$(pyenv init -)"
# fi
#

# pnpm
export PNPM_HOME="/Users/bdryanovski/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# bun completions
[ -s "/Users/bdryanovski/.bun/_bun" ] && source "/Users/bdryanovski/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH

#
# NVM
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ "$(command -v nvm)" = "" ]; then
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
  else
    echo "could not find nvm"
  fi
fi


function nvm_auto_switch {
  local NVM_VERSION
  local NVM_RC_FILE=`nvm_find_nvmrc`

  if [ "$NVM_RC_FILE" = "" ]; then
    NVM_VERSION=`nvm_version $(nvm_alias default)`
  else
    NVM_VERSION=`nvm_version $(cat $NVM_RC_FILE)`
  fi

  [ "$(nvm_version_path $NVM_VERSION)/bin" = "$NVM_BIN" ] || nvm use "$NVM_VERSION"
}

autoload -U add-zsh-hook
add-zsh-hook chpwd nvm_auto_switch


#
# skia and depot_tools
#
export PATH="${PWD}/depot_tools:${PATH}"

#
#
#
source $HOME/.local/bin/env


# Terraform
# terraform -install-autocomplete
