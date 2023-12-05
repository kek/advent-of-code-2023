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
    wins = wins(card)

    score(wins) + pile_worth(rest)
  end

  defp score(x) do
    case x do
      0 -> 0
      something -> Integer.pow(2, something - 1)
    end
  end

  def win_more(%{id: id} = root, deck) do
    case wins(root) do
      0 ->
        []

      score ->
        (id + 1)..(id + 1 + score - 1)
        |> Enum.map(&get_card_by_id(&1, deck))
        |> Enum.map(fn won_card ->
          Map.put_new(won_card, :id, id)
        end)
        |> Enum.flat_map(fn won_card ->
          [root | win_more(won_card, deck)]
        end)
    end
  end

  defp wins(card) do
    MapSet.intersection(card.left, card.right) |> MapSet.size()
  end

  defp get_card_by_id(id, deck) do
    Enum.find(deck, :not_found, &(&1.id == id))
    |> tap(fn found? ->
      if found? == :not_found do
        raise "Card ID not found: #{inspect(id)}"
      end
    end)
  end
end
