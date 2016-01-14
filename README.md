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

    if [ -f <dir>/cd_stack.sh ]; then
        source <dir>/cd_stack.sh
    fi
    
    PATH=$PATH:~/bin

place this in ~/.vimrc

    try
        source <dir>/.vimrc
    catch
    endtry

    set backup
    set backupdir=~/.vim/backups
    set dir=~/.vim/swaps

place this in ~/.inputrc

    $include /path/to/linux-config/.inputrc

put pylintrc in your home directory

    ln -s <dir>/.pylintrc ~/.pylintrc

to get various plugins for vim

    mkdir ~/.vim/swaps 
    mkdir ~/.vim/backups

    cd into some place where you want your repos

    DIR=$(pwd)
    mkdir -p ~/.vim/autoload
    mkdir ~/.vim/bundle

    Pathogen:

        git clone https://github.com/tpope/vim-pathogen.git
        ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

    neocomplete:

        git clone https://github.com/Shougo/neocomplete.vim.git
        ln -s $DIR/neocomplcache.vim ~/.vim/bundle/

    togglelist:

        git clone https://github.com/milkypostman/vim-togglelist
        ln -s $DIR/vim-togglelist ~/.vim/bundle/

    vim-pdb:

        git clone https://github.com/esquires/vim-pdb
        ln -s $DIR/vim-pdb ~/.vim/bundle/

    tabcity:
        git clone https://github.com/esquires/tabcity
        ln -s $DIR/tabcity ~/.vim/bundle

    vim-map-medley:
        git clone https://github.com/esquires/vim-map-medley
        ln -s $DIR/vim-map-medley ~/.vim/bundle/

    vim-matlab-fold:

        git clone https://github.com/esquires/vim-matlab-fold
        ln -s $DIR/vim-matlab-fold ~/.vim/bundle/

    syntastic:

        git clone https://github.com/scrooloose/syntastic.git
        ln -s $DIR/syntastic ~/.vim/bundle
        ln -s 

setup mutt basics (other config files are in ~/.mutt/machine\_specific)

    mkdir ~/.mutt 
    cd ~/.mutt 
    ln -s <dir>/.mutt/* .


setup ipython default

    ln -s <dir>/ipython_config.py ~/.ipython/profile_default/ipython_config.py

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
