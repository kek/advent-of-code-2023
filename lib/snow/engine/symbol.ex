defmodule Snow.Engine.Symbol do
  defstruct [:row, :column, :name]

  def new(line, line_begin, offset_end, data) do
    %__MODULE__{
      row: line,
      column: offset_end - line_begin,
      name: data
    }
  end

  defp debug(it_is?, msg) do
    if true && it_is? do
      IO.puts(msg)
    end

    it_is?
  end

  def adjacent(symbol, parts) do
    parts
    |> Enum.filter(fn part ->
      Snow.Engine.PartNumber.adjacent(part, [symbol]) != []
    end)
  end

  def gears(symbols) do
    symbols
    |> Enum.filter(fn symbol ->
      symbol.name == ~c"*"
    end)
  end
end

defimpl Inspect, for: Snow.Engine.Symbol do
  def inspect(%Snow.Engine.Symbol{row: row, column: column, name: name}, _opts) do
    "Symbol #{name} at (#{row}, #{column})"
  end
end
