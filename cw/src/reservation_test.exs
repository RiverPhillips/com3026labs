IEx.Helpers.c("paxos.ex")
IEx.Helpers.c("seat_reservation.ex")

res1 = Reservation.start(:p1, [:p1, :p2, :p3], %{a: :unoccupied, b: :unoccupied, c: :unoccupied})
res2 = Reservation.start(:p2, [:p1, :p2, :p3], %{a: :unoccupied, b: :unoccupied, c: :unoccupied})
res3 = Reservation.start(:p3, [:p1, :p2, :p3], %{a: :unoccupied, b: :unoccupied, c: :unoccupied})

# for {res, seat} <- [{res1, :a}, {res2, :b}, {res3, :c}], do: Reservation.get_status(res, seat)

# for _ <- 1..3 do
#   receive do
#     msg ->
#       IO.inspect(msg)
#   after
#     10000 -> IO.puts("Timeout")
#   end
# enda

:timer.sleep(500)

Reservation.reserve_seat(res1, :c)

:timer.sleep(3000)

for {res, seat} <- [{res1, :a}, {res2, :b}, {res3, :c}], do: Reservation.get_status(res, seat)

for _ <- 1..3 do
  receive do
    msg ->
      IO.inspect(msg)
  after
    10000 -> IO.puts("Timeout")
  end
end

Process.exit(res1, :kill)
Process.exit(res2, :kill)
Process.exit(res3, :kill)

Process.exit(self(), :kill)
