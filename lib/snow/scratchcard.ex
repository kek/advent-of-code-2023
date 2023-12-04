defmodule Snow.Scratchcard do
  def from_parsed(cards) do
    Enum.map(cards, fn {:card, [id: [id], left: left, right: right]} ->
      %{id: id, left: MapSet.new(left), right: MapSet.new(right)}
    end)
  end

  def pile_worth([]) do
    0
  end

  def pile_worth([card | rest]) do
    wins = MapSet.intersection(card.left, card.right) |> MapSet.size()

    case wins do
      0 -> 0
      something -> Integer.pow(2, something - 1)
    end + pile_worth(rest)
  end
end
