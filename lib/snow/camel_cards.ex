defmodule Snow.CamelCards do
  def joke([{x, 4}, {11, 1}]), do: [{x, 5}]
  def joke([{x, 3}, {11, 2}]), do: [{x, 5}]
  def joke([{11, 3}, {x, 1}]), do: [{x, 5}]
  def joke([{11, 4}, {x, 1}]), do: [{x, 5}]
  def joke([{11, 3}, {x, 2}]), do: [{x, 5}]
  def joke([{11, 3}, {x, 1}, y]), do: [{x, 4}, y]
  def joke([{11, 5}]), do: [{11, 5}]
  def joke([{11, 2}, {x, 2}, y]), do: [{x, 4}, y]
  def joke([{x, 2}, {y, 2}, y]), do: [{x, 4}, y]
  def joke([{x, 3}, {11, 1}, y]), do: [{x, 4}, y]
  def joke([{x, 3}, y, {11, 1}]), do: [{x, 4}, y]
  def joke([{x, 2}, {11, 1}, y, z]), do: [{x, 3}, y, z]
  def joke([{x, 2}, y, {11, 1}, z]), do: [{x, 3}, y, z]
  # Should not matter which to pick:
  def joke([{x, 2}, {y, 2}, {11, 1}]), do: [{x, 3}, {y, 2}]
  def joke([{a, 1}, b, {11, 1}, c, d]), do: [{a, 2}, b, c, d]
  def joke([{a, 1}, b, c, {11, 1}, d]), do: [{a, 2}, b, c, d]
  def joke([{a, 1}, {11, 1}, b, c, d]), do: [{a, 2}, b, c, d]
  def joke([{11, 1}, {a, 1}, b, c, d]), do: [{a, 2}, b, c, d]
  def joke([{a, 2}, {11, 2}, b]), do: [{a, 4}, b]
  def joke([{11, 2}, {a, 1}, b, c]), do: [{a, 3}, b, c]
  def joke([{a, 2}, b, c, {11, 1}]), do: [{a, 3}, b, c]

  def joke([{a, _}, {b, _}, {c, _}, {d, _}, {e, _}] = hand)
      when a != 11 and b != 11 and c != 11 and d != 11 and e != 11,
      do: hand

  def joke([{a, _}, {b, _}, {c, _}, {d, _}] = hand)
      when a != 11 and b != 11 and c != 11 and d != 11,
      do: hand

  def joke([{a, _}, {b, _}, {c, _}] = hand)
      when a != 11 and b != 11 and c != 11,
      do: hand

  def joke([{a, _}, {b, _}] = hand)
      when a != 11 and b != 11,
      do: hand

  # XXJJY
  # def joke(x), do: x

  def compare(left, right, joking? \\ false) do
    lg = group(left)
    rg = group(right)

    {lg, left, rg, right} =
      if joking? do
        left =
          Enum.map(left, fn item ->
            if item == 11, do: 0, else: item
          end)

        right =
          Enum.map(right, fn item ->
            if item == 11, do: 0, else: item
          end)

        lg = joke(lg)
        rg = joke(rg)

        {lg, left, rg, right}
      else
        {lg, left, rg, right}
      end

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
