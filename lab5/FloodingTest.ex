defmodule FloodingTest do

    defp sync(msg, n) do 
        for _ <- 1..n do
            receive do
                ^msg -> :ok
            end
        end
    end

    def test() do
        procs = [
            spawn(FloodingTest, :run, [:p1, [:p2], :"coord@127.0.0.1"]),
            spawn(FloodingTest, :run, [:p2, [:p1, :p3], :"coord@127.0.0.1"]),
            spawn(FloodingTest, :run, [:p3, [:p2], :"coord@127.0.0.1"])
        ]
        sync(:ready, 3)
        for p <- procs, do: send(p, :start)
        sync(:done, 3)
    end

    def run(name, neighbours, p) do
        FloodingBEB.start(name, neighbours, :"coord@127.0.0.1")
        send(p, :ready)
        receive do 
            :start -> 
                IO.puts("#{inspect name} started")
                FloodingBEB.bc_send(name, "Hello from #{name}")
                for _ <- 1..3 do 
                    receive do
                        msg -> IO.puts("#{name} received #{inspect msg}")
                    end
                end
        end
        send(p, :done)
    end
end