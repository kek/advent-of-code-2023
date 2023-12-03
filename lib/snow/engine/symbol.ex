defmodule Snow.Engine.Symbol do
  defstruct [:row, :column, :name]

  def new(line, line_begin, offset_end, data) do
    %__MODULE__{
      row: line,
      column: 1 + offset_end - line_begin,
      name: data
    }
  end
end

defimpl Inspect, for: Snow.Engine.Symbol do
  def inspect(%Snow.Engine.Symbol{row: row, column: column, name: name}, _opts) do
    "Symbol #{name} at (#{row}, #{column})"
  end
end
