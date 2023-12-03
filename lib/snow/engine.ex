defmodule Snow.Engine do
  @doc """
  Engine schematic symbol is anything except number or dot.

  ## Examples

      iex> String.match?("a", Snow.Engine.schematic_symbol)
      true
      iex> String.match?("1", Snow.Engine.schematic_symbol)
      false
      iex> String.match?(".", Snow.Engine.schematic_symbol)
      false
  """
  def schematic_symbol, do: ~r/[^\.0-9]/

  @doc """
  Engine part number is a number.

  ## Examples

      iex> String.match?("1", Snow.Engine.part_number)
      true
      iex> String.match?("123", Snow.Engine.part_number)
      true
      iex> String.match?(".", Snow.Engine.part_number)
      false
      # iex> Regex.split(Snow.Engine.part_number, "...1...", include_capture: true)
      # ["...", "1", "..."]
  """
  def part_number, do: ~r/[0-9]+/

  def build(schematic) do
    case Snow.Engine.Parser.schematic(schematic) do
      {:ok, items, "", _, _, _} ->
        items
        |> Enum.map(&transform/1)

      {:ok, items, rest, _, _, _} ->
        {:error, "Parsed #{inspect(items)} but parsing failed at #{inspect(rest)}"}
    end
  end

  alias Snow.Engine.PartNumber
  alias Snow.Engine.Symbol

  defp transform({line, line_begin, char_end, part: [part_id]}),
    do: PartNumber.new(line, line_begin, char_end, part_id)

  defp transform({line, line_begin, char_end, symbol: symbol}),
    do: Symbol.new(line, line_begin, char_end, symbol)

  def split_schematic(schematic) do
    Enum.split_with(schematic, fn item ->
      item.__struct__ == Snow.Engine.Symbol
    end)
  end
end
