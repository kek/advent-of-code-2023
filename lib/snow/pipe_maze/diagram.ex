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

  # | is a vertical pipe connecting north and south.
  # - is a horizontal pipe connecting east and west.
  # L is a 90-degree bend connecting north and east.
  # J is a 90-degree bend connecting north and west.
  # 7 is a 90-degree bend connecting south and west.
  # F is a 90-degree bend connecting south and east.

  def connections(%__MODULE__{grid: _grid} = diagram, {x, y}) do
    adjacents({x, y})
    |> Enum.reject(fn {dir, pos} ->
      case {dir, get(diagram, pos) |> IO.inspect(label: "#{inspect(dir)}")} do
        {:here, ?S} -> true
        {_, ?.} -> true
        # You can go North by | 7 F
        {:n, ?|} -> false
        {:n, ?-} -> true
        {:n, ?L} -> true
        {:n, ?J} -> true
        {:n, ?7} -> false
        {:n, ?F} -> false
        # You can go East by - J 7
        {:e, ?|} -> true
        {:e, ?-} -> false
        {:e, ?L} -> true
        {:e, ?J} -> false
        {:e, ?7} -> false
        {:e, ?F} -> true
        # You can go South by | L J
        {:s, ?|} -> false
        {:s, ?-} -> true
        {:s, ?L} -> false
        {:s, ?J} -> false
        {:s, ?7} -> true
        {:s, ?F} -> true
        # You can go West by - L F
        {:w, ?|} -> true
        {:w, ?-} -> false
        {:w, ?L} -> false
        {:w, ?J} -> true
        {:w, ?7} -> true
        {:w, ?F} -> false
      end
    end)
  end

  def adjacents({x, y}) do
    [:n, :e, :s, :w]
    |> Enum.zip([{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}])
    |> IO.inspect()
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

  def first_example_with_junk do
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
