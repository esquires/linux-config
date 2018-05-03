PATCH=$PWD/patches/0001-open-tag-in-reverse_goto-when-indicated-by-switchbuf.patch
sudo apt update
sudo apt -y upgrade
sudo apt install -y \
    curl \
    gnome-terminal \
    terminator \
    awesome \
    zsh \
    zathura \
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
    flawfinder

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

CONFIG_DIR="~/repos/linux-config"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "source $CONFIG_DIR/.bashrc" >> ~/.bashrc
echo "PATH=$PATH:~/bin" >> ~/.bashrc
mkdir ~/bin
ln -s $CONFIG_DIR/glmb.sh ~/bin/glmb
ln -s $CONFIG_DIR/cpp_static_wrapper.py ~/bin
ln -s $CONFIG_DIR/cmd_monitor.py ~/bin/cmd_monitor

echo "export ZSH=~/.oh-my-zsh" >> ~/.zshrc
echo "source $CONFIG_DIR/.zshrc" >> ~/.zshrc
echo "source $CONFIG_DIR/.bashrc" >> ~/.bashrc

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

function add_vim_repo {
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

add_vim_repo 'https://github.com/milkypostman/vim-togglelist'
add_vim_repo 'https://github.com/esquires/lvdb'
add_vim_repo 'https://github.com/Shougo/deoplete.nvim'
add_vim_repo 'https://github.com/neomake/neomake'
add_vim_repo 'https://github.com/tpope/vim-fugitive'
add_vim_repo 'https://github.com/esquires/tabcity'
add_vim_repo 'https://github.com/esquires/vim-map-medley'
add_vim_repo 'https://github.com/ctrlpvim/ctrlp.vim'
add_vim_repo 'https://github.com/majutsushi/tagbar'
add_vim_repo 'https://github.com/tmhedberg/SimpylFold'
add_vim_repo 'https://github.com/ludovicchabant/vim-gutentags'
add_vim_repo 'https://github.com/tomtom/tcomment_vim.git'
add_vim_repo 'https://github.com/esquires/neosnippet-snippets'
add_vim_repo 'https://github.com/Shougo/neosnippet.vim.git'
add_vim_repo 'https://github.com/jlanzarotta/bufexplorer.git'
add_vim_repo 'https://github.com/lervag/vimtex'

cd $DIR/vimtex
git checkout master
git reset --hard origin/master
git am -3 $PATCH

#install neovim
cd ~/repos
sudo apt-get install -y libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python-pip python3-pip

sudo apt install -y python{,3}-flake8 pylint{,3}
touch ~/.pylintrc

sudo pip3 install neovim cpplint pydocstyle neovim-remote
git clone https://github.com/neovim/neovim.git
git fetch
cd neovim
git checkout origin/master # v0.2.2 has a lua build error. This is a later commit where the build worked but prior to v0.2.3 which has not been released yet
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
cd ~/repos
git clone https://github.com/danmar/cppcheck
cd cppcheck
git pull
make SRCDIR=build CFGDIR=/usr/local/share/cppcheck/cfg HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function -march=native"
sudo install cppcheck /usr/local/bin
sudo mkdir /usr/local/share/cppcheck/cfg -p
sudo install -D ./cfg/* /usr/local/share/cppcheck/cfg

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
