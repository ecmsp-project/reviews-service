defmodule ReviewsService.Migrations.CreateBasicSchema do
  use Ecto.Migration

  def change do

    create table(:users, primary_key: false) do
      add :user_id, :uuid, primary_key: true
      add :first_name, :string, null: false
      add :created_at, :date, default: fragment("now()")
    end

    create table(:reviews, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :user_id, references(:users, column: :user_id, type: :uuid), null: false

      add :variant_id, :uuid, null: false
      add :product_id, :uuid, null: false

      add :rating, :integer
      add :review_text, :text

      add :likes_number, :integer

      add :created_at, :date, default: fragment("now()")
      add :updated_at, :date, default: fragment("now()")

    end

    create unique_index(:reviews, [:variant_id])
    create unique_index(:reviews, [:product_id])
    create unique_index(:reviews, [:user_id])

  end
end
