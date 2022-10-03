#! /usr/bin/env python
import re
from pathlib import Path
import subprocess as sp

import argparse


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("root")
    parser.add_argument("fnames", nargs='+')
    parser.add_argument("--inkscape_args")
    args = parser.parse_args()

    inkscape_args = args.inkscape_args.split(' ')

    for fname in args.fnames:
        out_fname = Path(fname).with_suffix('.pdf')

        cmd = ['inkscape'] + inkscape_args + [
            fname, '-o', str(out_fname), '--export-latex']
        print(' '.join(cmd))
        sp.check_call(cmd)

        out_fname_tex = Path(fname).with_suffix('.pdf_tex')
        rel_path = str(
            out_fname.resolve().relative_to(Path(args.root).resolve()))

        with open(out_fname_tex, 'r') as f:
            lines = f.read().splitlines()

        r = re.compile(r'(.*)(' + str(out_fname) + ')(.*)')

        for i, line in enumerate(lines):
            m = r.match(line)
            if m is not None:
                captures = m.groups()
                lines[i] = captures[0] + rel_path + captures[2]

        with open(out_fname_tex, 'w') as f:
            f.write('\n'.join(lines))


if __name__ == '__main__':
    main()
