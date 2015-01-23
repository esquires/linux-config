# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

##########################################3
# user specific aliases and functions
##########################################3

#stuff whose error I don't want to see
alias gvim="gvim 2>/dev/null"
alias gvimdiff="gvimdiff 2> /dev/null"
alias g='gnome-open 2>/dev/null'

#set editor to vi
set -o vi
export EDITOR=vim
set editing-mode vi
shopt -s histverify
shopt -s extglob

#make <c-w> delete a word rather than all the way to whitespace
bind '"\C-w":backward-kill-word'

#history settings
HISTSIZE=2000
HISTFILESIZE=2000
HISTCONTROL=ignoredups

#allow ctrl_s for backward searching
#see http://unix.stackexchange.com/questions/39273/how-to-navigate-within-bashs-reverse-search
#note, to quit a searchm, use ctrl_G,
#      to save a history command without running it, use "#" before the command
#see http://ruslanspivak.com/2010/11/20/bash-history-reverse-intelligent-search
stty -ixon

#setup the bash prompt
WHITE='\[\e[0;37m\]'
GREEN='\[\e[0;32m\]'
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
    PS1="${WHITE}\$(__git_ps1)${GREEN}\W: ${WHITE}"
else
    PS1="${GREEN}\W\$ ${WHITE}"
fi

#git aliases
alias gs='git status'
alias gf='git fetch'
alias gm='git merge'
alias gms='git merge -S'
alias ga='git add'
alias gcm='git commit'
alias gcms='git commit -S'
alias gco='git checkout'
alias gd='git difftool -y'
alias gb='git branch'
alias gh='git help'
alias gl='git log --pretty=format:"%G? %C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%an] %Creset" --decorate --date=short -10 --graph'
git config --global alias.unstage 'reset HEAD --'
alias gu='git unstage'
function git_fetch_dirs {

    for d in $(find -maxdepth 1 -mindepth 1); do
        cd $d
        echo "fetching in $(pwd)"
        git fetch
        cd ..
    done

}

#code from here to allow completion on git aliases
#   https://gist.github.com/JuggoPop/10706934
# Git branch bash completion
if [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash

    # Add git completion to aliases
    __git_complete g __git_main
    __git_complete gco _git_checkout
    __git_complete gl _git_log
    __git_complete glmb _git_log
    __git_complete gms _git_merge
    __git_complete gf _git_fetch
    __git_complete gb _git_branch
    __git_complete gd _git_diff
fi

#see here: http://travisjeffery.com/b/2012/02/search-a-git-repo-like-a-ninja
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global alias.g "grep --break --heading --line-number"
git config --global core.editor vim
git config --global merge.tool gvimdiff
git config --global color.ui true
git config --global core.whitespace trailing-space, space-before-tab

#other aliases
alias cb='xclip -selection clipboard'
alias grep='grep --color=auto'
alias find1='find -maxdepth 1 -mindepth 1'
alias cd='cd_stack'

#machine specific operations
if [ -f ~/.bash_specific ]; then
    source ~/.bash_specific
fi
