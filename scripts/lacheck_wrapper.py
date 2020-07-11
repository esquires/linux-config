#!/usr/bin/env python
import argparse

import subprocess as sp


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('fname')
    args = parser.parse_args()

    lines = \
        sp.check_output(['lacheck', args.fname]).decode('utf-8').splitlines()

    i = 0
    while i < len(lines):
        if r'missing `\@' in lines[i] or \
                '.pgf' in lines[i] or \
                '.pdf_tex' in lines[i]:
            del lines[i]
        else:
            i += 1
    if lines:
        print('\n'.join(lines))


if __name__ == '__main__':
    main()
