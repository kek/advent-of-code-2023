defmodule Snow.Game.Draw do
  defstruct cubes: []

  @doc """
  Creates a new draw from a string.

  ## Examples

      iex> Snow.Game.Draw.new("1 blue, 2 red")
      %Snow.Game.Draw{cubes: [%Snow.Game.Cube{color: :blue, number: 1}, %Snow.Game.Cube{color: :red, number: 2}]}
  """
  def new(draw) do
    cube_texts = String.split(draw, ",", trim: true)
    cubes = Enum.map(cube_texts, &Snow.Game.Cube.new/1)
    %__MODULE__{cubes: cubes}
  end
end

defimpl Inspect, for: Snow.Game.Draw do
  def inspect(draw, _opts) do
    cubes_description =
      draw.cubes
      |> Enum.map(fn cube ->
        "#{cube.number} #{cube.color}"
      end)
      |> Enum.join(", ")

    "Draw! #{cubes_description}"
  end
end
