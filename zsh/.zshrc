source ~/.zplug/init.zsh

zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/alias-finder",   from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "MichaelAquilina/zsh-you-should-use"

bindkey -v
export KEYTIMEOUT=1
export EDITOR=nvim

alias n="nvim"
alias ..="cd .."

alias npm=pnpm
alias npx="pnpm dlx"

source ~/.config/zsh/directories.zsh
source ~/.config/zsh/pnpm.plugin.zsh

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search    # Up arrow
bindkey '^[[B' down-line-or-beginning-search    # Down arrow


# pnpm
export PNPM_HOME="/Users/devinda/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
export PATH="$HOME/go/bin:$PATH"

function take() {
  mkdir -p $@ && cd ${@:$#}
}
#disable brew autoupdates
export HOMEBREW_NO_AUTO_UPDATE=1

# opencode
export PATH=/Users/devinda/.opencode/bin:$PATH
zplug load
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/devinda/.lmstudio/bin"
# End of LM Studio CLI section

