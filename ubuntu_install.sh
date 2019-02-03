sudo apt update
sudo apt -y upgrade
sudo apt install -y \
    ccache \
    curl \
    gnome-terminal \
    terminator \
    awesome \
    zsh \
    zathura \
    xdotool \
    aptitude \
    exuberant-ctags \
    global \
    htop \
    ipython \
    ipython3 \
    python-ipdb \
    xclip \
    cmake-curses-gui \
    libnotify-dev \
    ninja-build \
    flake8 \
    notify-osd \ 
    ubuntu-sounds \
    flawfinder

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

sudo pip3 install cmd_monitor

CONFIG_DIR="/home/$USER/repos/linux-config"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

mkdir ~/bin
ln -v -fs $CONFIG_DIR/scripts/glmb.sh /home/$USER/bin/glmb
ln -v -fs $CONFIG_DIR/scripts/cpp_static_wrapper.py /home/$USER/bin

mkdir ~/.vim
mkdir ~/.vim/{bundle,autoload,swaps,backups}
echo "source $CONFIG_DIR/.vimrc" >> ~/.vimrc
echo "set backup" >> ~/.vimrc
echo "set backupdir=~/.vim/backups" >> ~/.vimrc
echo "set dir=~/.vim/swaps" >> ~/.vimrc

echo "set keymap vi" >> ~/.inputrc
echo "set editing-mode vi" >> ~/.inputrc
echo "set bind-tty-special-chars off" >> ~/.inputrc

mkdir ~/repos
cd ~/repos
sudo apt install -y libnotify-dev libgtk-3-dev
git clone https://github.com/valr/cbatticon.git
git pull
cd cbatticon
git pull
make PREFIX=/usr/local
sudo make PREFIX=/usr/local install

DIR=~/repos/vim
BUNDLE_DIR=~/.vim/bundle
mkdir $DIR
cd $DIR

function add_repo {
    NAME=$(echo $1 | rev | cut -d '/' -f 1 | rev)
    cd $DIR
    git clone $1 $NAME
    cd $DIR/$NAME
    pwd
    git pull
    ln -s $DIR/$NAME $BUNDLE_DIR
}

git clone https://github.com/tpope/vim-pathogen.git
cd vim-pathogen
git pull
ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

add_repo 'https://github.com/milkypostman/vim-togglelist'
add_repo 'https://github.com/esquires/lvdb'
add_repo 'https://github.com/Shougo/deoplete.nvim'
add_repo 'https://github.com/neomake/neomake'
add_repo 'https://github.com/tpope/vim-fugitive'
add_repo 'https://github.com/esquires/tabcity'
add_repo 'https://github.com/esquires/vim-map-medley'
add_repo 'https://github.com/ctrlpvim/ctrlp.vim'
add_repo 'https://github.com/majutsushi/tagbar'
add_repo 'https://github.com/tmhedberg/SimpylFold'
add_repo 'https://github.com/ludovicchabant/vim-gutentags'
add_repo 'https://github.com/tomtom/tcomment_vim.git'
add_repo 'https://github.com/esquires/neosnippet-snippets'
add_repo 'https://github.com/Shougo/neosnippet.vim.git'
add_repo 'https://github.com/jlanzarotta/bufexplorer.git'
add_repo 'https://github.com/lervag/vimtex'
add_repo 'https://github.com/vim-airline/vim-airline'
add_repo 'https://github.com/Shougo/echodoc.vim.git'

# orgmode and its dependencies
add_repo 'https://github.com/jceb/vim-orgmode'
add_repo 'https://github.com/vim-scripts/utl.vim'
add_repo 'https://github.com/tpope/vim-repeat'
add_repo 'https://github.com/tpope/vim-speeddating'
add_repo 'https://github.com/chrisbra/NrrwRgn'
add_repo 'https://github.com/mattn/calendar-vim'
add_repo 'https://github.com/inkarkat/vim-SyntaxRange'

cd $DIR/vimtex
git checkout master
git reset --hard origin/master
PATCH=$CONFIG_DIR/patches/0001-open-tag-in-reverse_goto-when-indicated-by-switchbuf.patch
git am -m "[PATCH] open tag in reverse_goto when indicated by switchbuf" -3 $PATCH

#install neovim
cd ~/repos
sudo apt-get install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python-pip python3-pip

sudo apt install -y python{,3}-flake8 pylint{,3}
touch ~/.pylintrc

sudo pip3 install neovim cpplint pydocstyle neovim-remote
git clone https://github.com/neovim/neovim.git
git fetch
cd neovim
git checkout v0.3.0
mkdir .deps
cd .deps && cmake ../third-party -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_BUILD_TYPE=Release && make
cd .. 
mkdir build 
cd build && cmake .. -G Ninja -DCMAKE_CXX_FLAGS=-march=native -DCMAKE_BUILD_TYPE=Release && ninja &&  sudo ninja install

mkdir -p ~/.config/nvim
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc" > ~/.config/nvim/init.vim

sudo chsh -s /usr/bin/zsh $USER

# cppcheck
PATCH=$CONFIG_DIR/patches/0001-add-ccache.patch
cd ~/repos
git clone https://github.com/danmar/cppcheck
cd cppcheck
git pull
git reset --hard origin/master
echo
git am -3 $PATCH
mkdir -p build
cd build
cmake .. -G Ninja -DCMAKE_CXX_FLAGS=" -march=native " -DCMAKE_BUILD_TYPE=Release
ninja
sudo ninja install

# cppclean
cd ~/repos
git clone https://github.com/myint/cppclean.git
cd cppclean
git pull
sudo pip3 install -e .

# setup python (and setup vim bindings for the shell)
ipython profile create
sed -i "s/#\(c.TerminalInteractiveShell.editing_mode = \)'emacs'/\1 'vi'/" ~/.ipython/profile_default/ipython_config.py

cd ~/repos/vim/lvdb/python
sudo python setup.py develop
sudo python3 setup.py develop

#see here: http://travisjeffery.com/b/2012/02/search-a-git-repo-like-a-ninja
git config --global alias.unstage 'reset HEAD --'
git config --global --replace-all core.pager "less -F -X"
git config --global grep.extendRegexp true
git config --global grep.lineNumber true
git config --global alias.g "grep --break --heading --line-number"
git config --global core.editor nvim
git config --global merge.tool nvimdiff
git config --global color.ui true
git config --global core.whitespace trailing-space, space-before-tab

# git-latexdiff
cd ~/repos
git clone https://gitlab.com/git-latexdiff/git-latexdiff
cd git-latexdiff
git pull
sed -i -E 's:^gitexecdir = \$\{shell git --man-path\}$:gitexecdir = /usr/bin:' Makefile
sudo make install

# emacs dependencies
DIR=~/repos/emacs
mkdir $DIR
cd $DIR
add_repo 'https://github.com/magnars/dash.el'
add_repo 'https://github.com/emacs-evil/evil'
add_repo 'https://github.com/GuiltyDolphin/monitor'
add_repo 'https://github.com/GuiltyDolphin/org-evil'
