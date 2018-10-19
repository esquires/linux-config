import os
import subprocess as sp
import multiprocessing as mp
import argparse
import lvdb

THIS_FILE_PATH = os.path.dirname(os.path.realpath(__file__))

def llvm_repo(suffix):
    return 'https://git.llvm.org/git/' + suffix


def patch(patch_file):
    lvdb.set_trace()
    sp.call(['git', 'stash'])
    sp.check_call(['git', 'reset', '--hard', 'origin/master'])
    sp.check_call(['git', 'am', '-3', patch_file])


def clone(repo):
    sp.call(['git', 'clone', repo])
    orig_dir = os.getcwd()
    dir_name = os.path.splitext(os.path.basename(repo))[0]
    os.chdir(dir_name)
    sp.call(['git', 'pull'])
    os.chdir(orig_dir)


def mkdir(pth):
    try:
        os.makedirs(pth)
    except OSError:
        pass


def make_llvm(repos_pth, install_pth):
    sp.check_call(
        ['sudo', 'apt-get', '-y', 'install',
         'libncurses5-dev', 'swig3.0', 'libedit-dev'])

    build_pth = os.path.join(repos_pth, 'llvm', 'build')
    mkdir(build_pth)

    os.chdir(repos_pth)
    clone(llvm_repo('llvm'))

    os.chdir(os.path.join('llvm', 'tools'))
    clone(llvm_repo('clang'))
    clone(llvm_repo('lld'))
    clone(llvm_repo('polly'))

    clone(llvm_repo('lldb'))
    os.chdir('lldb')
    patch(os.path.join(THIS_FILE_PATH, 'patches',
                       '0001-use-vim-rather-than-emacs-in-editline.patch'))
    os.chdir('..')

    os.chdir(os.path.join('clang', 'tools'))
    clone(llvm_repo('clang-tools-extra'))

    os.chdir(os.path.join(repos_pth, 'llvm', 'projects'))
    clone(llvm_repo('compiler-rt'))
    clone(llvm_repo('openmp'))
    clone(llvm_repo('libcxx'))
    clone(llvm_repo('libcxxabi'))

    os.chdir(build_pth)
    sp.check_call(['cmake', '..', '-DLLVM_CCACHE_BUILD=ON',
                   '-G', 'Ninja',
                   '-DCMAKE_BUILD_TYPE=Release',
                   '-DCMAKE_INSTALL_PREFIX=' + install_pth])
    sp.check_call(['ninja'])
    sp.check_call(['ninja', 'install'])


def make_include_what_you_use(repos_pth, install_pth):
    os.chdir(repos_pth)
    clone('https://github.com/include-what-you-use/include-what-you-use.git')

    build_pth = os.path.join(repos_pth, 'include-what-you-use', 'build')
    mkdir(build_pth)
    os.chdir(build_pth)
    sp.check_call(['cmake', '..',
                   '-G', 'Ninja',
                   '-DCMAKE_BUILD_TYPE=Release',
                   '-DCMAKE_INSTALL_PREFIX=' + install_pth])
    sp.check_call(['ninja'])
    sp.check_call(['ninja', 'install'])


def make_code_checker(repos_pth):
    os.chdir(repos_pth)
    clone('https://github.com/Ericsson/CodeChecker.git')

    sp.check_call(
        ['sudo', 'apt-get', '-y', 'install',
         'build-essential', 'curl', 'doxygen', 'gcc-multilib',
         'git', 'python-virtualenv', 'python-dev', 'thrift-compiler'])

    src_pth = os.path.join(repos_pth, 'CodeChecker')
    os.chdir(src_pth)
    sp.check_call(['make', 'venv'])
    sp.check_call(['make', 'package'])
    sp.call(
        ['ln', '-v', '-s', os.path.join(THIS_FILE_PATH, 'run_clang.py'),
         os.path.join(os.path.expanduser('~'), 'bin', 'clang')])


def main():

    home = os.path.expanduser('~')
    repos_pth = os.path.join(home, 'repos')
    install_pth = os.path.join(home, 'llvm-install')

    mkdir(repos_pth)
    mkdir(install_pth)

    make_llvm(repos_pth, install_pth)
    make_include_what_you_use(repos_pth, install_pth)


if __name__ == '__main__':
    main()
