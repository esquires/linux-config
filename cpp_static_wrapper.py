#!/usr/bin/env python
from __future__ import print_function
import os.path
import subprocess as sp
import re
import sys
import pprint

def main():

    exec_name = sys.argv[1]
    file_path = sys.argv[-1]

    def _get_cmakecache_files(d):
        return sp.check_output(
            ["find", d, "-maxdepth", "4",
             "-name", "CMakeCache.txt"]).split('\n')[:-1]

    pwd = os.path.dirname(file_path)
    cmakecache_files = _get_cmakecache_files(pwd)
    while (not cmakecache_files and
           not os.path.exists('include') and
           pwd != '/'):
        pwd = os.path.dirname(pwd)
        cmakecache_files = _get_cmakecache_files(pwd)

    r = re.compile(r'INCLUDE_DIR[S]?:PATH=(.*)')
    include_dirs = \
        sp.check_output(
            ["find", pwd, "-maxdepth", "4", "-type", "d",
             "-name", "include"]).split('\n')[:-1]

    if cmakecache_files:
        for fname in cmakecache_files:
            with open(fname, 'r') as f:
                lines = f.read().splitlines()

            for line in lines:
                match = r.search(line)
                if match:
                    include_dirs.append(match.groups(1)[0])

    new_include_dirs = []
    for d in include_dirs:
        if 'usr' not in d and 'googletest' not in d:
            new_include_dirs += ["-I", d]

    if exec_name == "cppclean":
        cmd = ['cppclean', '--exclude', 'build'] + \
                new_include_dirs + [pwd] + sys.argv[2:-1]
    elif exec_name == "cppcheck":
        cmd = ['cppcheck']
        src_dirs = \
            [os.path.join(pwd, d) for d in ['src', 'include', 'plugins']]
        cmd += new_include_dirs + src_dirs

    stdout, stderr = \
        sp.Popen(cmd, stdout=sp.PIPE, stderr=sp.PIPE).communicate()
    for line in stdout.split('\n'):
        if file_path in line:
            print(line)
    for line in stderr.split('\n'):
        if file_path in line:
            print(line, file=sys.stderr)


if __name__ == '__main__':
    main()
