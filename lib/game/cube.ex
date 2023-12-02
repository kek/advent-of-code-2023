defmodule Snow.Game.Cube do
  defstruct color: nil, number: 0

  @doc """
  Creates a new cube from a string.

  ## Examples

      iex> Snow.Game.Cube.new("1 blue")
      %Snow.Game.Cube{color: :blue, number: 1}
  """
  def new(cube) do
    [number, color] = String.split(cube, " ", trim: true)
    %__MODULE__{color: String.to_atom(color), number: String.to_integer(number)}
  end
end
