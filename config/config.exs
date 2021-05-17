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

config :direct_home_api, DirectHomeApiWeb.Auth.Guardian,
  issuer: "direct_home_api",
  secret_key: "iBQhSf/0w2xA+wylJuIuddBymzkDHc1XBAcrykcz8dI7ACM4nx0v/k/f1Cn+5I4I"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: "us-east-2",
  json_codec: Jason

config :cors_plug,
  origin: ["http://localhost:3000"],
  max_age: 86400,
  methods: ["GET", "POST", "UPDATE", "DELETE"],
  expose: ["authorization"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
