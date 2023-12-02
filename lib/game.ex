defmodule Snow.Game do
  defstruct name: "", rounds: []

  @doc """
  Creates a new game from a string.

  ## Examples

      iex> Snow.Game.new("Game 1: 1 blue")
      %Snow.Game{name: "Game 1", rounds: [%Snow.Game.Round{draws: [%Snow.Game.Draw{cubes: [%Snow.Game.Cube{color: :blue, number: 1}]}]}]}
  """
  def new(game) do
    [name, round_text] = String.split(game, ":", trim: true)
    round_texts = String.split(round_text, ",", trim: true)
    rounds = Enum.map(round_texts, &Snow.Game.Round.new/1)
    %__MODULE__{name: name, rounds: rounds}
  end

  def minimal_bag_for_game(game) do
    Snow.Game.Bag.sum_game(game)
  end
end
