defmodule Snow.PipeMaze.Diagram do
  defstruct grid: []

  def parse(data) do
    {:ok, result, _, _, _, _} = data |> Snow.PipeMaze.Parser.diagram()
    %__MODULE__{grid: result}
  end

  def starting_point(%__MODULE__{grid: grid}) do
    {line, y} =
      grid
      |> Enum.with_index()
      |> Enum.find(fn {line, _} ->
        Enum.any?(line, &(&1 == ?S))
      end)

    {?S, x} =
      line
      |> Enum.with_index()
      |> Enum.find(fn {c, _} -> c == ?S end)

    {x, y}
  end

  def connections(%__MODULE__{grid: _grid} = diagram, {x, y}) do
    adjacents({x, y})
    |> Enum.reject(fn pos ->
      get(diagram, pos) == ?.
    end)
  end

  defp adjacents({x, y}) do
    for xd <- -1..1, yd <- -1..1 do
      {x + xd, y + yd}
    end
    |> Enum.reject(&(&1 == {x, y}))
  end

  def get(%__MODULE__{grid: grid}, {x, y}) do
    Enum.at(grid, y)
    |> Enum.at(x)
  end

  # Examples

  def day10 do
    File.read!("priv/input/Day 10 input.txt") |> parse
  end

  def first_example do
    """
    .....
    .S-7.
    .|.|.
    .L-J.
    .....
    """
    |> parse
  end

  def second_example_with_junk do
    """
    -L|F7
    7S-7|
    L|7||
    -L-J|
    L|-JF
    """
    |> parse
  end

  def more_complex_example do
    """
    ..F7.
    .FJ|.
    SJ.L7
    |F--J
    LJ...
    """
    |> parse
  end

  def more_complex_example_with_junk do
    """
    7-F7-
    .FJ|7
    SJLL7
    |F--J
    LJ.LJ
    """
    |> parse
  end
end

defimpl Inspect, for: Snow.PipeMaze.Diagram do
  def inspect(%Snow.PipeMaze.Diagram{grid: grid}, _opts) do
    width = Enum.count(Enum.at(grid, 0))

    column_legend =
      0..(width - 1)
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(&String.last/1)
      |> Enum.join()

    "  " <>
      column_legend <>
      "\n" <>
      (grid
       |> Enum.with_index()
       |> Enum.map(fn {row, i} ->
         column_legend = i |> Integer.to_string() |> String.last()
         column_legend <> " " <> List.to_string(row)
       end)
       |> Enum.join("\n"))
  end
end
