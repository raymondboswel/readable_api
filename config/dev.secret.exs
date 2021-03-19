use Mix.Config
# Configure your database
config :phoenix_template, PhoenixTemplate.Repo,
  username: "root",
  password: "vagrant",
  database: "phoenix_template_dev",
  hostname: "mysql.local",
  port: 3306,
  pool_size: 10
