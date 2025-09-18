defmodule ReviewsService.Domain.Review do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :variant_id, :product_id, :rating, :review_text, :likes_number, :created_at, :updated_at, :user_id]}
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "reviews" do
    field :variant_id, Ecto.UUID
    field :product_id, Ecto.UUID

    field :rating, :integer, default: 0
    field :review_text, :string

    field :likes_number, :integer, default: 0

    field :created_at, :date
    field :updated_at, :date

    belongs_to :user, ReviewsService.Domain.User, foreign_key: :user_id, references: :user_id, type: Ecto.UUID

  end

  def changeset(struct, params) do
    struct
    |> change(params)
  end

  def create_changeset(struct, params) do
    struct
    |> change(params)
    |> validate_required([:user_id, :variant_id, :product_id, :rating, :review_text])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)

    |> put_change(:created_at, Date.utc_today())
    |> put_change(:updated_at, Date.utc_today())
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:rating, :review_text])
    |> validate_number(:rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5)

    |> put_change(:updated_at, Date.utc_today())
  end

end
