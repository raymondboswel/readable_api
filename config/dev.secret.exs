use Mix.Config
# Configure your database
config :readable_api, ReadableApi.Repo,
  username: "root",
  password: "vagrant",
  database: "readable_api_dev",
  hostname: "mysql.local",
  port: 3306,
  pool_size: 10
