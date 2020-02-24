# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :better_together, BetterTogetherWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BrsNLUSQsJyd3/u6iko2e3oMb4+JdtX2ZkaHSZiQHFG6C7q41kVKprEmdRVhcyi9",
  render_errors: [view: BetterTogetherWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BetterTogether.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Y+/n/7p+"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :phoenix, template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
