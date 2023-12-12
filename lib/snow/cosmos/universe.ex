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
    _height = Enum.count(universe)
    _width = Enum.count(hd(universe))

    universe
    |> IO.inspect(label: "before expansion")
    |> insert_rows()
    |> transpose()
    |> insert_rows()
    |> transpose()
    |> IO.inspect(label: "after expansion")
  end

  def insert_rows(rows) do
    Enum.flat_map(rows, fn row ->
      if Enum.all?(row, &(&1 == :space)) do
        added = Enum.map(row, fn _item -> :space end)
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
end
