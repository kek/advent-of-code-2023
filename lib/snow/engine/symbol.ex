defmodule Snow.Engine.Symbol do
  defstruct [:row, :column, :name]

  def new(line, line_begin, offset_end, data) do
    %__MODULE__{
      row: line,
      column: offset_end - line_begin,
      name: data
    }
  end

  defp debug(it_is?, label, this, that) do
    if false && it_is? do
      IO.puts("#{inspect(this)} #{label} as #{inspect(that)}")
    end

    it_is?
  end

  def adjacent(symbol, part_numbers) do
    part_numbers
    |> Enum.filter(fn part_number ->
      (part_number.column >= symbol.column - 1 &&
         part_number.column <= symbol.column + 1 &&
         abs(part_number.row - symbol.row) <= 1)
      |> debug("adjacent row", part_number, symbol)
    end)
  end
end

defimpl Inspect, for: Snow.Engine.Symbol do
  def inspect(%Snow.Engine.Symbol{row: row, column: column, name: name}, _opts) do
    "Symbol #{name} at (#{row}, #{column})"
  end
end
