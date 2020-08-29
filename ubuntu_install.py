import argparse
import subprocess as sp
import os.path as op
import shutil
import os
import pathlib
import sys
import re

HOME = os.environ['HOME']

def install_git_bash_completion():
    url_base = \
        'https://raw.githubusercontent.com/git/git/master/contrib/completion/'
    files = [f for f in ['git-completion.bash', 'git-prompt.sh']
             if not op.isfile(op.join(HOME, '.' + f))]
    for f in files:
        sp.check_call(['curl', '-o', op.join(HOME, '.' + f), url_base + f])


def add_lines(fname, lines_to_add):
    pathlib.Path(fname).touch()  # make sure the file exists
    with open(fname, 'r') as f:
        lines = f.read().splitlines()

    if not set(lines).intersection(lines_to_add):
        lines += lines_to_add
        with open(fname, 'w') as f:
            f.write('\n'.join(lines))


def install_scripts():
    bin_dir = op.join(HOME, 'bin')
    os.makedirs(bin_dir, exist_ok=True)
    p = op.join(os.getcwd(), 'scripts')
    files = [f for f in os.listdir(p)
             if op.isfile(op.join(p, f)) and
             not op.isfile(op.join(bin_dir, f))]
    for f in files:
        os.symlink(op.join(p, f), op.join(bin_dir, f))


def setup_vimrc(config_dir):
    for d in ['bundle', 'autoload', 'swaps', 'backups']:
        os.makedirs(op.join(HOME, ".vim", d), exist_ok=True)

    lines_to_add = [
        'source ' + op.join(config_dir, '.vimrc'),
        'set backup',
        'set backupdir=' + op.join(HOME, '.vim', 'backups'),
        'set dir=' + op.join(HOME, '.vim', 'swaps')]

    add_lines(op.join(HOME, '.vimrc'), lines_to_add)


def setup_inputrc():
    lines_to_add = [
        'set keymap vi',
        'set editing-mode vi',
        'set bind-tty-special-chars-off']
    add_lines(op.join(HOME, '.inputrc'), lines_to_add)


def run_apt():
    pkgs = [
        "ccache",
        "curl",
        "gnome-terminal",
        "terminator",
        "zsh",
        "zathura",
        "xdotool",
        "aptitude",
        "exuberant-ctags",
        "global",
        "htop",
        "ipython",
        "python-pip",
        "python3-pip",
        "ipython3",
        "python-ipdb",
        "xclip",
        "cmake-curses-gui",
        "libnotify-dev",
        "ninja-build",
        "flake8",
        "notify-osd",
        "ubuntu-sounds",
        "workrave",
        "clang-tools-6.0"]

    sp.check_call(['sudo', 'apt', 'update'])
    # sp.check_call(['sudo', 'apt', '-y', 'upgrade'])
    sp.check_call(['sudo', 'apt', 'install', '-y'] + pkgs)


def update_repo(url, parent_dir, sha=None):
    tail = url.split('/')[-1]
    if tail[-4:] == '.git':
        tail = tail[:-4]
    repo_dir = op.join(parent_dir, tail)
    if not op.isdir(repo_dir):
        sp.check_call(['git', 'clone', url], cwd=parent_dir)

    if sha:
        sp.check_call(['git', 'fetch'], cwd=repo_dir)
        sp.check_call(['git', 'checkout', sha], cwd=repo_dir)
    else:
        try:
            sp.check_call(['git', 'pull'], cwd=repo_dir)
        except sp.CalledProcessError:
            sp.check_call(['git', 'fetch'], cwd=repo_dir)



def install_cbatticon(repos_dir):
    cbatticon_dir = op.join(repos_dir, 'cbatticon')
    sp.check_call(
        ['sudo', 'apt', 'install', '-y', 'libnotify-dev', 'libgtk-3-dev'])
    update_repo('https://github.com/valr/cbatticon.git', repos_dir)
    sp.check_call(['make', 'prefix=/usr/local'], cwd=cbatticon_dir)
    sp.check_call(['sudo', 'make', 'prefix=/usr/local', 'install'],
                  cwd=cbatticon_dir)


