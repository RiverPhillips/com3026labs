IEx.Helpers.c("paxos.ex")

pid1 = Paxos.start(:p1, [:p1, :p2, :p3], self())
pid2 = Paxos.start(:p2, [:p1, :p2, :p3], self())
pid3 = Paxos.start(:p3, [:p1, :p2, :p3], self())

for {p, v} <- [{pid1, :a}, {pid2, :b}, {pid3, :c}], do: Paxos.propose(p, v)

Paxos.start_ballot(pid1)

for _ <- 1..3 do
  receive do
    {:decide, value} ->
      IO.puts(value)
  after
    10000 -> IO.puts("Timeout")
  end
end

Process.exit(pid1, :kill)
Process.exit(pid2, :kill)
Process.exit(pid3, :kill)

Process.exit(self(), :kill)
