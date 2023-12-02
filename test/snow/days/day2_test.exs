defmodule Snow.Days.Day2Test do
  use ExUnit.Case

  @example """
           Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
           Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
           Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
           Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
           Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
           """
           |> String.split("\n", trim: true)

  @tag :skip
  test "minimal bag for game 1" do
    minimal_bag = %Snow.Game.Bag{blue: 3 + 6, green: 2 + 2, red: 4 + 1}
    game = Snow.Game.new(Enum.at(@example, 0))
    assert Snow.Game.minimal_bag_for_game(game) == minimal_bag
  end
end
