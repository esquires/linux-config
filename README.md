Linux Config
===

Installation
---

place this in ~/.bashrc

    if [ -f <dir>/.bashrc ]; then
        source <dir>/.bashrc
    fi

    PATH=$PATH:~/bin

place this in ~/.vimrc


    try
        source <dir>/.vimrc
    catch
    endtry

place this in ~/.inputrc 

    #get vi mode for all binaries called from bash 
    #http://acg.github.io/2011/05/17/put-everything-in-vi-mode.html
    set keymap vi 
    set editing-mode vi
    
    $if mode=vi
        set keymap vi-insert 
        "jk": vi-movement-mode
    $endif 
    
to get various plugins for vim

    cd into some place where you want your repos

    DIR=$(pwd)
    mkdir -p ~/.vim/autoload
    mkdir ~/.vim/bundle

    Pathogen:

        git clone https://github.com/tpope/vim-pathogen.git
        ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

    Nerdtree:       

        git clone https://github.com/scrooloose/nerdtree
        git clone https://github.com/jistr/vim-nerdtree-tabs
        ln -s $DIR/nerdtree ~/.vim/bundle/
        ln -s $DIR/vim-nerdtree-tabs ~/.vim/bundle/
    
    neocomplcache: 
    
        git clone https://github.com/Shougo/neocomplcache.vim
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

    colors:         
    
        mkdir ~/.vim/colors
        wget -P ~/.vim/colors -O wombat256.vim http://www.vim.org/scripts/download_script.php?src_id=13397

if using lxde as the desktop environment, place this in
    ~/.config/openbox/lxde-rc.xml

    http://superuser.com/questions/167259/how-can-i-add-a-lxde-shortcut-to-launch-an-application
    http://openbox.org/wiki/Help:Actions
    http://openbox.org/wiki/Help:Bindings

    <!-- Maximize commands -->
    <keybind key="W-Up">
        <action name="ToggleMaximizeFull" />
    </keybind>

    <keybind key="W-S-Up">
        <action name="ToggleMaximizeVert" />
    </keybind>

    <keybind key="W-S-Down">
        <action name="ToggleMaximizeHorz" />
    </keybind>

    <!-- application execute commands -->
    <keybind key="W-c">
        <action name="Execute">
            <command>chromium</command>
        </action>
    </keybind>

    <keybind key="C-A-t">
        <action name="Execute">
            <command>lxterminal</command>
        </action>
    </keybind>

    <!-- window movement -->
    <keybind key="W-A-Up">
        <action name="MoveToEdgeNorth"/>
    </keybind>

    <keybind key="W-A-Down">
        <action name="MoveToEdgeSouth"/>
    </keybind>

    <keybind key="W-A-Left">
        <action name="MoveToEdgeWest"/>
    </keybind>

    <keybind key="W-A-Right">
        <action name="MoveToEdgeEast"/>
    </keybind>
