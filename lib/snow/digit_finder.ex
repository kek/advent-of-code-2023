defmodule Snow.DigitFinder do
  @doc ~S"""
  Finds all digits in a string and returns them as a list of integers

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
  def find_digits(string) do
    find_digits(string, "")
  end

  defp find_digits("", acc) do
    acc
  end

  defp find_digits(s, acc) do
    {found, rest} = digit(s)
    find_digits(rest, acc <> found)
  end

  defp digit("one" <> _ = thing), do: cont("1", thing)
  defp digit("two" <> _ = thing), do: cont("2", thing)
  defp digit("three" <> _ = thing), do: cont("3", thing)
  defp digit("four" <> _ = thing), do: cont("4", thing)
  defp digit("five" <> _ = thing), do: cont("5", thing)
  defp digit("six" <> _ = thing), do: cont("6", thing)
  defp digit("seven" <> _ = thing), do: cont("7", thing)
  defp digit("eight" <> _ = thing), do: cont("8", thing)
  defp digit("nine" <> _ = thing), do: cont("9", thing)
  defp digit("1" <> rest), do: {"1", rest}
  defp digit("2" <> rest), do: {"2", rest}
  defp digit("3" <> rest), do: {"3", rest}
  defp digit("4" <> rest), do: {"4", rest}
  defp digit("5" <> rest), do: {"5", rest}
  defp digit("6" <> rest), do: {"6", rest}
  defp digit("7" <> rest), do: {"7", rest}
  defp digit("8" <> rest), do: {"8", rest}
  defp digit("9" <> rest), do: {"9", rest}

  defp digit(rest), do: cont("", rest)

  defp cont(found, ""), do: {found, ""}

  defp cont(found, rest) do
    {_, rest} =
      String.split_at(rest, 1)

    {found, rest}
  end
end
