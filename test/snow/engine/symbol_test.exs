defmodule Snow.Engine.SymbolTest do
  use ExUnit.Case
  doctest Snow.Engine.Symbol

  @example_input """
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

  test "adjacents" do
    {symbols, parts} =
      Snow.Engine.build(@example_input)
      |> Snow.Engine.split_schematic()

    gears =
      Snow.Engine.Symbol.gears(symbols)

    adjacents = Snow.Engine.Symbol.adjacent(Enum.at(gears, 0), parts)

    assert inspect(adjacents) == "[Part 467(3) at (1, 1), Part 35(2) at (3, 3)]"
  end
end
