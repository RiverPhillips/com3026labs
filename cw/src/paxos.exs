defmodule Paxos do
  def start(name, nodes, upper_layer) do
    pid = spawn(Paxos, :init, [nodes, upper_layer, name])
    :global.unregister_name(name)

    case :global.register_name(name, pid) do
      :yes -> pid
      :no -> :error
    end

    pid
  end

  def init(nodes, upper_layer, name) do
    state = %{
      name: name,
      maxBallotNumber: 1,
      maxBallotNumberVote: nil,
      prepareResults: [],
      nodes: nodes,
      upper_layer: upper_layer
    }

    run(state)
  end

  def propose(name, value) do
    send(:global.whereis_name(name), value)
  end

  def start_ballot(name) do
    send(:global.whereis_name(name), {:start_ballot})
  end

  defp generate_ballot_number(maxBallotNumber, nodes) do
    maxBallotNumber + (length(nodes) + 1)
  end

  defp beb(recipients, msg) do
    for r <- recipients do
      send(:global.whereis_name(r), msg)
    end
  end

  defp run(state) do
    state =
      receive do
        {:start_ballot} ->
          ballotNumber = generate_ballot_number(state.maxBallotNumber, state.nodes)
          beb(state.nodes, {:prepare, {ballotNumber, state.name}})
          state = %{state | maxBallotNumber: ballotNumber}
          state

        {:prepare, {b, senderName}} ->
          if state.maxBallotNumber > b do
            send(
              :global.whereis_name(senderName),
              {:prepared, b, {state.maxBallotNumber, state.maxBallotNumberVote}}
            )
          else
            send(:global.whereis_name(senderName), {:prepared, b, {:none}})
          end

          state

        {:prepared, b, x} ->
          state = %{state | prepareResults: [x | state.prepareResults]}

          if length(state.prepareResults) == length(state.nodes) do
            IO.puts("all prepare results received")

            # Move onto next step all prepare results received
          end

          state

        _ ->
          state
      end

    run(state)
  end
end
