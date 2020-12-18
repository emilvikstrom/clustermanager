defmodule ClusterManager.ClusterServer do
  use GenServer

  alias ClusterManager.ClusterServer.ClusterNode

  defstruct nodes: []

  # Public API

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)
  def stop(), do: GenServer.stop(__MODULE__)

  def get_all(), do: GenServer.call(__MODULE__, :get_all)

  def get_service(service_name), do: GenServer.call(__MODULE__, {:get, service_name})

  def add_node(%ClusterNode{} = node), do: GenServer.call(__MODULE__, {:add, node})
  def add_node(_node), do: {:error, :invalid_node}

  # GenServer callbacks

  def init([]) do
    {
      :ok,
      %__MODULE__{
        nodes: [
          %ClusterNode{service: "base", node_name: node()}
        ]
      }
    }
  end

  def handle_call(:get_all, _from, %__MODULE__{nodes: nodes} = state) do
    {:reply, nodes, state}
  end

  def handle_call({:get, service_name}, _from, %__MODULE__{nodes: nodes} = state) do
    {
      :reply,
      Enum.filter(
        nodes,
        fn %ClusterNode{service: service} ->
          service_name == service
        end
      ),
      state
    }
  end

  def handle_call(
        {
          :add,
          %ClusterNode{
            node_name: node_name
          } = node
        },
        _from,
        %__MODULE__{
          nodes: nodes
        } = state
      ) do
    if Node.connect(node_name) do
      Node.monitor(node_name, true)

      {
        :reply,
        :ok,
        %__MODULE__{
          nodes: Enum.uniq([node | nodes])
        }
      }
    else
      {:reply, {:error, :nodeconnect}, state}
    end
  end

  def handle_info(
        {:nodedown, node_name},
        %__MODULE__{
          nodes: nodes
        } = state
      ) do
    {:noreply,
     Map.put(
       state,
       :nodes,
       Enum.filter(
         nodes,
         fn
           %ClusterNode{node_name: ^node_name} -> false
           _ -> true
         end
       )
     )}
  end

  def handle_info(msg, state) do
    IO.inspect(msg)
    {:noreply, state}
  end
end