def install_vim_plugins(config_dir, repos_dir):
    vim_dir = op.join(repos_dir, 'vim')
    os.makedirs(vim_dir, exist_ok=True)
    os.makedirs(op.join(HOME, '.vim', 'autoload'), exist_ok=True)
    os.makedirs(op.join(HOME, '.vim', 'bundle'), exist_ok=True)
    update_repo('https://github.com/tpope/vim-pathogen.git', vim_dir)
    try:
        os.symlink(
            op.join(vim_dir, 'vim-pathogen', 'autoload', 'pathogen.vim'),
            op.join(HOME, '.vim', 'autoload', 'pathogen.vim'))
    except FileExistsError:
        pass

    def _update(repo, sha=None):
        update_repo(repo, vim_dir, sha)
        repo_name = repo.split('/')[-1]
        if repo_name.split('.')[-1] == 'git':
            repo_name = '.'.join(repo_name.split('.')[:-1])
        try:
            os.symlink(op.join(vim_dir, repo_name),
                       op.join(HOME, '.vim', 'bundle', repo_name))
        except FileExistsError:
            pass

    _update('https://github.com/milkypostman/vim-togglelist')
    _update('https://github.com/neomake/neomake')
    _update('https://github.com/tpope/vim-fugitive')
    _update('https://github.com/esquires/tabcity')
    _update('https://github.com/esquires/vim-map-medley')
    _update('https://github.com/ctrlpvim/ctrlp.vim')
    _update('https://github.com/majutsushi/tagbar')
    _update('https://github.com/tmhedberg/SimpylFold')
    _update('https://github.com/ludovicchabant/vim-gutentags')
    _update('https://github.com/tomtom/tcomment_vim.git')
    _update('https://github.com/esquires/neosnippet-snippets')
    _update('https://github.com/Shougo/neosnippet.vim.git')
    _update('https://github.com/jlanzarotta/bufexplorer.git')
    _update('https://github.com/lervag/vimtex')
    _update('https://github.com/vim-airline/vim-airline')
    _update('https://github.com/Shougo/echodoc.vim.git')
    _update('https://github.com/tpope/vim-surround')
    _update('https://github.com/tpope/vim-repeat')
    _update('https://github.com/chaoren/vim-wordmotion')

    # deoplete has a 3.6 dependency after the below commit
    deoplete_sha = 'origin/master' if sys.version_info >= (3, 6) else '7853113'
    _update('https://github.com/Shougo/deoplete.nvim', deoplete_sha)
    _update('https://github.com/Shougo/neco-syntax.git')
    _update('https://github.com/autozimu/LanguageClient-neovim')

    sp.check_call(['nvim', '-c', 'UpdateRemotePlugins', '-c', 'q'])

    # lvdb
    lvdb_python_dir = op.join(vim_dir, 'lvdb', 'python')
    _update('https://github.com/esquires/lvdb')
    sp.check_call(['sudo', 'pip2', 'install', '-e', '.'], cwd=lvdb_python_dir)
    sp.check_call(['sudo', 'pip3', 'install', '-e', '.'], cwd=lvdb_python_dir)

    # LanguageClient-neovim dependencies
    languageclient_dir = op.join(vim_dir, 'LanguageClient-neovim')
    sp.check_call(['bash', 'install.sh'], cwd=languageclient_dir)
    sp.check_call(['sudo', 'pip3', 'install', 'python-language-server[all]'])

    # orgmode and its dependencies
    update_repo('https://github.com/jceb/vim-orgmode', vim_dir)
    update_repo('https://github.com/vim-scripts/utl.vim', vim_dir)
    update_repo('https://github.com/tpope/vim-repeat', vim_dir)
    update_repo('https://github.com/tpope/vim-speeddating', vim_dir)
    update_repo('https://github.com/chrisbra/NrrwRgn', vim_dir)
    update_repo('https://github.com/mattn/calendar-vim', vim_dir)
    update_repo('https://github.com/inkarkat/vim-SyntaxRange', vim_dir)

    # patches
    vimtex_dir = op.join(vim_dir, 'vimtex')
    patch_msg = '[PATCH] open tag in reverse_goto when indicated by switchbuf'
    patch_file = op.join(
        config_dir, 'patches',
        '0001-open-tag-in-reverse_goto-when-indicated-by-switchbuf.patch')
    apply_patch(patch_file, patch_msg, vimtex_dir)


