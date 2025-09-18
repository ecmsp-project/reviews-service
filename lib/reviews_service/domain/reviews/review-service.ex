defmodule ReviewsService.Domain.Reviews do
  import Ecto.Query, warn: false

  alias ReviewsService.Domain.Review
  alias ReviewsService.Repo

  def create_review(params \\ %{}) do
    %Review{}
    |> Review.create_changeset(params)
    |> Repo.insert()
  end

  def update_review(id, params \\ %{}) do

    case Repo.get(Review, id) do
      nil -> {:error, :not_found}

      review ->
        review
        |> Review.update_changeset(params)
        |> Repo.update()
    end
  end

  def get_reviews_by_variant_id(variant_id, page \\ 1, page_size \\ 10) do
    offset = (page - 1) * page_size

    Review
    |> where([r], r.variant_id == ^variant_id)
    |> order_by([r], desc: r.likes_number)
    # |> from(where: [variant_id: ^variant_id])
    |> limit(^page_size)
    |> offset(^offset)
    |> Repo.all()
  end

  def get_reviews_by_product_id(product_id, page \\ 1, page_size \\ 10) do
    offset = (page - 1) * page_size

    Review
    |> where([r], r.product_id == ^product_id)
    |> order_by([r], desc: r.likes_number)
    # |> from(where: [product_id: ^product_id])
    |> limit(^page_size)
    |> offset(^offset)
    |> Repo.all()
  end

  def increment_likes_number(id) do
    case Repo.get(Review, id) do
      nil -> {:error, :not_found}
      review ->
        review
        |> Review.changeset(%{likes_number: review.likes_number + 1})
        |> Repo.update()
    end
  end

  def calculate_average_rating(schemas) do
    Enum.reduce(schemas, 0, fn schema, sum -> schema.rating + sum end)
    |> Kernel./(length(schemas))
    |> Float.round(2)
  end

  def calculate_reviews_distribution(schemas) do
    schemas
    |> Enum.map(& &1.rating)
    |> Enum.frequencies()

  end

  def get_reviews_summary(schemas) do
    %{
      average: schemas |> calculate_average_rating(),
      amount: schemas |> length(),
      frequency: schemas |> calculate_reviews_distribution()
    }
  end
end
