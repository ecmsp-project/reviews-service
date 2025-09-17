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

  def get_reviews_by_variant_id(variant_id) do
    Review
    |> from(where: [variant_id: ^variant_id])
    |> Repo.all()
  end

end
