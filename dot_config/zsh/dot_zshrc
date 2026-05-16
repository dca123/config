# --- 0. Base PATH ---
ZSH_CACHE="${ZDOTDIR:-$HOME/.config/zsh}/.cache"
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

# --- 1. Fast Autocomplete (compinit) ---
autoload -Uz compinit
_comp_dumpfile="${ZDOTDIR:-$HOME}/.zcompdump"
() {
  setopt localoptions extendedglob
  if [[ -n "$_comp_dumpfile"(#qN.m-1) ]]; then
    compinit -C
  else
    compinit
  fi
}

# --- 2. Instant Plugin Loading (Bypassing zplug) ---
ZPLUG_REPOS="$HOME/.zplug/repos"
_source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

_source_if_exists "$ZPLUG_REPOS/robbyrussell/oh-my-zsh/lib/directories.zsh"
_source_if_exists "$ZPLUG_REPOS/robbyrussell/oh-my-zsh/plugins/git/git.plugin.zsh"
_source_if_exists "$ZPLUG_REPOS/robbyrussell/oh-my-zsh/plugins/alias-finder/alias-finder.plugin.zsh"
_source_if_exists "$ZPLUG_REPOS/Leizhenpeng/zsh-plugin-pnpm/pnpm.plugin.zsh"
_source_if_exists "$ZPLUG_REPOS/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh"
_source_if_exists "$ZPLUG_REPOS/MichaelAquilina/zsh-you-should-use/zsh-you-should-use.plugin.zsh"
unfunction _source_if_exists

# Resolve `pi` alias collision with installed CLI
unalias pi 2>/dev/null
alias pinit='pnpm init'

# --- 3. zplug Management Function ---
zplug-manage() {
  source "$HOME/.zplug/init.zsh"
  zplug "plugins/git", from:oh-my-zsh
  zplug "plugins/alias-finder", from:oh-my-zsh
  zplug "Leizhenpeng/zsh-plugin-pnpm"
  zplug "lib/directories", from:oh-my-zsh
  zplug "zsh-users/zsh-autosuggestions", from:github
  zplug "MichaelAquilina/zsh-you-should-use"

  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo
      zplug install
    fi
  fi
  zplug load
}

# --- 4. Editor and Keybindings ---
bindkey -v
export KEYTIMEOUT=1
export EDITOR=nvim

# --- 5. Aliases ---
alias loadenv='export $(grep -v "^#" .env | xargs)'
alias n="nvim"
alias cd="z"
alias oc="opencode"
alias npm=pnpm
alias npx="pnpm dlx"
alias smartcommit='opencode run -m lmstudio/openai/gpt-oss-20b "First run '\''git diff --staged'\'' to show only the staged changes ready to be committed. Analyze ONLY these staged changes (ignore any unstaged changes). Create a meaningful commit message based solely on what'\''s staged. Then commit only these staged changes with that message - do NOT stage any additional files or include unstaged changes."'

# --- 6. Search and Navigation ---
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search # Up arrow
bindkey '^[[B' down-line-or-beginning-search # Down arrow

# --- 7. Functions ---
v() {
  local session_name="nvim-$(basename "$PWD")"
  tmux attach -t "$session_name" || tmux new -s "$session_name" 'nvim'
}

touchp() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

take() {
  mkdir -p "$@" && cd "${@:$#}"
}

# --- 8. Environment and Paths ---
export HOMEBREW_NO_AUTO_UPDATE=1

# pnpm: default macOS install location; override PNPM_HOME per-machine if needed.
export PNPM_HOME="${PNPM_HOME:-$HOME/Library/pnpm}"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- 9. Initializations ---
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

[[ -f "$ZDOTDIR/local.zsh" ]] && source "$ZDOTDIR/local.zsh"
