# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

##########################################3
# user specific aliases and functions
##########################################3

#stuff whose error I don't want to see
alias vim="nvim"
alias vimt="nvim -c term"
alias gvim="gnome-terminal -x nvim -p"

#set editor to vi
# set -o vi
# export EDITOR=vim
# set editing-mode vi
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
alias gl='git log --pretty=format:"%C(yellow)%h %ad %Creset%s %C(red)%d %Cgreen[%an] %Creset" --decorate --date=short -10 --graph'
git config --global alias.unstage 'reset HEAD --'
git config --global --replace-all core.pager "less -F -X"
alias gu='git unstage'

function git_fetch_dirs {

    TEMP_OLDPWD=$OLDPWD

    for d in $(dirname $(find -name "\.git")); do
        cd $d
        echo "fetching " $d
        git fetch
        cd $OLDPWD
    done

    OLDPWD=$TEMP_OLDPWD

}

function check_new_deps {

    aurPkgs=$(pacman -Qm | cut -d ' ' -f 1)

    for aurPkg in $aurPkgs; do

        aurDte=$(pacman -Qi $aurPkg | grep "Install Date" | cut -d ':' -f 2-)
        aurDte=$(date --date="$aurDte" "+%s")

        depPkgs=$(pacman -Qi $aurPkg | grep "Depends On" | cut -d ':' -f 2-)

        for depPkg in $depPkgs; do 

            depDte=$(pacman -Qi $depPkg | grep "Install Date" | cut -d ':' -f 2-)
            depDte=$(date --date="$depDte" "+%s")
            if [[ $aurDte -lt $depDte ]]; then 
                echo "update $aurPkg given $depPkg is more recent"
            fi

        done 

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
    __git_complete gm _git_merge
    __git_complete gf _git_fetch
    __git_complete gb _git_branch
    __git_complete gd _git_diff
fi

#see here: http://travisjeffery.com/b/2012/02/search-a-git-repo-like-a-ninja
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global alias.g "grep --break --heading --line-number"
# git config --global core.editor vim
# git config --global merge.tool gvimdiff
git config --global color.ui true
# git config --global core.whitespace trailing-space, space-before-tab

#other aliases
alias cb='xclip -selection clipboard'
alias grep='grep --color=auto'
alias find1='find -maxdepth 1 -mindepth 1'
alias l='ls -lh'
alias CLR='for i in {1..99}; do echo; done; clear'
alias g="gnome-terminal -x nvim -p"
alias rm='echo "use trash-put!"'

#machine specific operations
if [ -f ~/.bash_specific ]; then
    source ~/.bash_specific
fi
