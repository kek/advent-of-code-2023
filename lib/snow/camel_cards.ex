defmodule Snow.CamelCards do
  def compare(left, right) do
    lg = group(left)
    rg = group(right)

    cond do
      Enum.count(lg) < Enum.count(rg) ->
        false

      Enum.count(lg) > Enum.count(rg) ->
        true

      Enum.count(lg) == Enum.count(rg) ->
        case {lg, rg} do
          {[{_, 3}, {_, 1}, {_, 1}], [{_, 2}, {_, 2}, {_, 1}]} -> false
          {[{_, 2}, {_, 2}, {_, 1}], [{_, 3}, {_, 1}, {_, 1}]} -> true
          {[{_, 4}, {_, 1}], [{_, 3}, {_, 2}]} -> false
          {[{_, 3}, {_, 2}], [{_, 4}, {_, 1}]} -> true
          {_, _} -> value_compare1(left, right)
        end

        # IO.inspect({lg, rg}, label: "Comparing same number of combos")
        # IO.inspect({sort(left), sort(right)}, charlists: :as_lists)
    end
  end

  # defp value_compare([{card1, count} | t1], [{card2, count} | t2]) when card1 == card2,
  #   do: value_compare(t1, t2)

  # defp value_compare([{card1, count} | _], [{card2, count} | _]) when card1 < card2, do: true
  # defp value_compare([{card1, count} | _], [{card2, count} | _]) when card1 > card2, do: false

  defp value_compare1([card1 | t1], [card2 | t2]) when card1 == card2,
    do: value_compare1(t1, t2)

  defp value_compare1([card1 | _], [card2 | _]) when card1 < card2, do: true
  defp value_compare1([card1 | _], [card2 | _]) when card1 > card2, do: false

  defp group(hand) do
    hand
    |> sort()
    |> Enum.group_by(& &1)
    |> Enum.map(fn {key, value} -> {key, Enum.count(value)} end)
    |> Enum.sort_by(fn {_card, count} -> count end)
    |> Enum.reverse()
  end

  defp sort(hand) do
    hand |> Enum.sort() |> Enum.reverse()
  end

  def render_hand(cards) do
    Enum.map(cards, fn
      n when n in 1..9 -> Integer.to_string(n)
      10 -> "T"
      11 -> "J"
      12 -> "Q"
      13 -> "K"
      14 -> "A"
    end)
    |> Enum.join()
  end

  def render_hands(hands) do
    "(" <>
      (Enum.map(hands, &render_hand/1)
       |> Enum.join(", ")) <> ")"
  end
end
