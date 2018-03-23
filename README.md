Linux Config
===

Installation
---

This assumes a particular path for installation::

    mkdir ~/repos
    cd repos
    git clone https://github.com/esquires/linux-config.git
    cd linux-config
    bash ubuntu_install.sh

I also manually put this in `~/.gitconfig`. See [here](https://github.com/neovim/neovim/issues/2377)

    [merge]
        tool = nvimdiff
    [difftool "nvimdiff"] 
        cmd = nvim -d $LOCAL $REMOTE
