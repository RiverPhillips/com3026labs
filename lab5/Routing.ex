defmodule Routing do
  
  def start(name, neighbours) do
    spawn(Routing, :init, [name, neighbours])
  end

  def init(name, neighbours) do
    bcast = FloodingBC.start(name, neighbours, self)
    state = %{
      name: name,
      bcast: bcast
    }
    run(state)
  end 

  def send_to(routing, dest, msg) do 
    send(routing, {:input, :send_to, {dest, msg}})
  end

  defp run(state) do
    my_pid = self()
    my_name = state.name
    state = receive do 
      {:input, :send_to, msg} -> 
        FloodingBC.bc_send(state.bcast, msg)
        state

      {:output, :bc_receive, sender, {dest, msg}} when dest == my_name -> 
        send(my_pid, {:output, :receive, sender, msg})
        state

      {:output, :receive, sender, msg} ->
        IO.puts("#{my_name}: received message #{inspect msg} from #{sender}")
        state

      _ -> state  # Important: we do not want non-consumed messages to stuck
                  # in the process mailbox forever
    end
    run(state)
  end
          
end