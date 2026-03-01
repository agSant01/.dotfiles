# Shared by bash and zsh: NVM, PNPM, fzf, envman, zoxide, cargo.
# Source this after .env and .paths (so addToPath etc. exist).

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# PNPM: path differs by OS
if [[ $(uname) = "Darwin" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# fzf: shell-specific bindings
if [[ -n "$ZSH_VERSION" ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
else
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# zoxide: zsh on Darwin, else bash (only if zoxide is available)
if command -v zoxide &>/dev/null; then
  if [[ -n "$ZSH_VERSION" ]]; then
    if [[ $(uname) = "Darwin" ]]; then
      eval "$(zoxide init zsh)"
    else
      eval "$(zoxide init bash)"
    fi
  else
    eval "$(zoxide init bash)"
  fi
else
  echo "zoxide not found, skipping zoxide init"
fi
