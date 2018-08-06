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

Manual steps:

* Put this in `~/.gitconfig`. See [here](https://github.com/neovim/neovim/issues/2377)

    ```
    [merge]
        tool = nvimdiff
    [difftool "nvimdiff"] 
        cmd = terminator -x nvim -d $LOCAL $REMOTE
    [user]
        name = your_name
        email = your_email
    ``` 

* nvim, run ``:UpdateRemotePlugins`` for deoplete to work

* open ``/etc/xdg/awesome/rc.lua`` and change the following:

    ```
    local layouts =
        awful.layout.suit.floating,
        awful.layout.suit.tile.left,
        awful.layout.suit.fair,
        awful.layout.suit.max,
        awful.layout.suit.magnifier
    }
    
    terminal = "terminator -x nvim -c term -c \"normal A\""
    ```

* see ``notes/.gdbinit`` for an init file. You can run gdb linked to vim
  by hitting ``\d`` in vim and running in a terminal.

  ```gdb -x .gdbinit -f binary```

  see [lvdb](https://github.com/esquires/lvdb) for details
