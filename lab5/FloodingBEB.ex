defmodule FloodingBEB do
    def start(name, nodes, upper) do
        pid = spawn(FloodingBEB, :init, [name, nodes, upper]) 
        :global.unregister_name(name)
        case :global.register_name(name, pid) do
            :yes -> pid  
            :no  -> :error
        end
    end

    def init(name, nodes, upper) do 
        state = %{ 
            name: name, 
            upper: upper,
            nodes: for n <- nodes do
                :global.whereis_name(n)
            end,
            messages: MapSet.new()  
        }
        run(state)
    end

    def bc_send(nodeName, msg) do
        pid = :global.whereis_name(nodeName)
        send(pid, {:input, msg})
    end

    defp run(state) do
        state = receive do
            {:input, msg} ->
                for n <- state.nodes do
                    send(:global.whereis_name(n), {:system, msg})
                end
                send(:global.whereis_name(state.upper), {:output, msg})
                %{state | messages: MapSet.put(state.messages, msg)}
            {:system, msg} -> 
                send(:global.whereis_name(state.upper), {:output, msg})
                %{state | messages: MapSet.put(state.messages, msg)}
        end
        run(state)
        
    end

end