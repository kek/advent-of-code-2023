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

  """
  def find_digits(string) do
    IO.inspect(string, label: "find_digits")

    pick_digits(string, "")
    |> IO.inspect(label: "pick_digits")
  end

  def pick_digits("", acc) do
    acc
  end

  def pick_digits(s, acc) do
    {found, rest} = digit(s)
    pick_digits(rest, acc <> found)
  end

  defp digit("one" <> rest), do: {"1", rest}
  defp digit("two" <> rest), do: {"2", rest}
  defp digit("three" <> rest), do: {"3", rest}
  defp digit("four" <> rest), do: {"4", rest}
  defp digit("five" <> rest), do: {"5", rest}
  defp digit("six" <> rest), do: {"6", rest}
  defp digit("seven" <> rest), do: {"7", rest}
  defp digit("eight" <> rest), do: {"8", rest}
  defp digit("nine" <> rest), do: {"9", rest}
  defp digit("1" <> rest), do: {"1", rest}
  defp digit("2" <> rest), do: {"2", rest}
  defp digit("3" <> rest), do: {"3", rest}
  defp digit("4" <> rest), do: {"4", rest}
  defp digit("5" <> rest), do: {"5", rest}
  defp digit("6" <> rest), do: {"6", rest}
  defp digit("7" <> rest), do: {"7", rest}
  defp digit("8" <> rest), do: {"8", rest}
  defp digit("9" <> rest), do: {"9", rest}
  defp digit(<<_::size(8), rest::binary>>), do: {"", rest}
end
