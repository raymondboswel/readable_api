# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :readable_api,
  ecto_repos: [ReadableApi.Repo]

# Configures the endpoint
config :readable_api, ReadableApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "CToiSDKNFkw98KMsAIdroCOgGodsytQVoOnmrqjmE+ArhPaDDYsaXANul2wbrLEG",
  render_errors: [view: ReadableApiWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ReadableApi.PubSub,
  live_view: [signing_salt: "XLHFZyL2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure session expiry time
config :readable_api, :session,
  session_max_age: 60 * 60 * 200,
  remember_max_age: 60 * 60 * 600

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
