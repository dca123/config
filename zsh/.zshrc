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
source "$ZPLUG_REPOS/robbyrussell/oh-my-zsh/lib/directories.zsh"
source "$ZPLUG_REPOS/robbyrussell/oh-my-zsh/plugins/git/git.plugin.zsh"
source "$ZPLUG_REPOS/robbyrussell/oh-my-zsh/plugins/alias-finder/alias-finder.plugin.zsh"
source "$ZPLUG_REPOS/Leizhenpeng/zsh-plugin-pnpm/pnpm.plugin.zsh"
source "$ZPLUG_REPOS/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZPLUG_REPOS/MichaelAquilina/zsh-you-should-use/zsh-you-should-use.plugin.zsh"

# --- 3. zplug Management Function ---
zplug-manage() {
  source ~/.zplug/init.zsh
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
  mkdir -p $@ && cd ${@:$#}
}

# --- 8. Environment and Paths ---
# pnpm
export PNPM_HOME="/Users/devinda/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/go/bin:$PATH"
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH=/Users/devinda/.opencode/bin:$PATH
export PATH="$PATH:/Users/devinda/.lmstudio/bin"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# --- 9. Initializations ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Cache opam env
ZSH_CACHE="$ZDOTDIR/.cache"
if [[ -f "$ZSH_CACHE/opam_env" ]]; then
  source "$ZSH_CACHE/opam_env"
else
  mkdir -p "$ZSH_CACHE"
  opam env > "$ZSH_CACHE/opam_env"
  source "$ZSH_CACHE/opam_env"
fi

# bun completions
[ -s "/Users/devinda/.bun/_bun" ] && source "/Users/devinda/.bun/_bun"
