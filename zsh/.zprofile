# Cache brew shellenv
ZSH_CACHE="$ZDOTDIR/.cache"
if [[ -f "$ZSH_CACHE/brew_env" ]]; then
  source "$ZSH_CACHE/brew_env"
else
  mkdir -p "$ZSH_CACHE"
  /opt/homebrew/bin/brew shellenv > "$ZSH_CACHE/brew_env"
  source "$ZSH_CACHE/brew_env"
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
export PATH="/Users/devinda/.local/bin:$PATH"
export XDG_CONFIG_HOME="/Users/devinda/.config"
