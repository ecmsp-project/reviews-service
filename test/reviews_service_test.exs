defmodule ReviewsServiceTest do
  use ExUnit.Case
  doctest ReviewsService

  test "greets the world" do
    assert ReviewsService.hello() == :world
  end
end
