killall -9 beam.smp 2>/dev/null
/bin/rm -f *.beam
iex --sname coord test_script_local.exs
