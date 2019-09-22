# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :passwordless_auth,
  ecto_repos: [PasswordlessAuth.Repo],
  default_url: System.get_env("DEFAULT_URL") || "http://localhost:8081",
  app_ui_url: System.get_env("APP_UI_URL") || "http://localhost:3000"

config :passwordless_auth, PasswordlessAuth.Repo,
  migration_primary_key: [id: :uuid, type: :binary_id]

# Configures the endpoint
config :passwordless_auth, PasswordlessAuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l0JuoBfM2VeuL3bORrQnzIOI2hjkSWpGdtFcG8PR3O9bNHwhjvbmi6FwlZLkbOsy",
  render_errors: [view: PasswordlessAuthWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PasswordlessAuth.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
