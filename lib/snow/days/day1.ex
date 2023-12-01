defmodule Snow.Days.Day1 do
  alias Snow.DigitFinder
  alias Snow.DigitWrangler

  def part2(lines) do
    lines
    |> Enum.map(&DigitFinder.find_digits/1)
    |> Enum.map(&DigitWrangler.first_and_last/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
