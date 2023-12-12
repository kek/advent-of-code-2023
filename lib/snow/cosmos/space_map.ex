defmodule Snow.Cosmos.SpaceMap do
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
end
