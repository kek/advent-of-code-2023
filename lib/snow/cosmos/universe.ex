defmodule Snow.Cosmos.Universe do
  import NimbleParsec

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

  @spec get(list(list()), {x :: integer(), y :: integer()}) :: :space | :galaxy
  def get(space_map, {x, y}) do
    case Enum.at(space_map, y) do
      nil -> nil
      row -> Enum.at(row, x)
    end
  end

  @spec expand(nonempty_maybe_improper_list()) :: list()
  def expand(universe) do
    universe
    |> insert_rows()
    |> transpose()
    |> insert_rows()
    |> transpose()
    |> contemplate_the_stars()
  end

  def insert_rows(rows) do
    Enum.flat_map(rows, fn row ->
      if Enum.all?(row, &(&1 == :space)) do
        added = Stream.cycle([:space]) |> Enum.take(Enum.count(row))
        [row, added]
      else
        [row]
      end
    end)
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def contemplate_the_stars(universe) do
    height = Enum.count(universe)
    width = Enum.count(hd(universe))

    stars =
      for x <- 0..(width - 1), y <- 0..(height - 1) do
        case get(universe, {x, y}) do
          :space -> []
          :galaxy -> [{x, y}]
        end
      end
      |> Enum.flat_map(& &1)

    pairs =
      for a <- stars, b <- stars, a != b do
        MapSet.new([a, b])
      end
      |> Enum.uniq()

    for pair <- pairs do
      [{ax, ay}, {bx, by}] = Enum.take(pair, 2)
      max(ax, bx) - min(ax, bx) + max(ay, by) - min(ay, by)
    end
    |> Enum.sum()
    |> IO.inspect(label: "sum of distances")

    universe
  end
end
