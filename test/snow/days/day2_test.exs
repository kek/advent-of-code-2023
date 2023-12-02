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

  test "minimal bag for game 1" do
    minimal_bag = %Snow.Game.Bag{blue: 3 + 6, green: 2 + 2, red: 4 + 1}
    game = Snow.Game.new(Enum.at(@example, 0))
    assert Snow.Game.minimal_bag_for_game(game) == minimal_bag
  end

  test "example for part one" do
    assert calculate_sum_of_minimum_set_of_cubes(@example) == 8
  end

  test "solution for part one" do
    input = File.read!("priv/input/Day 2.txt") |> String.split("\n", trim: true)
    assert calculate_sum_of_minimum_set_of_cubes(input) == 2239
  end

  defp calculate_sum_of_minimum_set_of_cubes(input) do
    required_bag = %Snow.Game.Bag{red: 12, green: 13, blue: 14}

    input
    |> Enum.map(fn text ->
      Snow.Game.new(text)
      |> IO.inspect()
    end)
    |> Enum.filter(fn game ->
      Enum.all?(game.draws, fn draw ->
        IO.inspect(draw, label: "draw")

        Snow.Game.Bag.is_subset?(Snow.Game.Bag.from_draw(draw), required_bag)
        |> IO.inspect(label: "is subset?")
      end)
    end)
    |> Enum.map(& &1.name)
    |> Enum.map(fn name ->
      [_, id] = String.split(name, " ")
      String.to_integer(id)
    end)
    |> Enum.sum()
  end

  test "example for part two" do
  end
end
