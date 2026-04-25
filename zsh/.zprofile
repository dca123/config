# Login-shell environment shared across machines.
export PATH="$HOME/.local/bin:$PATH"

ZSH_CACHE="${ZDOTDIR:-$HOME/.config/zsh}/.cache"
mkdir -p "$ZSH_CACHE"

# Cache Homebrew's shellenv when Homebrew is installed.
if command -v brew >/dev/null 2>&1; then
  if [[ -f "$ZSH_CACHE/brew_env" ]]; then
    source "$ZSH_CACHE/brew_env"
  else
    brew shellenv > "$ZSH_CACHE/brew_env"
    source "$ZSH_CACHE/brew_env"
  fi
fi

[[ -f "$ZDOTDIR/local.profile.zsh" ]] && source "$ZDOTDIR/local.profile.zsh"
