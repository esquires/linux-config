#!/usr/bin/env python
"""Run a command and give auditory feedback."""
import argparse
import subprocess as sp
import sys


def is_make_cmd(cmd):
    return cmd.strip(' ').split(' ')[0] == 'make'


def has_make_output(stdout):
    return any((line for line in stdout
                if 'Building' in line or 'Linking' in line))


def main():
    """Pass command line argument to subprocess."""
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-i', '--ignore-make-output', action='store_true',
        help='whether to ignore make outputs that do not build anything')
    parser.add_argument(
        '-t', '--timeout', type=float, default=2,
        help='how long in seconds the notification should last')
    parser.add_argument(
        "-C", "--command_dir", default=".",
        help='directory to run command from')
    parser.add_argument("cmd")
    args = parser.parse_args()

    print('calling "{}"'.format(args.cmd))

    sound_dir = '/usr/share/sounds/ubuntu/stereo/'
    # process = sp.Popen(args.cmd.split(' '), cwd=args.command_dir,
    #                    stdout=sp.PIPE, stderr=sp.PIPE)

    process = sp.Popen(
        args.cmd.split(' '), cwd=args.command_dir, stdout=sp.PIPE, bufsize=1)
    stdout = []
    for line in iter(process.stdout.readline, b''):
        line_decoded = line.decode('utf-8').strip('\n')
        print(line_decoded)
        stdout.append(line_decoded)
    process.stdout.close()
    process.wait()

    if (args.ignore_make_output and
            is_make_cmd(args.cmd) and
            not has_make_output(stdout)):
        print(('not notifying because it is a '
               'make command without anything built'))
        sys.exit(process.returncode)
        return

    if process.returncode == 0:
        result = "succeeded"
        urgency = 'normal'
        sound = sound_dir + 'button-toggle-on.ogg'
    else:
        result = "failed"
        urgency = 'critical'
        sound = sound_dir + 'button-pressed.ogg'

    title = 'cmd_monitor'
    sp.Popen(
        ['notify-send',
         '-t', str(args.timeout * 1000),
         '-u', urgency,
         title,
         '"{}" {}'.format(args.cmd, result)])
    sp.Popen(['paplay', sound])
    sys.exit(process.returncode)


if __name__ == '__main__':
    main()
