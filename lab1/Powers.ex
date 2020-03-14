defmodule Powers do
    def square(n), do: n * n
    def cube(n), do: n * square(n)

    def square_or_cube(n, p) when p == 2 do
        square(n)
    end
    def square_or_cube(n, 3) do
        cube(n)
    end
    def square_or_cube(_, _), do: :error

    def pow(_, p) when p == 0, do: 1
    def pow(n, p) when p < 0, do: 1/pow(n, Kernel.abs(p))
    def pow(n, p) do
        n * pow(n, p-1)
    end
 end