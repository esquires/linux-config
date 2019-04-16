#!/usr/bin/env python
import argparse
import subprocess


def main():
    """Run gdb in terminator as a dropin replacement for launch-prefix.

    example
    -------
    <node pkg="my_package"
        type="my_node"
        name="foobar"
        args="my_args"
        launch-prefix="ros_gdb.py -x /path/to/gdbinit --args"
        output="screen">

    for details, see here:
    https://wiki.ros.org/roslaunch/Tutorials/Roslaunch%20Nodes%20in%20Valgrind%20or%20GDB
    """
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
