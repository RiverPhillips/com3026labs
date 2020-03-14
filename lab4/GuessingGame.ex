defmodule GuessingGame do
    def mid(low, high), do: div(low+high, 2)

    def guess(state) do
        receive do
            msg = {:init, client, low, high} ->
                IO.puts "Got #{inspect(msg)}"
                currentGuess = mid(low, high)
                state =  Map.put(state, client, {low, high, currentGuess})
                send(client, {:guess, currentGuess})
                guess(state)
            msg = {:lt, client} ->
                IO.puts "Got #{inspect(msg)}"

                {low, _, prevGuess} = state[client]

                IO.puts "Prev Guess: #{prevGuess}"

                currentGuess = mid(prevGuess, low)
                send(client, {:guess, currentGuess})

                state =  %{state | client => {low, prevGuess, currentGuess}}

                guess(state)
            msg = {:gt, client} ->
                IO.puts "Got #{inspect(msg)}"

                {_, high, prevGuess} = state[client]

                currentGuess = mid(high, prevGuess)

                send(client, {:guess, currentGuess})

                state =  %{state | client => {prevGuess, high, currentGuess}}
                guess(state)
            _ = {:exit, client} ->
                Map.delete(state, client)
                IO.puts "Bye!"
        end 
    end

    def start_game(server, low, high) do
        send(server, {:init, self(), low, high})

        play(server)
    end

    def play(server) do
        receive do 
            msg = {:guess, cand} ->
                IO.puts "Got #{inspect(msg)} from server"

                IO.puts "I think your number is #{cand}"
                guessString = String.trim(IO.gets("please provide a hint, lt for less than gt for greater than and eq if equals\n"), "\n")
                guessAtom = String.to_atom(guessString)

                case guessAtom do
                    :gt ->
                        send(server, {:gt,self()})
                        play(server)
                    :lt ->
                        send(server, {:lt, self()})
                        play(server)
                    :eq ->
                        send(server, {:exit, self()})
                    _ ->
                        IO. puts "error, invalid argument"
                end
        end
    end
end