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

  def can_connect?(direction, this, that) do
    case {direction, this, that} do
      {_, _, nil} -> false
      {_, nil, _} -> false
      {:here, _, ?S} -> false
      {_, _, ?.} -> false
      # Impossible outs
      {:w, ?|, _} -> false
      {:e, ?|, _} -> false
      {:n, ?-, _} -> false
      {:s, ?-, _} -> false
      {:w, ?L, _} -> false
      {:s, ?L, _} -> false
      {:e, ?J, _} -> false
      {:s, ?J, _} -> false
      {:e, ?7, _} -> false
      {:n, ?7, _} -> false
      {:n, ?F, _} -> false
      {:w, ?F, _} -> false
      {_, _, ?S} -> true
      # You can go North by | 7 F
      {:n, _, ?|} -> true
      {:n, _, ?-} -> false
      {:n, _, ?L} -> false
      {:n, _, ?J} -> false
      {:n, _, ?7} -> true
      {:n, _, ?F} -> true
      # You can go East by - J 7
      {:e, _, ?|} -> false
      {:e, _, ?-} -> true
      {:e, _, ?L} -> false
      {:e, _, ?J} -> true
      {:e, _, ?7} -> true
      {:e, _, ?F} -> false
      # You can go South by | L J
      {:s, _, ?|} -> true
      {:s, _, ?-} -> false
      {:s, _, ?L} -> true
      {:s, _, ?J} -> true
      {:s, _, ?7} -> false
      {:s, _, ?F} -> false
      # You can go West by - L F
      {:w, _, ?|} -> false
      {:w, _, ?-} -> true
      {:w, _, ?L} -> true
      {:w, _, ?J} -> false
      {:w, _, ?7} -> false
      {:w, _, ?F} -> true
    end
  end

  def connections(%__MODULE__{grid: _grid} = diagram, {x, y}) do
    # IO.inspect({x, y}, label: "Checking connections for")

    adjacents({x, y})
    # |> IO.inspect(label: "Those were the adjacents for #{inspect({x, y})}")
    |> Enum.filter(fn {dir, pos} ->
      # IO.inspect(dir)
      # IO.inspect(get(diagram, pos), label: "get")

      can_connect?(dir, get(diagram, {x, y}), get(diagram, pos))
      # |> IO.inspect(
      #   label:
      #     "Can connect #{inspect({x, y})} which is a #{inspect(get(diagram, {x, y}))} to the #{dir} #{inspect(pos)} because there is a #{inspect(get(diagram, pos))} there"
      # )
    end)

    # |> IO.inspect(label: "Those were the connections for #{inspect({x, y})}")
  end

  def adjacents({x, y}) do
    [:n, :e, :s, :w]
    |> Enum.zip([{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}])
    |> Enum.reject(fn {_, {x, y}} ->
      x < 0 || y < 0
    end)
    |> Enum.reject(&(&1 == {x, y}))
  end

  def get(%__MODULE__{grid: grid}, {x, y}) do
    # IO.inspect({x, y}, label: "getting")

    case Enum.at(grid, y) do
      nil -> nil
      row -> Enum.at(row, x)
    end
  end

  def find_the_loop(diagram, pos, from \\ nil) do
    # IO.inspect(connections(diagram, pos), label: "Hey #{inspect(pos)}")

    next =
      case connections(diagram, pos) do
        [{_, ^from}, {_, b}] -> b
        [{_, a}, {_, _}] -> a
      end

    if get(diagram, next) == ?S do
      [pos]
    else
      [pos | find_the_loop(diagram, next, pos)]
      # |> IO.inspect(label: "so far")
    end
  end

  def project(shape, x, y) do
    Enum.map(0..(y - 1), fn row ->
      Enum.map(0..(x - 1), fn col ->
        if Enum.any?(shape, fn
             {^row, ^col} -> true
             _ -> false
           end) do
          ?o
        else
          ?.
        end
      end)
    end)
  end

  def dimensions(%__MODULE__{grid: grid}) do
    {Enum.count(hd(grid)), Enum.count(grid)}
  end

  def draw_loop(diagram) do
    sp = starting_point(diagram)
    loop = find_the_loop(diagram, sp)
    {x, y} = dimensions(diagram)
    %__MODULE__{grid: project(loop, x, y)}
  end

  def draw_first_loop do
    draw_loop(first_example())
  end

  def draw_real_loop do
    draw_loop(day10())
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
