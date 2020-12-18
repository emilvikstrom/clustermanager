defmodule ClusterManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ClusterManager.Repo,
      # Start the Telemetry supervisor
      ClusterManagerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ClusterManager.PubSub},
      # Start the Endpoint (http/https)
      ClusterManagerWeb.Endpoint,
      # Start a worker by calling: ClusterManager.Worker.start_link(arg)
      # {ClusterManager.Worker, arg}
      ClusterManager.ClusterServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ClusterManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ClusterManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
