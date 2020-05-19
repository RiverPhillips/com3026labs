IEx.Helpers.c("paxos.exs")

:global.unregister_name(:upper)
:global.register_name(:upper, self())

pid1 = Paxos.start(:p1, [:p1, :p2, :p3], :upper)
pid2 = Paxos.start(:p2, [:p1, :p2, :p3], :upper)
pid3 = Paxos.start(:p3, [:p1, :p2, :p3], :upper)

for {p, v} <- [{:p1, :a}, {:p2, :b}, {:p3, :c}], do: Paxos.propose(p, v)

Paxos.start_ballot(:p1)

for _ <- 1..3 do
  receive do
    {:decided, value} ->
      IO.puts(value)
  after
    10000 -> IO.puts("Timeout")
  end
end

Process.exit(pid1, :kill)
Process.exit(pid2, :kill)
Process.exit(pid3, :kill)

Process.exit(self(), :kill)
