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

  patch "/review/:id/likes_number" do

    case Reviews.increment_likes_number(conn.params["id"]) do
      {:ok, schema} ->
        send_resp(conn, 200, Jason.encode!(schema))
      {:error, error} ->
        send_resp(conn, 500, Jason.encode!(%{error: error}))
    end
  end

  patch "/review/:id" do
    params = conn.body_params

    case Reviews.update_review(conn.params["id"], params) do
      {:ok, schema} ->
        send_resp(conn, 200, Jason.encode!(schema))
      {:error, error} ->
        send_resp(conn, 500, Jason.encode!(%{error: error}))
    end
  end

  get "/review/variant/:variant_id" do
    page = conn.params
    |> Map.get("page", "1")
    |> Integer.parse()
    |> case do
      {num, _} -> num
      :error -> 1
    end

    page_size = conn.params
    |> Map.get("page_size", "10")
    |> Integer.parse()
    |> case do
      {num, _} -> num
      :error -> 1
    end

    schemas = Reviews.get_reviews_by_variant_id(conn.params["variant_id"], page, page_size)

    send_resp(conn, 200, Jason.encode!(%{
      schemas: schemas,
      summary: Reviews.get_reviews_summary(schemas)
    }))
  end

  get "/review/:id/product/:product_id" do
    page = conn.params
    |> Map.get("page", "1")
    |> Integer.parse()
    |> case do
      {num, _} -> num
      :error -> 1
    end

    page_size = conn.params
    |> Map.get("page_size", "10")
    |> Integer.parse()
    |> case do
      {num, _} -> num
      :error -> 1
    end

    schemas = Reviews.get_reviews_by_product_id(conn.params["product_id"], page, page_size)

    send_resp(conn, 200, Jason.encode!(%{
      schemas: schemas,
      summary: Reviews.get_reviews_summary(schemas)
    }))
  end

  match _ do
    send_resp(conn, 404, "Not found routing path")
  end


end
