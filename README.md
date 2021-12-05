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
sudo apt install autojump ripgrep

# extra utilities
sudo apt install awesome okular trash-cli ccache zsh terminator exhuberant-ctags htop ninja-build

# neovim package management
mkdir -p ~/.config/nvim/pack/packer/start
git clone https://github.com/wbthomason/packer.nvim ~/.config/nvim/pack/packer/start 
THIS_REPO=$PWD
ln -s $THIS_REPO/nvim/init.lua ~/.config/nvim
ln -s $THIS_REPO/nvim/old-cfg.vim ~/.config/nvim
ln -s $THIS_REPO/nvim/lua ~/.config/nvim

# in virtual env if desired
sudo pip3 install 'python-lsp-server[all]'

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# default to zsh
sudo chsh -s /usr/bin/zsh $USER

# awesoem window manager configuration
ln -s $PWD/rc.lua ~/.config/awesome/rc.lua

# install okular and set editor to 
# nvr --servername /tmp/vimlatexserver --remote-silent +%l "%f"

# add scripts
mkdir ~/bin
for f in $(ls scripts); do ln -s $PWD/scripts/$f ~/bin/$f; done

```

Manual steps:

* In vim, run `PackerSync` and restart

* ``

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
