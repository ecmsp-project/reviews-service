defmodule ReviewsService.Repo do
  use Ecto.Repo,
    otp_app: :reviews_service,
    adapter: Ecto.Adapters.Postgres
end
