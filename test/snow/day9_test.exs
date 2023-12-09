defmodule Snow.Days.Day9Test do
  use ExUnit.Case
  import Snow.Oasis

  @example """
           0 3 6 9 12 15
           1 3 6 10 15 21
           10 13 16 21 30 45
           """
           |> String.split("\n", trim: true)
           |> Enum.map(fn line ->
             line |> String.split(" ") |> Enum.map(&String.to_integer/1)
           end)
  @real File.read!("priv/input/Day 9 input.txt")
        |> String.split("\n", trim: true)
        |> Enum.map(fn line ->
          line |> String.split(" ") |> Enum.map(&String.to_integer/1)
        end)

  test "spacings" do
    assert spacings(Enum.at(@example, 0)) == [3, 3, 3, 3, 3]
  end

  test "next" do
    assert next(Enum.at(@example, 0)) == 18
    assert next(Enum.at(@example, 1)) == 28
    assert next(Enum.at(@example, 2)) == 68
  end

  test "solution for example" do
    assert solution(@example) == 114
  end

  test "solution for real" do
    assert solution(@real) == 1_798_691_765
  end
end
