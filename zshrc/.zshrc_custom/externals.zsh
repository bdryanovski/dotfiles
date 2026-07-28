export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

eval "$(rbenv init - zsh)"

# pnpm
export PNPM_HOME="/Users/bdryanovski/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


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
