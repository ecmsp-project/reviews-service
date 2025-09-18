config :reviews_service, ReviewsService.Repo,
  username: "postgres",
  password: "postgres",
  database: "reviews",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
