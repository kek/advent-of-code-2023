defmodule Snow.Game.Bag do
  defstruct red: 0, green: 0, blue: 0

  @doc """
  Create a new bag with cubes.

  ## Examples

      iex> Snow.Game.Bag.new(red: 1, green: 3, blue: 2)
      %Snow.Game.Bag{blue: 2, green: 3, red: 1}
  """
  def new(colors) do
    %__MODULE__{}
    |> Map.merge(Map.new(colors))
  end

  def sum_cubes(cubes) do
    Enum.reduce(cubes, %__MODULE__{}, fn cube, bag ->
      Map.update(bag, cube.color, cube.number, &(&1 + cube.number))
    end)
  end

  def sum_draws(draws) do
    Enum.flat_map(draws, & &1.cubes)
    |> sum_cubes
  end

  def sum_rounds(rounds) do
    Enum.flat_map(rounds, & &1.draws)
    |> sum_draws
  end

  def sum_game(game) do
    game.rounds
    |> sum_rounds
  end

  @doc """
  Is this bag a subset of the other bag?

  ## Examples

      iex> Snow.Game.Bag.is_subset?(%Snow.Game.Bag{red: 1, green: 2}, %Snow.Game.Bag{red: 2, green: 3})
      true
      iex> Snow.Game.Bag.is_subset?(%Snow.Game.Bag{red: 1, green: 2}, %Snow.Game.Bag{red: 1, green: 1})
      false
  """
  def is_subset?(bag, other) do
    Map.keys(bag)
    |> Enum.all?(fn color ->
      Map.get(bag, color) <= Map.get(other, color)
    end)
  end
end
