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

  def get(space_map, {x, y}) do
    case Enum.at(space_map, y) do
      nil -> nil
      row -> Enum.at(row, x)
    end
  end

  def get_v(space_map, {x, y}) do
    case Enum.at(space_map, y) do
      nil -> nil
      row -> Enum.at(row, x)
    end
  end

  def expand(universe, factor \\ 2) do
    universe
    |> transpose()
    |> insert_rows(factor)
    |> transpose()
    |> insert_rows(factor)
    |> contemplate_the_stars()
  end

  def insert_rows(rows, factor) do
    Logger.debug("insert rows")

    Enum.flat_map(rows, fn row ->
      if Enum.all?(row, &(&1 == :space)) do
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
    IO.inspect(universe, label: "decorated universe")
    height = Enum.count(universe)
    width = Enum.count(hd(universe))

    Logger.debug(
      "The universe is #{width} wide and #{height} high... That makes #{width * height} possibilities."
    )

    stars =
      for x <- 0..(width - 1), y <- 0..(height - 1) do
        case get_v(universe, {x, y}) do
          :space -> []
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
