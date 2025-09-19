import Config

config :reviews_service, ReviewsService.Repo,
  username: "postgres",
  password: "postgres",
  database: "reviews_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 20
