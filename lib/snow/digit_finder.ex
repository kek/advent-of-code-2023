defmodule Snow.DigitFinder do
  @doc ~S"""
  Finds all digits in a string and returns them as a numeric string

  ## Examples

    iex> Snow.DigitFinder.parse("1")
    "1"
    iex> Snow.DigitFinder.parse("1x2")
    "12"
    iex> Snow.DigitFinder.parse("one")
    "1"
    iex> Snow.DigitFinder.parse("oneight")
    "18"
    iex> Snow.DigitFinder.parse("twone")
    "21"
    iex> Snow.DigitFinder.parse("sevenine")
    "79"
    iex> Snow.DigitFinder.parse("nineight")
    "98"
    iex> Snow.DigitFinder.parse("threeight")
    "38"

  """
  def parse(line), do: parse(line, "")

  defp parse("", acc), do: acc

  defp parse(line, acc) do
    {first, rest} =
      line |> String.split_at(1)

    found =
      if String.match?(first, ~r/[1-9]/) do
        first
      else
        case line do
          "one" <> _ -> "1"
          "two" <> _ -> "2"
          "three" <> _ -> "3"
          "four" <> _ -> "4"
          "five" <> _ -> "5"
          "six" <> _ -> "6"
          "seven" <> _ -> "7"
          "eight" <> _ -> "8"
          "nine" <> _ -> "9"
          _ -> ""
        end
      end

    parse(rest, acc <> found)
  end
end
