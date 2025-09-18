defmodule ReviewsTest do
  use ExUnit.Case
  doctest ReviewsService

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "creates review" do

  end 
end
