defmodule TestHarness do

    # TODO: limit the number of attempts
    def wait_to_register(name, :undefined) do
        Process.sleep(10)
        wait_to_register(name, :global.whereis_name(name))
    end
    def wait_to_register(_, pid), do: pid

    def deploy_procs(func) do
        for {name, {node, neighbours}} <- Config.get_proc_info do
            case node do
                :local -> Node.spawn(Node.self, fn -> func.(name, neighbours) end)
                _ -> Node.spawn(node, fn -> func.(name, neighbours) end)
            end
        end
    end

    def proc_names(), do: for {name, _} <- Config.get_proc_info, do: name
    def nodes(), do: for {_, {node, _}} <- Config.get_proc_info, do: node

    def notify_all(procs, msg) do
        for p <- procs, do: send(p, msg)
    end

    defp sync(msg, n) do 
        for _ <- 1..n do
            receive do
                ^msg -> :ok
            end
        end
    end

    # ideally should take an instance of a protocol for tested module
    def test(func) do
        :global.re_register_name(:coord, self)
        # pids = deploy_procs(&FloodingTest.run/2)
        pids = deploy_procs(func)
        sync(:ready, Config.getN)
        notify_all(pids, :start)
        sync(:done, Config.getN)
    end
end