defmodule Snow.EngineTest do
  use ExUnit.Case
  doctest Snow.Engine

  @example_schematic """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  @example_schematic_fragment """
  467..114..
  ...*......
  .664.598..
  """

  test "all of the example" do
    assert Snow.Engine.build(@example_schematic)
           |> Enum.map(&inspect/1) == [
             "Part 467(3) at (1, 1)",
             "Part 114(3) at (1, 6)",
             "Symbol * at (2, 4)",
             "Part 35(2) at (3, 3)",
             "Part 633(3) at (3, 7)",
             "Symbol # at (4, 7)",
             "Part 617(3) at (5, 1)",
             "Symbol * at (5, 4)",
             "Symbol + at (6, 6)",
             "Part 58(2) at (6, 8)",
             "Part 592(3) at (7, 3)",
             "Part 755(3) at (8, 7)",
             "Symbol $ at (9, 4)",
             "Symbol * at (9, 6)",
             "Part 664(3) at (10, 2)",
             "Part 598(3) at (10, 6)"
           ]
  end

  test "first line of the example" do
    assert Snow.Engine.build("467..114..") |> Enum.map(&inspect/1) == [
             "Part 467(3) at (1, 1)",
             "Part 114(3) at (1, 6)"
           ]
  end

  test "part of the example" do
    assert Snow.Engine.build(@example_schematic_fragment)
           |> Enum.map(&inspect/1) == [
             "Part 467(3) at (1, 1)",
             "Part 114(3) at (1, 6)",
             "Symbol * at (2, 4)",
             "Part 664(3) at (3, 2)",
             "Part 598(3) at (3, 6)"
           ]
  end
end
