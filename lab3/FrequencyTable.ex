defmodule FrequencyTable do
     def update_freq(key, map) do
        case Map.fetch(map, key) do
            {:ok, fetchResult} -> Map.put(map, key, fetchResult + 1)
            :error -> Map.put(map, key, 1)
        end
    end

    def freq_count_tail_rec(list), do: freq_count_tail_rec(list, %{})
    def freq_count_tail_rec([head|tail], acc), do: freq_count_tail_rec(tail, update_freq(head, acc))
    def freq_count_tail_rec([], acc), do: acc

    def freq_count_r(list), do: Enum.reduce(list, %{},fn x, acc -> update_freq(x, acc) end)

    def word_count(text), do: String.downcase(text)
        |> String.replace(~r/[.,\/#!$%\^&\*;:{}=\-_`~()]/, "")
        |> String.split(" ")
        |> freq_count_r

    def swap_map(map), do: Enum.map(map, fn {k, v} -> {v, k} end)

    def to_histogram(map) do 
        total = Enum.reduce(map, 0, fn {_, v}, acc -> acc + v end)
        Enum.map(map, fn{k,v} -> {k, (div(v*100,total))} end)
        |> swap_map 
    end

    def word_histogram(text), do: word_count(text)
        |> to_histogram
end