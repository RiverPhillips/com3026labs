#!/bin/bash 

killall -9 beam.smp 2>/dev/null

/bin/rm -f *.beam

iex --name alice@127.0.0.1 --erl -noshell test_script.exs 2>1 >/dev/null &
iex --name bob@127.0.0.1 --erl -noshell test_script.exs 2>1 >/dev/null &
iex --name charlie@127.0.0.1 --erl -noshell test_script.exs 2>1 >/dev/null &
iex --name coord@127.0.0.1 
