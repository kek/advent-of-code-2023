defmodule Snow.Game do
  defstruct name: "", draws: []

  @doc """
  Creates a new game from a string.

  ## Examples

      iex> Snow.Game.new("Game 1: 1 blue")
      %Snow.Game{name: "Game 1", draws: [%Snow.Game.Draw{cubes: [%Snow.Game.Cube{color: :blue, number: 1}]}]}
  """
  def new(game) do
    [name, many_draws] = String.split(game, ":", trim: true)
    draws_text = String.split(many_draws, ";", trim: true)
    draws = Enum.map(draws_text, &Snow.Game.Draw.new/1)
    %__MODULE__{name: name, draws: draws}
  end

  def minimal_bag_for_game(game) do
    Snow.Game.Bag.sum_game(game)
  end
end

defimpl Inspect, for: Snow.Game do
  def inspect(game, _opts) do
    draws_description =
      game.draws |> Enum.map(&inspect/1) |> Enum.join(" / ")

    "#{game.name}! #{draws_description}"
  end
end
