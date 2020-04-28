defmodule Config do
    @proc_info %{
        # process_name -> {node_name, list_of_neighbour_proc_names}
        # use :local for node_name to deploy on Node.self
        # processes must be either all non-distributed or all distributed 
        # in order to talk to each other
        p1: {:"alice@CS-STF-00373", [:p2]},
        p2: {:"bob@CS-STF-00373", [:p1, :p3]},
        p3: {:"charlie@CS-STF-00373", [:p2]}

        # p1: {:local, [:p2]},
        # p2: {:local, [:p1, :p3]},
        # p3: {:local, [:p2]}
    }

    def getN(), do: map_size(@proc_info)
    def get_proc_info(), do: @proc_info
end