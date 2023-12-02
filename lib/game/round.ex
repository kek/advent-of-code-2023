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
end
