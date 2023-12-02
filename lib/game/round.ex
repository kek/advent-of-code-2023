defmodule Snow.Game.Round do
  defstruct draws: []

  @doc """
  Creates a new round from a string.
  """
  def new(round) do
    draw_texts = String.split(round, ";", trim: true)
    draws = Enum.map(draw_texts, &Snow.Game.Draw.new/1)
    %__MODULE__{draws: draws}
  end

  @doc """
  Sums the cubes in the round.
  """
  def sum(round) do
    Enum.flat_map(round.draws, &Snow.Game.Draw.sum/1)
  end
end
