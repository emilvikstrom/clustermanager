defmodule ClusterManagerWeb.RegisterController do
  use ClusterManagerWeb, :controller

  alias ClusterManager.ClusterServer.ClusterNode
  alias ClusterManager.ClusterServer

  def get_register(conn, params) do
    IO.inspect(params)

    active_nodes = ClusterServer.get_all()

    conn
    |> put_status(200)
    |> json(active_nodes)
  end

  def get_service(conn, %{"service" => service}) do
    nodes = ClusterServer.get_service(service)

    conn
    |> put_status(200)
    |> json(nodes)
  end

  def register_node(conn, %{"node" => node, "service" => service}) do
    case ClusterServer.add_node(ClusterNode.new(service, node)) do
      :ok ->
        conn
        |> put_status(200)
        |> text("OK")

      {:error, _} ->
        conn
        |> put_status(400)
        |> text("Can't reach node")
    end
  end

  def register_node(conn, _params) do
    conn
    |> put_status(400)
    |> text("Missing param")
  end
end
