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
        cmd = terminator -x nvim -d $LOCAL $REMOTE

Then in nvim, run ':UpdateRemotePlugins' for deoplete to work. Finally, here are
the changes from the default `rc.lua` for `awesome`

    local layouts =
        awful.layout.suit.tile.left,
        awful.layout.suit.fair,
        awful.layout.suit.max,
        awful.layout.suit.magnifier
    }
    
    terminal = "terminator -x nvim -c term -c \"normal A\""
