"""Run a command and give auditory feedback."""
import argparse
import subprocess
import time
from espeak import espeak


def main():
    """Pass command line argument to subprocess."""
    parser = argparse.ArgumentParser()
    parser.add_argument("cmd", nargs='+')
    args = parser.parse_args()

    try:
        words = [args.cmd[0]]
    except TypeError:
        words = []

    try:
        subprocess.check_call(args.cmd)
        words += ["successful."]
    except subprocess.CalledProcessError:
        words += ["failed."]

    espeak.synth(" ".join(words))

    # without this the words get cutoff
    time.sleep(2)


if __name__ == '__main__':
    main()
