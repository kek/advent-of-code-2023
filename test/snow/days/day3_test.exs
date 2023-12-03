defmodule Snow.Days.Day3Test do
  use ExUnit.Case
  doctest Snow.Days.Day3

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
  test "the example" do
    assert Snow.Days.Day3.part_one(@example_input) == 4361
  end
end
