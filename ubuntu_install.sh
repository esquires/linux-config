sudo apt update
sudo apt upgrade
sudo apt install -y \
	git \
	awesome \
	zsh \
	vim-gnome \
	mercurial \
	vim-youcompleteme

vam install youcompleteme

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

DIR=~/repos/vim
mkdir $DIR
cd $DIR

git clone https://github.com/tpope/vim-pathogen.git
ln -s $DIR/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

git clone https://github.com/milkypostman/vim-togglelist
ln -s $DIR/vim-togglelist ~/.vim/bundle/

git clone https://github.com/esquires/lvdb
ln -s $DIR/lvdb ~/.vim/bundle/

git clone https://github.com/esquires/tabcity
ln -s $DIR/tabcity ~/.vim/bundle

git clone https://github.com/esquires/vim-map-medley
ln -s $DIR/vim-map-medley ~/.vim/bundle/

git clone https://github.com/scrooloose/syntastic.git
ln -s $DIR/syntastic ~/.vim/bundle

git clone https://github.com/scrooloose/syntastic.git
ln -s $DIR/syntastic ~/.vim/bundle

git clone https://github.com/ctrlpvim/ctrlp.vim.git
ln -s $DIR/ctrlp.vim ~/.vim/bundle

git clone https://github.com/majutsushi/tagbar.git
ln -s $DIR/tagbar ~/.vim/bundle

sudo chsh -s /usr/bin/zsh $USER
