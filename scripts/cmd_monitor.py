#!/usr/bin/env python3
"""Run a command and give auditory feedback."""
import argparse
import subprocess as sp
import sys


SOUND_DIR = '/usr/share/sounds/ubuntu/stereo/'
DEFAULT_SUCCESS_SOUND = SOUND_DIR + 'button-toggle-on.ogg'
DEFAULT_FAIL_SOUND = SOUND_DIR + 'button-pressed.ogg'


def _makefile_callback(cmd, stdout):
    is_make_cmd = cmd.strip(' ').split(' ')[0] == 'make'
    built_something = any(
        (line for line in stdout if 'Building' in line or 'Linking' in line))
    return is_make_cmd and not built_something


def _ninja_callback(cmd, stdout):
    is_ninja_cmd = cmd.strip(' ').split(' ')[0] == 'ninja'
    built_something = stdout[-1].strip('\n') != "ninja: no work to do."
    return is_ninja_cmd and not built_something


def cmd_monitor(command, command_dir,
                callbacks=tuple(),
                success_sound=DEFAULT_SUCCESS_SOUND,
                fail_sound=DEFAULT_FAIL_SOUND,
                notify_time_secs=1):
    """Call a command and send results to desktop notification with sound."""
    print('calling "{}"'.format(command))

    process = sp.Popen(command.split(' '), stdout=sp.PIPE, stderr=sp.STDOUT,
                       cwd=command_dir, universal_newlines=True)
    stdout = []
    for line in process.stdout:
        sys.stdout.write(line)
        stdout.append(line)
    process.wait()

    if any((cb(command, stdout) for cb in callbacks)):
        print('not notifying due to callback returning true')
        sys.exit(process.returncode)
        return

    if process.returncode == 0:
        result = "succeeded"
        urgency = 'normal'
        sound = success_sound
    else:
        result = "failed"
        urgency = 'critical'
        sound = fail_sound

    title = 'cmd_monitor'
    sp.Popen(
        ['notify-send',
         '-t', str(notify_time_secs * 1000),
         '-u', urgency,
         title,
         '"{}" {}'.format(command, result)])
    sp.Popen(['paplay', sound])
    sys.exit(process.returncode)


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
    parser.add_argument("command", help="the command to run")

    parser.add_argument(
        "--success_sound", default=DEFAULT_SUCCESS_SOUND,
        help='sound to play when a command is successful')
    parser.add_argument(
        "--fail_sound", default=DEFAULT_FAIL_SOUND,
        help='sound to play when a command is successful')
    parser.add_argument(
        "--notify_time_secs", default=1,
        help="how long for desktop notification to last (seconds)")
    args = parser.parse_args()

    if args.ignore_make_output:
        callbacks = [_makefile_callback, _ninja_callback]
    else:
        callbacks = []

    cmd_monitor(args.command, args.command_dir,
                callbacks, args.success_sound, args.fail_sound,
                args.notify_time_secs)


if __name__ == '__main__':
    main()
