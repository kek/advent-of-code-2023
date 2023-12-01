defmodule Snow.Days.Day1 do
  alias Snow.DigitFinder
  alias Snow.DigitWrangler

  def part2(lines, debug \\ false) do
    lines
    |> tap(fn x ->
      if debug do
        IO.inspect(x, label: "input")
      end
    end)
    |> Enum.map(&DigitFinder.find_digits/1)
    |> tap(fn x ->
      if debug do
        IO.inspect(x, label: "found digits")
      end
    end)
    |> Enum.map(&DigitWrangler.first_and_last/1)
    |> tap(fn x ->
      if debug do
        IO.inspect(x, label: "first and last")
      end
    end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end
end
