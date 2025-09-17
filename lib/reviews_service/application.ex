defmodule ReviewsService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: ReviewsService.Worker.start_link(arg)
      # {ReviewsService.Worker, arg}
      ReviewsService.Repo,
      {Plug.Cowboy, scheme: :http, plug: ReviewsService.HttpServer, port: 4040}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ReviewsService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
