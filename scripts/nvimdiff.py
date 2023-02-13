#!/usr/bin/env python3
import subprocess as sp
import argparse
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("dir1")
    parser.add_argument("dir2")
    args = parser.parse_args()

    d1 = Path(args.dir1).resolve()
    d2 = Path(args.dir2).resolve()

    # for some reason diff returns an error every time so call
    # run without check rather than check_output
    lines = sp.run(
        ['diff', '-rq', d1, d2],
        stdout=sp.PIPE).stdout.decode('UTF-8').split('\n')

    for line in lines:
        words = line.split(' ')
        run_diff = False
        if words[0] == 'Files':
            run_diff = True
            f1 = words[1]
            f2 = words[3]
        elif words[0] == "Only":
            run_diff = True
            d = words[2].split(':')[0]
            if str(d).startswith(str(d1)):
                f1 = Path(d) / words[3]
                f2 = '/dev/null'
            elif str(d).startswith(str(d2)):
                f1 = '/dev/null'
                f2 = Path(d) / words[3]

        if run_diff:
            sp.run(['nvim', '-d', f1, f2])


if __name__ == '__main__':
    main()
