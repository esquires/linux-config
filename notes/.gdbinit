define skipstdcxxheaders
python
def skipAllIn(root):
    import os
    for root, dirs, files in os.walk(root, topdown=False):
        for name in files:
            path = os.path.join(root, name)
            gdb.execute('skip file %s' % path, to_string=True)
# do this for C++ only
if 'c++' in gdb.execute('show language', to_string=True):
    skipAllIn('/usr/include/c++')
end
end

define hookpost-run
    skipstdcxxheaders
end
define hookpost-start
    skipstdcxxheaders
end
define hookpost-attach
    skipstdcxxheaders
end

define hook-quit
    set confirm off
end

set logging file /tmp/lvdb.txt
set logging on
set breakpoint pending on
