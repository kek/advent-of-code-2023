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

  test "first line of the example" do
    assert Snow.Engine.build("467..114..") == [
             %Snow.Engine.PartNumber{row: 1, column: 0, length: 3, id: 467},
             %Snow.Engine.PartNumber{row: 1, column: 5, length: 3, id: 114}
           ]
  end

  test "part of the example" do
    assert Snow.Engine.build(@example_schematic_fragment) == [
             %Snow.Engine.PartNumber{row: 1, column: 0, length: 3, id: 467},
             %Snow.Engine.PartNumber{row: 1, column: 5, length: 3, id: 114},
             %Snow.Engine.Symbol{row: 2, column: 4, name: ~c"*"},
             %Snow.Engine.PartNumber{row: 3, column: 1, length: 3, id: 664},
             %Snow.Engine.PartNumber{row: 3, column: 5, length: 3, id: 598}
           ]
  end

  test "all of the example" do
    assert Snow.Engine.build(@example_schematic) == [
             %Snow.Engine.PartNumber{column: 0, id: 467, length: 3, row: 1},
             %Snow.Engine.PartNumber{column: 5, id: 114, length: 3, row: 1},
             %Snow.Engine.Symbol{column: 4, row: 2, name: ~c"*"},
             %Snow.Engine.PartNumber{column: 2, id: 35, length: 2, row: 3},
             %Snow.Engine.PartNumber{column: 6, id: 633, length: 3, row: 3},
             %Snow.Engine.Symbol{column: 7, row: 4, name: ~c"#"},
             %Snow.Engine.PartNumber{column: 0, id: 617, length: 3, row: 5},
             %Snow.Engine.Symbol{column: 4, row: 5, name: ~c"*"},
             %Snow.Engine.Symbol{column: 6, row: 6, name: ~c"+"},
             %Snow.Engine.PartNumber{column: 7, id: 58, length: 2, row: 6},
             %Snow.Engine.PartNumber{column: 2, id: 592, length: 3, row: 7},
             %Snow.Engine.PartNumber{column: 6, id: 755, length: 3, row: 8},
             %Snow.Engine.Symbol{column: 4, row: 9, name: ~c"$"},
             %Snow.Engine.Symbol{column: 6, row: 9, name: ~c"*"},
             %Snow.Engine.PartNumber{column: 1, id: 664, length: 3, row: 10},
             %Snow.Engine.PartNumber{column: 5, id: 598, length: 3, row: 10}
           ]
  end
end
