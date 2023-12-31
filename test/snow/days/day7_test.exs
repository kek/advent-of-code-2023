defmodule Snow.Days.Day7Test do
  use ExUnit.Case

  alias Snow.CamelCards

  @example """
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
  """

  @real_data File.read!("priv/input/Day 7 input.txt")

  defp hand(hand_string) do
    case Snow.CamelCards.Parser.hands_list(hand_string <> " 0\n") do
      {:ok, [round: [hand: hand, bid: _]], _, _, _, _} -> hand
      {:error, _, _, _, _, _} -> raise "Invalid hand #{hand_string}"
    end
  end

  defp assert_order(hands, order, joking? \\ false) do
    actual = Enum.sort(Enum.map(hands, &hand/1), fn l, r -> CamelCards.compare(l, r, joking?) end)
    expected = Enum.map(order, &hand/1)

    if actual == expected do
      :ok
    else
      raise ExUnit.AssertionError,
        message:
          "Expected #{CamelCards.render_hands(expected)},\n" <>
            "     got #{CamelCards.render_hands(actual)}"
    end
  end

  test "examples" do
    # 32T3K is the only one pair and the other hands are all
    # a stronger type, so it gets rank 1.
    assert_order(["32T3K", "KTJJT"], ["32T3K", "KTJJT"])
    assert_order(["KTJJT", "32T3K"], ["32T3K", "KTJJT"])
    # KK677 and KTJJT are both two pair. Their first cards both
    # have the same label, but the second card of KK677 is stronger
    # (K vs T), so KTJJT gets rank 2 and KK677 gets rank 3.
    assert_order(["KTJJT", "KK677"], ["KTJJT", "KK677"])
    assert_order(["KK677", "KTJJT"], ["KTJJT", "KK677"])
    # T55J5 and QQQJA are both three of a kind. QQQJA has a stronger
    # first card, so it gets rank 5 and T55J5 gets rank 4.

    # 32T3K < KTJJT < KK677 < T55J5 < QQQJA

    assert_order(
      ["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"],
      ["32T3K", "KTJJT", "KK677", "T55J5", "QQQJA"]
    )

    assert_order(
      ["12345", "45678", "2345A", "12222", "22333", "T55J5", "QQQJA", "32T3K", "KK677", "KTJJT"],
      ["12345", "2345A", "45678", "32T3K", "KTJJT", "KK677", "T55J5", "QQQJA", "22333", "12222"]
    )

    assert_order(
      ["77888", "77788"],
      ["77788", "77888"]
    )

    assert_order(["1", "2"], ["1", "2"])

    {:ok, example_hands_and_bids, _, _, _, _} = Snow.CamelCards.Parser.hands_list(@example)

    expected_order = [
      hand("32T3K"),
      hand("KTJJT"),
      hand("KK677"),
      hand("T55J5"),
      hand("QQQJA")
    ]

    assert example_hands =
             example_hands_and_bids
             |> Enum.map(fn
               {:round, [hand: hand, bid: _]} -> hand
             end)

    assert Enum.sort(example_hands, &CamelCards.compare/2) == expected_order
  end

  def cleanup([]), do: []

  def cleanup([{:round, [hand: hand, bid: [bid]]} | t]), do: [{hand, bid} | cleanup(t)]

  def ranking(input, joking? \\ false) do
    {:ok, hands_and_bids, _, _, _, _} = Snow.CamelCards.Parser.hands_list(input)

    hands_and_bids
    |> cleanup
    |> Enum.sort(fn {l, _}, {r, _} ->
      Snow.CamelCards.compare(l, r, joking?)
    end)
  end

  def score(ranking) do
    ranks = 1..Enum.count(ranking)

    Enum.zip([ranks, ranking])
    |> Enum.map(fn {rank, {_, bid}} -> rank * bid end)
    |> Enum.sum()
  end

  test "write to file" do
    file = File.open!("priv/day7-sorted.txt", [:write])

    Enum.each(ranking(@real_data), fn {hand, _bid} ->
      IO.write(file, "#{Snow.CamelCards.render_hand(Enum.sort(hand) |> Enum.reverse())}\n")
    end)

    File.close(file)
  end

  test "real data part one" do
    assert score(ranking(@real_data)) == 246_424_613
  end

  test "example part one" do
    assert score(ranking(@example)) == 6440
  end

  test "example part two" do
    assert_order(
      ["32T3K", "T55J5", "KK677", "KTJJT", "QQQJA"],
      ["32T3K", "KK677", "T55J5", "QQQJA", "KTJJT"],
      true
    )

    assert score(ranking(@example, true)) == 5905
  end

  test "real part two" do
    assert score(ranking(@real_data, true)) == 248_256_639
  end
end
