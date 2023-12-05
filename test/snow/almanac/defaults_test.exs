defmodule Snow.Almanac.DefaultsTest do
  use ExUnit.Case, async: true
  import Snow.Almanac.Defaults
  doctest Snow.Almanac.Defaults

  @moduletag :skip
  describe "decorate" do
    test "when no defaults are needed" do
      assert decorate([], [1..2], [1..2]) == [1..2]
    end

    test "when no range" do
      assert decorate([], [], [1..2]) == [1..2]
    end

    test "when range is a subset of defaults" do
      assert decorate([], [9..9], [8..9]) == [8..8, 9..9]
    end

    @tag :skip
    test "when there is more than one range" do
      assert decorate([], [1..2, 3..4], [1..4]) == [1..2, 3..4]
    end
  end
end
