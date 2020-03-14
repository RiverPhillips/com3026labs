defmodule GuessingGame do
    def mid(low, high), do: div(low+high, 2)
    def ask3(cand, low, high, guessCount) do
        IO.puts "I think your number is #{cand}"
        guessString = String.trim(IO.gets("please provide a hint, lt for less than gt for greater than and eq if equals\n"), "\n")
        guessAtom = String.to_atom(guessString)
        guess(guessAtom, cand, low, high, guessCount)
    end

    def guess(:lt, cand, low, _, guessCount) do
        ask3(mid(low, cand), low, cand, guessCount+1)
    end


    def guess(:gt, cand, _, high, guessCount)do
        ask3(mid(cand, high), cand, high, guessCount+1)
    end

    def guess(:eq, cand, _, _, guessCount), do: IO.puts "Your number is #{cand} and you took #{guessCount} guesses."

    def guess(_, cand, low, high, guessCount) do
        IO.puts "Invalid hint"
        ask3(cand, low, high, guessCount)
    end

    def play(low, high) when (low > 0 and high > low) do
        ask3(mid(low, high), low, high, 0)
    end

    def play(_, _) do
        IO.puts "I cannot guess within those bounds"
    end

end