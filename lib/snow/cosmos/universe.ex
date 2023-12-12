defmodule Snow.Cosmos.Universe do
  import NimbleParsec

  require Logger

  def celestial_object("."), do: :space
  def celestial_object("#"), do: :galaxy

  defparsec(
    :document,
    times(
      wrap(
        times(
          choice([
            string("."),
            string("#")
          ])
          |> map(:celestial_object),
          min: 1
        )
        |> ignore(string("\n"))
      ),
      min: 1
    )
  )

  def get(universe, {x, y}) do
    case Enum.at(universe, y) do
      nil -> nil
      row -> Enum.at(row, x)
    end
  end

  def get_v(universe, {x, y}) do
    cond do
      Agent.get(:blank_rows, fn s -> MapSet.member?(s, y) end) ->
        :space

      Agent.get(:blank_cols, fn s -> MapSet.member?(s, x) end) ->
        :space

      true ->
        case Enum.at(universe, y) do
          nil -> :space
          row -> Enum.at(row, x)
        end
    end
  end

  def expand(universe, factor \\ 2) do
    {:ok, blank_rows} = Agent.start_link(fn -> MapSet.new() end)
    Process.register(blank_rows, :blank_rows)
    {:ok, blank_cols} = Agent.start_link(fn -> MapSet.new() end)
    Process.register(blank_cols, :blank_cols)

    universe
    |> transpose()
    |> insert_rows(factor, :cols)
    |> transpose()
    |> insert_rows(factor, :rows)
    |> contemplate_the_stars()

    Process.unregister(:blank_rows)
    Process.unregister(:blank_cols)
  end

  def insert_rows(rows, factor, mode) do
    Logger.debug("insert rows")

    Enum.flat_map(Enum.with_index(rows), fn {row, i} ->
      if Enum.all?(row, &(&1 == :space)) do
        case mode do
          :rows -> Agent.update(:blank_rows, fn s -> MapSet.put(s, i) end)
          :cols -> Agent.update(:blank_cols, fn s -> MapSet.put(s, i) end)
        end

        row = Stream.cycle([:ether]) |> Enum.take(Enum.count(row))
        Stream.cycle([row]) |> Enum.take(factor)
      else
        [row]
      end
    end)
  end

  def transpose(rows) do
    Logger.debug("transpose")

    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def contemplate_the_stars(universe) do
    Logger.debug("Contemplating the stars")
    height = Enum.count(universe)
    width = Enum.count(hd(universe))

    Logger.debug(
      "The universe is #{width} wide and #{height} high... That makes #{width * height} locations."
    )

    # Agent.get(:blank_rows, fn s -> s end) |> IO.inspect(label: "blank rows")
    # Agent.get(:blank_cols, fn s -> s end) |> IO.inspect(label: "blank cols")

    stars =
      for x <- 0..(width - 1), y <- 0..(height - 1) do
        case get_v(universe, {x, y}) do
          :space -> []
          :ether -> []
          :galaxy -> [{x, y}]
        end
      end
      |> Enum.flat_map(& &1)

    Logger.debug("Finding the pairs")

    pairs =
      for a <- stars, b <- stars, a != b do
        MapSet.new([a, b])
      end
      |> Enum.uniq()

    Logger.debug("Calculating the distances")

    for pair <- pairs do
      [{ax, ay}, {bx, by}] = Enum.take(pair, 2)
      max(ax, bx) - min(ax, bx) + max(ay, by) - min(ay, by)
    end
    |> Enum.sum()
    |> IO.inspect(label: "sum of distances")

    universe
  end
end
