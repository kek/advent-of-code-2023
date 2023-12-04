defmodule Snow.Scratchcard do
  def from_parsed(cards) do
    Enum.map(cards, fn {:card, [id: [id], left: left, right: right]} ->
      %{id: id, left: MapSet.new(left), right: MapSet.new(right)}
    end)
  end

  def pile_worth([card]) do
    wins = MapSet.intersection(card.left, card.right) |> MapSet.size()

    case wins do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 4
      4 -> 8
      5 -> 16
      6 -> 32
      7 -> 64
      8 -> 128
      9 -> 256
      10 -> 512
    end
  end

  def pile_worth([card | rest]) do
    pile_worth([card]) + pile_worth(rest)
  end
end
