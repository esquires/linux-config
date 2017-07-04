sudo apt update
sudo apt upgrade
sudo apt install -y \
    curl \
    terminator \
    awesome \
    zsh \
    vim-gnome \
    mercurial \
    aptitude \
    exuberant-ctags \
    htop \
    ipython \
    ipython3 \
    python-ipdb \
    cmake-curses-gui \
    libnotify-dev \
    ninja-build

curl -o ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

CONFIG_DIR="~/repos/linux-config"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "source $CONFIG_DIR/.bashrc" >> ~/.bashrc
echo "PATH=$PATH:~/bin" >> ~/.bashrc
mkdir ~/bin
ln -s $CONFIG_DIR/glmb.sh ~/bin/glmb

echo "export ZSH=~/.oh-my-zsh" >> ~/.zshrc
echo "source $CONFIG_DIR/.zshrc" >> ~/.zshrc

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
cd repos
git clone https://github.com/valr/cbatticon.git
cd cbatticon
make PREFIX=/usr/local
sudo make PREFIX=/usr/local install

DIR=~/repos/vim
BUNDLE_DIR=~/.vim/bundle
mkdir $DIR
cd $DIR

function add_vim_repo {
    NAME=$(echo $1 | rev | cut -d '/' -f 1 | rev)
    git clone $1
    ln -s $DIR/$NAME $BUNDLE_DIR
}

git clone https://github.com/tpope/vim-pathogen.git
ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

add_vim_repo https://github.com/milkypostman/vim-togglelist
add_vim_repo https://github.com/esquires/lvdb
add_vim_repo https://github.com/Shougo/deoplete.nvim
add_vim_repo https://github.com/neomake/neomake
add_vim_repo https://github.com/tpope/vim-fugitive
add_vim_repo https://github.com/esquires/tabcity
add_vim_repo https://github.com/esquires/vim-map-medley
add_vim_repo https://github.com/ctrlpvim/ctrlp.vim
add_vim_repo https://github.com/majutsushi/tagbar

#install neovim
mkdir ~/repos/neovim
cd ~/repos/neovim
sudo apt-get install libtool libtool-bin autoconf automake cmake g++ pkg-config unzip python3-pip

sudo apt install -y cppcheck python{,3}-flake8
sudo pip3 install neovim cpplint
git clone https://github.com/neovim/neovim.git
cd neovim
git checkout v0.2.0
mkdir .deps && cd .deps && cmake ../third-party -G Ninja && ninja
cd .. && mkdir build && cd build && cmake .. -G Ninja && ninja && sudo ninja install

mkdir -p ~/.config/nvim
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc" > ~/.config/nvim/init.vim

sudo chsh -s /usr/bin/zsh $USER

# setup python (and setup vim bindings for the shell)
ipython profile create
sed -i "s/#\(c.TerminalInteractiveShell.editing_mode = \)'emacs'/\1 'vi'/" ~/.ipython/profile_default/ipython_config.py

cd ~/repos/vim/lvdb/python
sudo python setup.py develop
sudo python3 setup.py develop
