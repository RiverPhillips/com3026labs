defmodule FloodingTest do
    # The functions implement 
    # the module specific testing logic
    defp init(name, neighbours) do
        cpid = TestHarness.wait_to_register(:coord, :global.whereis_name(:coord))
        pid = FloodingBC.start(name, neighbours, self)
        for name <- TestHarness.proc_names, do: 
            TestHarness.wait_to_register(name, :global.whereis_name(name))
        {cpid, pid}
    end

    def run(name, neighbours) do
        {cpid, pid} = init(name, neighbours)
        send(cpid, :ready)
        receive do
            :start -> 
                IO.puts("#{inspect name} started")
                FloodingBC.bc_send(pid, "Hello from #{name}")
                for _ <- 1..Config.getN do 
                    receive do
                        msg -> IO.puts("#{name} received #{inspect msg}")
                    end
                end
        end
        send(cpid, :done)
    end
end