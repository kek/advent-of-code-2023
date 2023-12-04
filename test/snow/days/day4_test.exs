defmodule Snow.Days.Day4Test do
  use ExUnit.Case, async: true

  @real_input File.read!("priv/input/Day 4 input.txt")
  @example """
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
  """

  test "part 1" do
    {:ok, parsed, _, _, _, _} = Snow.Scratchcard.Parser.scratchcard(@example)

    assert (cards = Snow.Scratchcard.from_parsed(parsed)) == [
             %{
               id: 1,
               left: MapSet.new([17, 41, 48, 83, 86]),
               right: MapSet.new([6, 9, 17, 31, 48, 53, 83, 86])
             },
             %{
               id: 2,
               left: MapSet.new([13, 16, 20, 32, 61]),
               right: MapSet.new([17, 19, 24, 30, 32, 61, 68, 82])
             },
             %{
               id: 3,
               left: MapSet.new([1, 21, 44, 53, 59]),
               right: MapSet.new([1, 14, 16, 21, 63, 69, 72, 82])
             },
             %{
               id: 4,
               left: MapSet.new([41, 69, 73, 84, 92]),
               right: MapSet.new([5, 51, 54, 58, 59, 76, 83, 84])
             },
             %{
               id: 5,
               left: MapSet.new([26, 28, 32, 83, 87]),
               right: MapSet.new([12, 22, 30, 36, 70, 82, 88, 93])
             },
             %{
               id: 6,
               left: MapSet.new([13, 18, 31, 56, 72]),
               right: MapSet.new([10, 11, 23, 35, 36, 67, 74, 77])
             }
           ]

    assert Snow.Scratchcard.pile_worth([Enum.at(cards, 0)]) == 8
    assert Snow.Scratchcard.pile_worth([Enum.at(cards, 1)]) == 2
    assert Snow.Scratchcard.pile_worth([Enum.at(cards, 2)]) == 2
    assert Snow.Scratchcard.pile_worth([Enum.at(cards, 3)]) == 1
    assert Snow.Scratchcard.pile_worth([Enum.at(cards, 4)]) == 0
    assert Snow.Scratchcard.pile_worth([Enum.at(cards, 5)]) == 0

    assert Snow.Scratchcard.pile_worth(cards) == 13
  end

  test "real data" do
    {:ok, parsed, _, _, _, _} = Snow.Scratchcard.Parser.scratchcard(@real_input)
    cards = Snow.Scratchcard.from_parsed(parsed)
    assert Snow.Scratchcard.pile_worth(cards) == 18619
  end
end
