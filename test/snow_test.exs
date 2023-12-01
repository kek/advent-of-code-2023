defmodule SnowTest do
  use ExUnit.Case, async: true
  doctest Snow

  test "has a version number" do
    assert Snow.version()
  end
end
