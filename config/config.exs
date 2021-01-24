# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :direct_home_api,
  ecto_repos: [DirectHomeApi.Repo]

config :bcrypt_elixir, log_rounds: 4

# Configures the endpoint
config :direct_home_api, DirectHomeApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+ANOmx5/uXBLxoQAkqfNTeHAsP/q/tKzNVp2f8cG9UsINE0YV1kfzGo+l/uRNWb1",
  render_errors: [view: DirectHomeApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: DirectHomeApi.PubSub,
  live_view: [signing_salt: "9qjyNHXr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
