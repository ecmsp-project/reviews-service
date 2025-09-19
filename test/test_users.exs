defmodule UserTest do
  use ExUnit.Case
  doctest ReviewsService

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(ReviewsService.Repo)
  end

  alias ReviewsService.Domain.Reviews
  alias ReviewsService.Domain.Users
  alias ReviewsService.Repo

  def create_random_user(uuid, first_name) do
    params = %{
      user_id: uuid,
      first_name: first_name,
    }
    Users.create_user(params)
  end

  test "create user" do
    uuid = Ecto.UUID.generate()
    first_name = "Filip"
    user = create_random_user(uuid)

    assert user
    assert user.uuid == uuid
    assert is_nil(user.first_name) != true
    assert user.first_name = ^first_name

    fetchedUser = Repo.get(User, uuid)

    assert is_nil(fetchedUser) != true
    assert fetchedUser.uuid == uuid
    assert fetchedUser.first_name == first_name
  end
end
