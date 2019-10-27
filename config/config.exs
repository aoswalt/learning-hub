# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hub,
  ecto_repos: [Hub.Repo]

# Configures the endpoint
config :hub, HubWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mzCVKi5OZOPKnm5IdBNx1G/5D7ru4Mvjw5TblGHjJ2Di2ow0jRCSG3PVNU3QUz51",
  render_errors: [view: HubWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hub.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    slack: {Ueberauth.Strategy.Slack, [team: "T6S3KJ34P"]}
  ]

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: System.get_env("SLACK_CLIENT_ID", "230121615159.810199169012"),
  client_secret: System.get_env("SLACK_CLIENT_SECRET", "dea47b71bb54fec5db85e9a9d7835d02")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
