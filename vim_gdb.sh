#!/usr/bin/bash
rm -f .debug_gdb_objs gdb.txt
python -c "import vim_pdb; vim_pdb.monitor_gdb_file()" &
gdb -x .gdbinit $1
kill $(pgrep -f "import vim_pdb")
