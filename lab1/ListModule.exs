defmodule ListModule do
    def sum_square([]), do: 0
    def sum_square([head | tail]) do
        head * head + sum_square(tail)
    end

    def len([]), do: 0
    def len([_|tail]) do
        1 + len(tail)
    end

    def reverse([]), do: []
    def reverse([head|tail]) do
        [reverse(tail)] ++ [head]
    end
end

list = [1,2,3,4,5]

IO.puts ListModule.sum_square(list)
IO.puts ListModule.len(list)

IO.inspect list
IO.inspect ListModule.reverse(list)