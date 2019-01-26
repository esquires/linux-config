#!/usr/bin/env python
import argparse
import subprocess as sp
import os
import os.path as op


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dirs", nargs="+")
    parser.add_argument("--skip_files", nargs="*")
    parser.add_argument("-j", default="1")

    args = parser.parse_args()

    skipfile_args = sum([["-i", f] for f in args.skip_files], [])
    out_dir = '/tmp/run_clang'
    orig_dir = os.getcwd()
    for d in args.dirs:
        nm = op.basename(d)
        temp_out_dir = op.join(out_dir, nm)
        d = op.join(op.abspath(d), 'build_clang')

        try:
            os.makedirs(d)
        except OSError:
            pass

        os.chdir(d)

        sp.check_call(
            ["CodeChecker", "log", "-b", '"ninja"', "-o", "compilation.json"])
        sp.call(
            ["CodeChecker", "analyze", "compilation.json",
             "-j", args.j, "-o", temp_out_dir])
        os.chdir(orig_dir)

    for d in args.dirs:
        nm = op.basename(d)
        temp_out_dir = op.join(out_dir, nm)
        sp.check_call(["CodeChecker", "parse", temp_out_dir] + skipfile_args)


if __name__ == '__main__':
    main()
