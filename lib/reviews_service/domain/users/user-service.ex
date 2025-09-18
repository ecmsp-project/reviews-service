defmodule ReviewsService.Domain.Users do
  alias ReviewsService.Domain.User
  alias ReviewsService.Repo

  def create_user(params \\ %{}) do
    %User{}
    |> User.create_changeset(params)
    |> Repo.insert()
  end

  def update_user(id, params \\ %{}) do

    case Repo.get(User, id) do
      nil -> {:error, :not_found}

      user ->
        user
        |> User.update_changeset(params)
        |> Repo.update()
    end
  end

end
