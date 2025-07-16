# Linux Config

## Installation

Put this in `~/.gitconfig`. See [here](https://github.com/neovim/neovim/issues/2377):

    [merge]
        tool = nvimdiff
    [difftool "nvimdiff"] 
        cmd = terminator -x nvim -d $LOCAL $REMOTE
    [core]
        editor = nvim
        pager = less -F -X
    [user]
        name = your_name
        email = your_email

Installation:

* [Neovim](https://github.com/neovim/neovim)
* [Fzf](https://github.com/junegunn/fzf)

```bash
# useful packages
sudo apt install autojump 

# extra utilities
sudo apt install awesome okular trash-cli ccache zsh htop fzf

# neovim dependencies
sudo apt install ninja-build libluajit-5.1-dev ripgrep gettext luarocks imagemagick libmagickwand-dev

# in virtual env if desired
source ~/anaconda3/bin/activate
conda create -y -n vim python=3.8
conda activate vim
pip install "python-lsp-server[all]" pyls-flake8 pylsp-mypy flake8 pydocstyle pylint mypy python-lsp-black jedi isort black
# conda install clangdev clang
# note: add -DCMAKE_EXPORT_COMPILE_COMMANDS=1 for builds
# https://stackoverflow.com/q/73546064

ln -s $PWD/nvim/init.lua ~/.config/nvim
ln -s $PWD/nvim/lua ~/.config/nvim
ln -s $PWD/nvim/after ~/.config/nvim
ln -s $PWD/nvim/old-cfg.vim ~/.config/nvim

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# default to zsh
sudo chsh -s /usr/bin/zsh $USER

# awesome window manager configuration
ln -s $PWD/rc.lua ~/.config/awesome/rc.lua
cd ~/.config/awesome/
git clone https://github.com/streetturtle/awesome-wm-widgets

# install okular and set editor to 
# nvr --servername /tmp/vimlatexserver --remote-silent +%l "%f"

# add scripts
mkdir -p ~/bin
ln -s $PWD/scripts ~/bin/scripts
```

Manual steps:

* Put this in `~/.zshrc`.

```bash
source ~/repos/linux-config/.zshrc
export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
```

* Put this in `~/.bashrc`:

```bash
source ~/repos/linux-config/.bashrc
export PATH=$PATH:~/bin
export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
```

* Put this in `~/.editrc`:

```bash
bind -v
```

* see ``notes/.lldbinit`` and ``notes/.gdbinit`` for an init file. You can run
  debuggers linked linked to vim by hitting ``\d`` in vim and running in a terminal.

  ```lldb -x ~/.lldbinit -f binary```
  ```gdb -x .gdbinit -f binary```

  see [lvdb](https://github.com/esquires/lvdb) for details
