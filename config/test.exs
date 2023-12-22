import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :quiz, KQ.Repo,
  database: Path.expand("../quiz_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :quiz, KQWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "IwYRHmnfjmik3KHa2Uhn+21wDYP/1o4ztFdA34YgDpDofgoK+1wrhNDSlvUNkVs2",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# set download path for generated images to /tmp
config :quiz, :download_path, "/tmp"
