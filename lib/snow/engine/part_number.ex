defmodule Snow.Engine.PartNumber do
  defstruct [:row, :column, :length, :id]

  def new(line, line_begin, offset_end, data) do
    length =
      data |> Integer.to_string() |> String.length()

    %__MODULE__{
      row: line,
      column: 1 + offset_end - length - line_begin,
      length: length,
      id: data
    }
  end

  def adjacent(part_number, symbols) do
    symbols
    |> Enum.filter(fn symbol ->
      (symbol.column >= part_number.column - 1 &&
         symbol.column <= part_number.column + part_number.length &&
         abs(symbol.row - part_number.row) <= 1)
      |> debug("adjacent row", symbol, part_number)
    end)
  end

  defp debug(it_is?, label, symbol, part_number) do
    if false && it_is? do
      IO.puts("#{inspect(symbol)} #{label} as #{inspect(part_number)}")
    end

    it_is?
  end
end

defimpl Inspect, for: Snow.Engine.PartNumber do
  def inspect(%Snow.Engine.PartNumber{row: row, column: column, length: length, id: id}, _opts) do
    "Part #{id}(#{length}) at (#{row}, #{column})"
  end
end
