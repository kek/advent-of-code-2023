defmodule Snow.Engine.Parser do
  import NimbleParsec

  part_number =
    integer(min: 1)
    |> tag(:part)
    |> post_traverse(:decorate)

  symbol =
    empty()
    |> ascii_char()
    |> tag(:symbol)
    |> post_traverse(:decorate)

  defparsec(
    :schematic,
    choice([
      ignore(string("\n")),
      ignore(string(".")),
      part_number,
      symbol
    ])
    |> repeat()
  )

  defp decorate(rest, args, context, line, offset) do
    item = to_item(line, offset, args)
    {rest, item |> List.wrap(), context}
  end

  defp to_item({row, col}, offset, data) do
    {row, col, offset, data}
  end
end

defmodule Snow.Engine.PartNumber do
  defstruct [:row, :column, :length, :id]

  def new(line, line_begin, offset_end, data) do
    length =
      data |> Integer.to_string() |> String.length()

    %__MODULE__{
      row: line,
      column: offset_end - length - line_begin,
      length: length,
      id: data
    }
  end
end

defmodule Snow.Engine.Symbol do
  defstruct [:row, :column, :name]

  def new(line, line_begin, offset_end, data) do
    %__MODULE__{
      row: line,
      column: offset_end - line_begin,
      name: data
    }
  end
end

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
end
