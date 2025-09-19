defmodule ReviewsTest do
  use ExUnit.Case
  doctest ReviewsService

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ReviewsService.Repo)
  end

  alias ReviewsService.Domain.Reviews
  alias ReviewsService.Domain.Users
  alias ReviewsService.Repo

  def create_random_review(
    user_id,
    variant_id,
    product_id
  ) do
    params = %{
      user_id: user_id,
      variant_id: variant_id,
      product_id: product_id,

      rating: 1,
      review_text: "I don't like this!"
    }

    Reviews.create_review(params)
  end

  def create_random_reviews(
    user_id,
    variant_id,
    product_id
  ) do
    params = %{
      user_id: user_id,
      variant_id: variant_id,
      product_id: product_id
    }

    review_texts = [
      "I like this product",
      "I don't like this product",
      "This is great!",
      "Ohh crap, chinese quality"
    ]

    Enum.each(1..10, fn _ ->
      Reviews.create_review(%{params |
        rating: Enum.random(1..5),
        review_text: Enum.random(review_texts)
      })
    end)

  end


  test "creates review" do
    user = create_random_user()
    uuid = Ecto.UUID.generate()

    review = create_random_review(user.user_id, uuid, uuid)

    refute is_nil(review.created_at)
    refute is_nil(review.updated_at)

    assert review.user_id == user.user_id
    assert review.variant_id == uuid
    assert review.product_id == uuid
  end
end