def apply_patch(patch_file, patch_msg, d):
    sp.check_call(['git', 'checkout', '-f', 'master'], cwd=d)
    sp.check_call(['git', 'reset', '--hard', 'origin/master'], cwd=d)
    sp.check_call(['git', 'am', '-3', patch_file], cwd=d)


def install_neovim(repos_dir):
    apt_pkgs = [
        'libtool',
        'libtool-bin',
        'autoconf',
        'automake',
        'cmake',
        'g++',
        'pkg-config',
        'unzip',
        'python-pip',
        'python3-pip',
        'python3-flake8',
        'pylint3']

    sp.check_call(['sudo', 'apt', 'install', '-y'] + apt_pkgs)
    sp.check_call(['touch', op.join(HOME, '.pylintrc')])

    pip_packages = ['neovim', 'cpplint', 'pydocstyle', 'neovim-remote']
    sp.check_call(['sudo', 'pip3', 'install'] + pip_packages)

    update_repo('https://github.com/neovim/neovim.git', repos_dir)
    neovim_dir = op.join(repos_dir, 'neovim')
    sp.check_call(['git', 'checkout', 'v0.4.4'], cwd=neovim_dir)

    deps_dir = op.join(neovim_dir, '.deps')
    os.makedirs(deps_dir, exist_ok=True)
    sp.check_call(
        ['make', 'CMAKE_BUILD_TYPE=Release'], cwd=neovim_dir)
    sp.check_call(['sudo', 'make', 'install'], cwd=neovim_dir)

    os.makedirs(op.join(HOME, '.config', 'nvim'), exist_ok=True)
    lines_to_add = [
        'set runtimepath^=~/.vim runtimepath+=~/.vim/after',
        'let &packpath = &runtimepath',
        'source ~/.vimrc']
    add_lines(op.join(HOME, '.config', 'nvim', 'init.vim'), lines_to_add)


def install_cppcheck(config_dir, repos_dir):
    update_repo('https://github.com/danmar/cppcheck', repos_dir)

    cppcheck_dir = op.join(repos_dir, 'cppcheck')
    patch_msg = '[PATCH] add ccache'
    patch_file = op.join(config_dir, 'patches', '0001-add-ccache.patch')
    apply_patch(patch_file, patch_msg, cppcheck_dir)

    build_dir = op.join(cppcheck_dir, 'build')
    os.makedirs(build_dir, exist_ok=True)
    sp.check_call([
        'cmake', '..', '-G', 'Ninja', "-DCMAKE_CXX_FLAGS='-march=native'",
        '-DCMAKE_BUILD_TYPE=Release'], cwd=build_dir)
    sp.check_call(['ninja'], cwd=build_dir)
    sp.check_call(['sudo', 'ninja', 'install'], cwd=build_dir)


def install_cppclean(repos_dir):
    cppclean_dir = op.join(repos_dir, 'cppclean')
    update_repo('https://github.com/myint/cppclean.git', repos_dir)
    sp.check_call(['sudo', 'pip3', 'install', '-e', '.'], cwd=cppclean_dir)


def install_cmd_monitor(repos_dir):
    cmd_monitor_dir = op.join(repos_dir, 'cmd_monitor')
    update_repo('https://github.com/esquires/cmd_monitor', repos_dir)
    sp.check_call(['sudo', 'pip3', 'install', '-e', '.'], cwd=cmd_monitor_dir)


def setup_ipython():
    sp.check_call(['ipython', 'profile', 'create'])
    config = op.join(HOME, '.ipython', 'profile_default', 'ipython_config.py')
    add_lines(config, ["c.TerminalInteractiveShell.editing_mode =  'vi'"])
    add_lines(config, ["c.InteractiveShellApp.extensions = ['autoreload']"])
    exec_lines = ['%autoreload 2', 'import numpy as np']
    add_lines(config, [f"c.InteractiveShellApp.exec_lines = {exec_lines}"])


def install_awesome(config_dir):
    sp.check_call(['sudo', 'apt', 'install', '-y', 'awesome'])
    awesome_dir = op.join(HOME, '.config', 'awesome')
    os.makedirs(awesome_dir, exist_ok=True)

    awesome_version = \
        sp.Popen(['awesome', '-v'], stdout=sp.PIPE).communicate()[0].decode()
    awesome_version = int(re.search(r' v(\d+).\d+', awesome_version).group(1))
    rc_lua = 'rc4.lua' if awesome_version == 4 else 'rc.lua'
    try:
        os.symlink(
            op.join(config_dir, rc_lua), op.join(awesome_dir, 'rc.lua'))
    except FileExistsError:
        pass


