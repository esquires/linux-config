Linux Config
===

Installation
---

setup git
    sudo apt install git
    git config --global user.name your_name
    git config --global user.email your_email

This assumes a particular path for installation::

    mkdir ~/repos
    cd repos
    git clone https://github.com/esquires/linux-config.git
    cd linux-config
    bash ubuntu_install.sh

Alternative installation (experimental):

    mkdir ~/repos
    cd repos
    git clone https://github.com/esquires/linux-config.git
    cd linux-config
    python3 ubuntu_install.py

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # default to zsh
    sudo chsh -s /usr/bin/zsh $USER

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

* Put this in `~/.zshrc`.

    ```
    source ~/repos/linux-config/.zshrc
    export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
    ```

* Put this in `~/.bashrc`:

    ```
    source ~/repos/linux-config/.bashrc
    echo "PATH=$PATH:~/bin" >> ~/.bashrc
    export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
    ```

* Put this in `~/.editrc`:

    ```
    bind -v
    ```

* nvim, run ``:UpdateRemotePlugins`` for deoplete to work

* see ``notes/.lldbinit`` and ``notes/.gdbinit`` for an init file. You can run
  debuggers linked linked to vim by hitting ``\d`` in vim and running in a terminal.

  ```lldb -x ~/.lldbinit -f binary```
  ```gdb -x .gdbinit -f binary```

  see [lvdb](https://github.com/esquires/lvdb) for details

* for clang static analysis, execute

  ```
  source ~/repos/CodeChecker/venv/bin/activate
  cd build
  rm CMakeCache.txt
  cmake .. -G Ninja
  CodeChecker log -b "ninja" -o compilation.json
  CodeChecker analyze compilation.json -o ./reports
  CodeChecker parse ./reports -i skipfile
  ```
  
* `ln ~/repos/linux-config/init.el ~/.emacs.d/init.el`
