defmodule Snow.Days.Day1Test do
  use ExUnit.Case, async: true
  doctest Snow

  defp input do
    File.read!("priv/input/Day 1 input.txt") |> String.split("\n", trim: true)
  end

  test "Day 1 part two example" do
    test_input =
      """
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
      """
      |> String.split("\n", trim: true)

    assert Snow.Days.Day1.part2(test_input) == 281
  end

  test "Day 1 part two real input" do
    assert Snow.Days.Day1.part2(input()) == 54265
  end
end
