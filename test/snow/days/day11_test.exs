defmodule Snow.Days.Day11Test do
  use ExUnit.Case

  test "yes" do
    {:ok, universe, _, _, _, _} = Snow.Cosmos.Universe.document(Snow.Cosmos.Examples.my_input())

    assert universe
           |> Snow.Cosmos.Universe.expand()
           |> Snow.Cosmos.Universe.contemplate_the_stars(1_000_000) == 560_822_911_938
  end
end
