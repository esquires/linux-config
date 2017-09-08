#!/usr/bin/env python
"""Wrap static analysis tools."""
from __future__ import print_function
import os.path
import subprocess as sp
import re
import sys


def _get_cmakecache_files(directory):
    return sp.check_output(
        ["find", directory, "-maxdepth", "4",
         "-name", "CMakeCache.txt"]).split('\n')[:-1]


def _get_include_dirs(file_path):
    pwd = file_path if os.path.isdir(file_path) else os.path.dirname(file_path)
    pwd = os.path.abspath(pwd)

    cmakecache_files = _get_cmakecache_files(pwd)
    while (not cmakecache_files and
           not os.path.exists(os.path.join(pwd, 'include')) and
           pwd != '/'):
        pwd = os.path.dirname(pwd)
        cmakecache_files = _get_cmakecache_files(pwd)

    r = re.compile(r'INCLUDE_DIR[S]?:PATH=(.*)')
    include_dirs = \
        set(sp.check_output(
            ["find", pwd, "-maxdepth", "4", "-type", "d",
             "-name", "include"]).split('\n')[:-1])

    if cmakecache_files:
        for fname in cmakecache_files:
            with open(fname, 'r') as f:
                lines = f.read().splitlines()

            for line in lines:
                match = r.search(line)
                if match:
                    include_dirs.add(match.groups(1)[0])

    return include_dirs


def _add_arg_w_prefix(prefix, arg_list):
    prefixes = [prefix] * len(arg_list)
    return [val for pair in zip(prefixes, arg_list) for val in pair]


def main():
    """Wrap static analysis tools."""
    if "-h" in sys.argv or "--help" in sys.argv:
        # normally use argparse but this is more compatible with neomake
        print("usage: cpp_static_wrapper.py [-h] executable "
              "[extra_args] file_path")
        return

    file_path = sys.argv[-1]
    executable = sys.argv[1]
    extra_args = sys.argv[2:-1]

    include_dirs = _get_include_dirs(file_path)

    if executable == "cppclean":
        include_dirs.add('/usr/local/include')
        include_dirs.add('/usr/include')
        include_arg = _add_arg_w_prefix('-n', include_dirs)

        excludes = ['build', 'build_dependencies', 'build_resources']
        exclude_arg = _add_arg_w_prefix('--exclude', excludes)

        cmd = ['cppclean'] + extra_args + exclude_arg + \
            include_arg + [file_path]

    elif executable == "cppcheck":

        def _is_excluded_dir(d):
            to_exclude = ['usr', 'googletest', 'build', '.local']
            return not any(True for e in to_exclude if e in d)

        include_dirs = filter(_is_excluded_dir, include_dirs)
        include_arg = _add_arg_w_prefix('-I', include_dirs)

        if os.path.isdir(file_path):
            dirs = ['src', 'include', 'share', 'tools', 'plugins']
            to_check = [os.path.join(file_path, d) for d in dirs]
        else:
            to_check = [file_path]

        enable_arg = ("--enable=warning,style,information,"
                      "performance,portability,missingInclude")
        cmd = ['cppcheck', '--quiet', '--language=c++', enable_arg] \
            + extra_args + include_arg + to_check

    print(" ".join(cmd))
    sp.call(cmd)


if __name__ == '__main__':
    main()
