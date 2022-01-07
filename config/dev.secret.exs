use Mix.Config
# Configure your database
# Configure your database
config :readable_api, ReadableApi.Repo,
  username: "postgres",
  password: "letmein",
  database: "readable_dev",
  hostname: "localhost",
  port: "5432",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :readable_api, ReadableApi.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.get_env("MAILGUN_KEY"),
  domain: System.get_env("MAILGUN_DOMAIN")
