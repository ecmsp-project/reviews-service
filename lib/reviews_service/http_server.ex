defmodule ReviewsService.HttpServer do
  use Plug.Router
  alias ReviewsService.Domain.Reviews
  alias ReviewsService.Domain.Users

  plug :match

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason

  plug :dispatch

  post "/review" do
    params = conn.body_params
    params = for {k, v} <- params, into: %{}, do: {String.to_atom(k), v}

    case Reviews.create_review(params) do
      {:ok, schema} ->
        send_resp(conn, 200, Jason.encode!(schema))
      {:error, error} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{error: error}))
    end
  end

  patch "/review" do
    params = conn.body_params

    case Reviews.update_review(params["id"], params) do
      {:ok, schema} ->
        send_resp(conn, 200, Jason.encode(schema))
      {:error, error} ->
        send_resp(conn, 500, Jason.encode!(%{error: error}))
    end
  end

  post "/user" do
    params = conn.body_params
    params = for {k, v} <- params, into: %{}, do: {String.to_atom(k), v}
    
    case Users.create_user(params) do
      {:ok, schema} ->
        send_resp(conn, 200, Jason.encode!(schema))
      {:error, error} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(500, Jason.encode!(%{error: error}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not found routing path")
  end
end
