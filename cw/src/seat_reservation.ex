defmodule Reservation do
  def start(name, nodes, initialState) do
    pid = spawn(Reservation, :init, [name, nodes, initialState])
    :global.unregister_name(name)

    case :global.register_name(name, pid) do
      :yes -> pid
      :no -> :error
    end

    pid
  end

  def init(name, nodes, initialstate) do
    paxosPid =
      Paxos.start(
        String.to_atom(Atom.to_string(name) <> "-paxos"),
        Enum.map(nodes, fn node_name -> String.to_atom(Atom.to_string(node_name) <> "-paxos") end),
        self()
      )

    state = %{
      name: name,
      seatState: initialstate,
      paxos: paxosPid
    }

    run(state)
  end

  defp run(state) do
    state =
      receive do
        {:status, {seat, sender}} ->
          send(sender, Map.get(state.seatState, seat, nil))
          state

        {:reserve, {seat, sender}} ->
          case Map.has_key?(state.seatState, seat) do
            true ->
              Paxos.propose(state.paxos, seat)
              Paxos.start_ballot(state.paxos)
              state

            false ->
              send(sender, {:not_found, seat})
              state
          end

        {:decide, key} ->
          state = %{state | seatState: Map.put(state.seatState, key, :reserved)}
          state

        msg ->
          IO.puts("Unknown message")
          IO.inspect(msg)
          state
      end

    run(state)
  end

  def get_status(reservation_system, seat) do
    send(reservation_system, {:status, {seat, self()}})
  end

  def reserve_seat(reservation_system, seat) do
    send(reservation_system, {:reserve, {seat, self()}})
  end
end
