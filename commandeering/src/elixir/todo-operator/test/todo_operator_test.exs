defmodule TodoOperatorTest do
  use ExUnit.Case
  doctest TodoOperator

  test "greets the world" do
    assert TodoOperator.hello() == :world
  end
end
