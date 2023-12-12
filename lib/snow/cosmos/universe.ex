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

  def expand(universe, factor \\ 2) do
    universe
    |> insert_rows()
    |> transpose()
    |> insert_rows()
    |> transpose()
    |> contemplate_the_stars(factor)
  end

  def insert_rows(rows) do
    Logger.debug("insert rows")

    Enum.map(rows, fn row ->
      if Enum.all?(row, &(&1 == :space || &1 == :ether)) do
        Enum.map(row, fn _ -> :ether end)
      else
        row
      end
    end)
  end

  def transpose(rows) do
    Logger.debug("transpose")

    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def contemplate_the_stars(universe, ether_weight) do
    Logger.debug("Contemplating the stars")
    height = Enum.count(universe)
    width = Enum.count(hd(universe))

    # Logger.debug(
    #   "The universe is #{width} wide and #{height} high... That makes #{width * height} locations."
    # )

    stars =
      for x <- 0..(width - 1), y <- 0..(height - 1) do
        case get(universe, {x, y}) do
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
      [a, b] = Enum.take(pair, 2)
      distance(universe, a, b, ether_weight)
    end
    |> Enum.sum()
    |> IO.inspect(label: "sum of distances")

    universe
  end

  defp distance(universe, a, b, ether_weight) do
    path(project(a, universe, ether_weight), project(b, universe, ether_weight))
  end

  # defp distance(universe, {ax, ay}, {bx, by}, ether_weight) do
  #   {fromx, fromy} = {min(ax, bx), min(ay, by)} |> project(universe, ether_weight)
  #   {tox, toy} = {max(ax, bx), max(ay, by)} |> project(universe, ether_weight)

  #   tox - fromx + toy - fromy
  # end

  # defp project({x, y}, universe, ether_weight) do
  #   # |> IO.inspect(label: "row")
  #   row = Enum.at(universe, y) |> Enum.take(x)
  #   # |> IO.inspect(label: "column")
  #   column = Enum.map(universe, &Enum.at(&1, x)) |> Enum.take(y)
  #   ethers_on_row = Enum.count(row, &(&1 == :ether))
  #   ethers_in_column = Enum.count(column, &(&1 == :ether))
  #   ether_width = ethers_on_row * ether_weight
  #   ether_height = ethers_in_column * ether_weight
  #   {x + ether_width, y + ether_height}
  # end
end