def install_pip_packages():
    sp.check_call(["sudo", "pip3", "install", "flawfinder", "proselint"])


def install_latexdiff(repos_dir, config_dir):

    sp.check_call(['sudo', 'apt', 'install', '-y', 'asciidoc-base'])
    update_repo('https://gitlab.com/git-latexdiff/git-latexdiff', repos_dir)
    d = op.join(repos_dir, 'git-latexdiff')
    patch = \
        op.join(config_dir, 'patches', '0001-adjust-install-location.patch')
    apply_patch(patch, 'adjust install loc', d)
    sp.check_call(['sudo', 'make', 'install'], cwd=d)


def install_fzf(repos_dir):
    update_repo('https://github.com/junegunn/fzf', repos_dir)
    sp.check_call(['./install', '--all'], cwd=op.join(repos_dir, 'fzf'))


def install_emacs(config_dir, repos_dir):
    emacs_dir = op.join(repos_dir, 'emacs')
    os.makedirs(emacs_dir, exist_ok=True)
    os.makedirs(op.join(HOME, 'emacs.d'), exist_ok=True)
    sp.check_call(['sudo', 'apt', 'install', '-y', 'emacs'])
    update_repo('https://github.com/emacs-evil/evil', emacs_dir)
    update_repo('https://github.com/GuiltyDolphin/org-evil.git', emacs_dir)
    update_repo('https://github.com/magnars/dash.el', emacs_dir)
    update_repo('https://github.com/GuiltyDolphin/monitor', emacs_dir)
    try:
        os.symlink(op.join(config_dir, 'init.el'),
                   op.join(HOME, 'emacs.d', 'init.el'))
    except FileExistsError:
        pass


def install_ahoy():
    ahoy_bin = op.join(HOME, 'bin', 'ahoy')
    sp.check_call([
        'wget', '-q',
        'https://github.com/ahoy-cli/ahoy/releases/download/2.0.0/ahoy-bin-linux-amd64',
        '-O', ahoy_bin])
    sp.check_call(['chmod', '+x', ahoy_bin])


def install_textidote(config_dir, repos_dir):
    pkgs = ["openjdk-8-jdk", "openjdk-8-jre-headless", "ant"]
    sp.check_call(['sudo', 'apt', 'install', '-y'] + pkgs)

    update_repo("https://github.com/sylvainhalle/textidote", repos_dir)

    patch_file = op.join(
        config_dir, 'patches',
        '0001-adjust-output-so-it-is-easier-to-parse-with-neomake.patch')

    textidote_dir = op.join(repos_dir, "textidote")
    apply_patch(patch_file, "[PATCH] adjust output so it is easier to parse",
                textidote_dir)

    sp.check_call(['ant', 'download-deps'], cwd=textidote_dir)
    sp.check_call(['ant'], cwd=textidote_dir)
    shutil.copy2(op.join(textidote_dir, 'textidote.jar'),
                 op.join(op.expanduser('~'), 'bin', 'textidote.jar'))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('config_dir')
    parser.add_argument('repos_dir')
    args = parser.parse_args()

    args.config_dir = op.abspath(args.config_dir)
    args.repos_dir = op.abspath(args.repos_dir)

    os.makedirs(op.join(HOME, 'repos'), exist_ok=True)

    run_apt()
    install_latexdiff(args.repos_dir, args.config_dir)
    # install_ahoy()
    install_fzf(args.repos_dir)
    # install_emacs(args.config_dir, args.repos_dir)
    install_git_bash_completion()
    install_pip_packages()
    install_scripts()
    setup_vimrc(args.config_dir)
    setup_inputrc()
    install_cbatticon(args.repos_dir)
    install_neovim(args.repos_dir)
    install_vim_plugins(args.config_dir, args.repos_dir)
    install_cppcheck(args.config_dir, args.repos_dir)
    install_cppclean(args.repos_dir)
    install_cmd_monitor(args.repos_dir)
    setup_ipython()
    install_awesome(args.config_dir)
    install_textidote(args.config_dir, args.repos_dir)


if __name__ == '__main__':
    main()
