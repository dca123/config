export ZDOTDIR="${ZDOTDIR:-$HOME/.config/zsh}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

[[ -f "$ZDOTDIR/local.zshenv" ]] && source "$ZDOTDIR/local.zshenv"
