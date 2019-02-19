#!/usr/bin/env python
import argparse
import subprocess
import lvdb


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-x')
    parser.add_argument('--args', nargs='+')
    args = parser.parse_args()

    cmd = 'gdb -x ' + args.x + ' -f --args ' + ' '.join(args.args)
    subprocess.check_call(['terminator', '-x', 'nvim', '-c' 'term ' + cmd,
                           '-c', 'file ros_gdb',
                           '-c', 'normal A'])


if __name__ == '__main__':
    main()
