c("paxos.exs")

pid1 = Paxos.start(:p1, [:p1, :p2, :p3], self)
pid2 = Paxos.start(:p2, [:p1, :p2, :p3], self)
pid3 = Paxos.start(:p3, [:p1, :p2, :p3], self)

for {p, v} <- [{pid1, :a}, {pid2, :b}, {pid3, :c}], do: Paxos.propose(p, v)
Paxos.start_ballot(pid1)
