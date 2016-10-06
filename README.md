Linux Config
===

Installation
---

general configuration

    curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

place this in ~/.bashrc

    if [ -f <dir>/.bashrc ]; then
        source <dir>/.bashrc
    fi

    PATH=$PATH:~/bin

place this in ~/.zshrc (and install https://github.com/robbyrussell/oh-my-zsh)
    
    export ZSH=~/path_to_oh_my_zsh_install
    source ~/repos/linux-config/.zshrc

place this in ~/.vimrc

    try
        source <dir>/.vimrc
    catch
    endtry

    set backup
    set backupdir=~/.vim/backups
    set dir=~/.vim/swaps

place this in ~/.inputrc

    #get vi mode for all binaries called from bash
    #http://acg.github.io/2011/05/17/put-everything-in-vi-mode.html
    set keymap vi
    set editing-mode vi
    
    $if mode=vi
        set keymap vi-insert
        "jk": vi-movement-mode
        "\C-p": "jkk"
    $endif

    set bind-tty-special-chars off

to get various plugins for vim

    mkdir ~/.vim/swaps 
    mkdir ~/.vim/backups

    cd into some place where you want your repos

    DIR=$(pwd)
    mkdir -p ~/.vim/autoload
    mkdir ~/.vim/bundle

    pathogen:

        git clone https://github.com/tpope/vim-pathogen.git
        ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

    togglelist:

        git clone https://github.com/milkypostman/vim-togglelist
        ln -s $DIR/vim-togglelist ~/.vim/bundle/

    lvdb:

        git clone https://github.com/esquires/lvdb
        ln -s $DIR/lvdb ~/.vim/bundle/

    tabcity:
        git clone https://github.com/esquires/tabcity
        ln -s $DIR/tabcity ~/.vim/bundle

    vim-map-medley:

        git clone https://github.com/esquires/vim-map-medley
        ln -s $DIR/vim-map-medley ~/.vim/bundle/

    syntastic:

        git clone https://github.com/scrooloose/syntastic.git
        ln -s $DIR/syntastic ~/.vim/bundle

    vim-l9:
        # installed as a dependency for vim-fuzzyfinder
        hg clone https://bitbucket.org/ns9tks/vim-l9
        ln -s $DIR/vim-l9 ~/.vim/bundle

    vim-fuzzyfinder:
        hg clone https://bitbucket.org/ns9tks/vim-fuzzyfinder
        ln -s $DIR/vim-fuzzyfinder ~/.vim/bundle

    youcompleteme:
        # this is in the ubuntu packages under `vim-youcompleteme` or
        # arch linux in the aur
        # for ubuntu, do 
        sudo apt install vim-youcompleteme && vam install youcompleteme


awesome window manager setup

    in ~/.config/awesome/rc.lua, place the following:

        terminal = 'whatever your terminal program is'
        local awful = require("awful")

        require("gen_config")

        -- {{{ Tags
        -- Define a tag table which hold all screen tags.
        tags = {}
        for s = 1, screen.count() do
            -- Each screen has its own tag table.
            tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
        end
        -- }}}

    then in bash, type

        ln -s <dir>/gen_config.lua ~/.config/awesome/gen_config.lua
