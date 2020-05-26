docker run -it --rm -h elixir.local  -v "$PWD":/usr/src/myapp -w /usr/src/myapp elixir:1.3.3 iex --sname coord test_script.exs

rm -rf *.beam