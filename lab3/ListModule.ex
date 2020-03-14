defmodule ListModule do
    def sum(acc, []), do: acc
    def sum(acc, [head | tail]), do: sum(acc+head, tail)
    def sum(list), do: sum(0, list)

    def len(acc, []), do: acc
    def len(acc, [_|tail]), do: len(acc+1, tail)
    def len(list), do: len(0, list)

    def reverse([], reversed), do: reversed
    def reverse([h | t], reversed), do: reverse(t, [h] ++ reversed)
    def reverse(list), do: reverse(list, [])


    def span(from, to, [_| tail], span) when from > 0, do: span(from-1, to, tail, span)
    def span(from, to, [head | tail], span) when from == 0 and to > 0, do: span(from, to-1, tail, [span | head])
    def span(from, to, _, span) when from == 0 and to == 0, do: span
    def span(_,_,_,_), do: :error
    def span(from, to, _) when from >= to, do: []
    def span(from, to, list), do: span(from, to, list, [])

    def flatten([]), do: []
    def flatten([head|tail]), do: flatten(head) ++ flatten(tail)
    def flatten(head), do: [head]

    def flattenTailRec(list), do: flattenTailRec(list, [])
    def flattenTailRec([], acc), do: acc
    def flattenTailRec([head|tail], acc), do: flattenTailRec(tail, acc++flattenTailRec(head))
    def flattenTailRec(head, acc), do: acc ++ [head]

end