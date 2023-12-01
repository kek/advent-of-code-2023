defmodule Snow.DigitFinder do
  @doc ~S"""
  Finds all digits in a string and returns them as a numeric string

  ## Examples

    iex> Snow.DigitFinder.find_digits("1")
    "1"
    iex> Snow.DigitFinder.find_digits("1x2")
    "12"
    iex> Snow.DigitFinder.find_digits("one")
    "1"
    iex> Snow.DigitFinder.find_digits("oneight")
    "18"
    iex> Snow.DigitFinder.find_digits("twone")
    "21"
    iex> Snow.DigitFinder.find_digits("sevenine")
    "79"
    iex> Snow.DigitFinder.find_digits("nineight")
    "98"
    iex> Snow.DigitFinder.find_digits("threeight")
    "38"

  """
  def find_digits(line), do: find_digits(line, "")

  defp find_digits("", acc), do: acc

  defp find_digits(line, acc) do
    {found, rest} = digit(line)
    find_digits(rest, acc <> found)
  end

  defp digit("one" <> _ = line), do: found("1", line)
  defp digit("two" <> _ = line), do: found("2", line)
  defp digit("three" <> _ = line), do: found("3", line)
  defp digit("four" <> _ = line), do: found("4", line)
  defp digit("five" <> _ = line), do: found("5", line)
  defp digit("six" <> _ = line), do: found("6", line)
  defp digit("seven" <> _ = line), do: found("7", line)
  defp digit("eight" <> _ = line), do: found("8", line)
  defp digit("nine" <> _ = line), do: found("9", line)
  defp digit("1" <> _ = line), do: found("1", line)
  defp digit("2" <> _ = line), do: found("2", line)
  defp digit("3" <> _ = line), do: found("3", line)
  defp digit("4" <> _ = line), do: found("4", line)
  defp digit("5" <> _ = line), do: found("5", line)
  defp digit("6" <> _ = line), do: found("6", line)
  defp digit("7" <> _ = line), do: found("7", line)
  defp digit("8" <> _ = line), do: found("8", line)
  defp digit("9" <> _ = line), do: found("9", line)
  defp digit(line), do: found("", line)

  defp found(found, line), do: {found, remove_first_char(line)}

  defp remove_first_char(string), do: String.split_at(string, 1) |> elem(1)
end
