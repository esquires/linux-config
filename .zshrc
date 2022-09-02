export ZSH=~/.oh-my-zsh
plugins=(
  git
  command-not-found 
  wd
  last-working-dir
  docker
  docker-compose
  autojump
  colorize
)
ZSH_THEME="robbyrussell"
CASE_SENSITIVE="true"
source $ZSH/oh-my-zsh.sh

ZSH_COLORIZE_STYLE="fruity"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt PUSHD_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

setopt sharehistory
setopt extendedhistory

export EDITOR=vim

bindkey -v

function abcdefg {
    up-history 
    vi-cmd-mode
}

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward
bindkey '^u' backward-kill-line

# http://dougblack.io/words/zsh-vi-mode.html
# http://stackoverflow.com/a/3791786
function zle-line-init zle-keymap-select zle-history-line-set {
    VIM_NORMAL="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    VIM_INSERT="%{$fg_bold[green]%} [% INSERT]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-history-line-set
export KEYTIMEOUT=1

alias d='docker'
alias dr="docker run --rm -ti $(docker images | head -2 | tail -1 | tr -s ' ' | cut -d ' ' -f 3) /bin/bash "

#git aliases
alias gs='git status'
alias gf='git fetch'
alias gm='git merge'
alias gms='git merge -S'
alias ga='git add'
alias gcm='git commit'
alias gcms='git commit -S'
alias gco='git checkout'
alias gd='git difftool -y 2> /dev/null'
alias gb='git branch'
alias gh='git help'
alias gl='git log --pretty=format:"%C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%an] %Creset" --decorate --date=short -10 --graph'
alias gu='git unstage'
compdef __git_branch_names glmb

#other aliases
alias grep='grep --color=auto'
alias find1='find -maxdepth 1 -mindepth 1'
alias CLR='for i in {1..99}; do echo; done; clear'

function git_pull_dirs {

    TEMP_OLDPWD=$OLDPWD

    for d in $(dirname $(find -name "\.git")); do
        cd $d
        git pull
        cd $OLDPWD
    done

    OLDPWD=$TEMP_OLDPWD

}

alias ld="latexdiff-wrapper"
alias vim="nvim"
alias vimt="nvim -c term"
alias vimlatex="nvim --headless -c 'VimtexInverseSearch %l %f'"
alias gvim="gnome-terminal -- nvim -p"
alias rm='echo "use trash-put!"'

complete -F "ahoy --generate-bash-completion" ahoy
# alias vim='source ~/anaconda3/bin/activate && conda activate vim && nvim '
