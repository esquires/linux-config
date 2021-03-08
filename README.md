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

    mkdir ~/repos
    cd repos
    sudo apt install git
    git clone https://github.com/esquires/linux-config.git
    cd linux-config
    python3 ubuntu_install.py . ..

    # install oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # default to zsh
    sudo chsh -s /usr/bin/zsh $USER

    # install okular and set editor to 
    # nvr --servername /tmp/vimlatexserver --remote-silent +%l "%f"

Manual steps:

* Put this in `~/.zshrc`.

    ```
    source ~/repos/linux-config/.zshrc
    export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
    ```

* Put this in `~/.bashrc`:

    ```
    source ~/repos/linux-config/.bashrc
    export PATH=$PATH:~/bin
    export PATH=$PATH:~/repos/CodeChecker/build/CodeChecker/bin
    ```

* Put this in `~/.editrc`:

    ```
    bind -v
    ```

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

## General Notes

For zotero, you can get math equation rendering in MathJax as follows:

* render the report
* save the report
* open it and put the following lines inside the `head` tag
    
    ```[html]
    <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
    });
    </script>
    <script type="text/javascript" async
      src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML">
    </script>
    ```
* open the file in firefox
