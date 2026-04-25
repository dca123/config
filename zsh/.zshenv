export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Make Homebrew-provided tools available even for non-login interactive shells.
ZSH_CACHE="$ZDOTDIR/.cache"
if [[ -f "$ZSH_CACHE/brew_env" ]]; then
  source "$ZSH_CACHE/brew_env"
else
  for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew "$HOME/.linuxbrew/bin/brew"; do
    if [[ -x "$_brew" ]]; then
      mkdir -p "$ZSH_CACHE"
      "$_brew" shellenv > "$ZSH_CACHE/brew_env"
      source "$ZSH_CACHE/brew_env"
      break
    fi
  done
  unset _brew
fi

[[ -f "$ZDOTDIR/local.zshenv" ]] && source "$ZDOTDIR/local.zshenv"
