defmodule ReviewsService.Domain.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:user_id, :first_name, :created_at]}
  @primary_key {:user_id, Ecto.UUID, autogenerate: false}
  schema "users" do
    field :first_name, :string
    field :created_at, :date

    has_many :user_reviews, ReviewsService.Domain.Review, foreign_key: :user_id
  end

  def create_changeset(struct, params) do
      struct
      |> change(params)
      |> validate_required([:user_id, :first_name])
      |> validate_length(:first_name, min: 3, max: 13)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:first_name])
    |> validate_length(:first_name, min: 3, max: 13)
  end
end
