defmodule ClusterManager.Repo do
  use Ecto.Repo,
    otp_app: :cluster_manager,
    adapter: Ecto.Adapters.Postgres
end
