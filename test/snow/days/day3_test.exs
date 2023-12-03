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

  @real_input File.read!("priv/input/Day 3 input.txt")

  test "Part one example" do
    assert Snow.Days.Day3.part_one(@example_input) == 4361
  end

  test "Part one real" do
    assert Snow.Days.Day3.part_one(@real_input) == 527_144
  end

  test "Part two example" do
    assert Snow.Days.Day3.part_two(@example_input) == 467_835
  end

  test "Part two real" do
    assert Snow.Days.Day3.part_two(@real_input) == 81_463_996
  end
end
