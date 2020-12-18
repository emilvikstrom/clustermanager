defmodule ClusterManager.ClusterServer.ClusterNode do
  @derive {Jason.Encoder, only: [:service, :node_name]}
  defstruct [:service, :node_name]

  def new(service, node_name) do
    node_as_atom = String.to_atom(node_name)

    %__MODULE__{
      service: service,
      node_name: node_as_atom
    }
  end
end
