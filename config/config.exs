import Config

config :reviews_service, ReviewsService.Repo,
  database: "reviews",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"



config :reviews_service, ecto_repos: [ReviewsService.Repo]
