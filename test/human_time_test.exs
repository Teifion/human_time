defmodule HumanTimeTest do
  use ExUnit.Case
  doctest HumanTime

  test "greets the world" do
    assert HumanTime.hello() == :world
  end
end
