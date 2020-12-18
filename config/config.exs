# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cluster_manager,
  ecto_repos: [ClusterManager.Repo]

# Configures the endpoint
config :cluster_manager, ClusterManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WZ0l5SK5thMwYyrtWHc2YnDIAN0XHpVc4oBN1OdusTX+fWdxh8j0iTQ9s87UIF0F",
  render_errors: [view: ClusterManagerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ClusterManager.PubSub,
  live_view: [signing_salt: "KReJ++Oa"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
