defmodule Snow.Game.BagTest do
  use ExUnit.Case

  test "sum cubes" do
    assert Snow.Game.Bag.sum_cubes([
             %Snow.Game.Cube{color: :blue, number: 1},
             %Snow.Game.Cube{color: :red, number: 2},
             %Snow.Game.Cube{color: :red, number: 3},
             %Snow.Game.Cube{color: :green, number: 3}
           ]) ==
             %Snow.Game.Bag{blue: 1, green: 3, red: 3}
  end

  test "sum draws" do
    assert Snow.Game.Bag.sum_draws([
             %Snow.Game.Draw{
               cubes: [
                 %Snow.Game.Cube{color: :blue, number: 1},
                 %Snow.Game.Cube{color: :red, number: 2},
                 %Snow.Game.Cube{color: :green, number: 3}
               ]
             },
             %Snow.Game.Draw{
               cubes: [
                 %Snow.Game.Cube{color: :green, number: 3}
               ]
             }
           ]) ==
             %Snow.Game.Bag{blue: 1, green: 3, red: 2}
  end

  test "sum game" do
    assert Snow.Game.Bag.sum_game(%Snow.Game{
             draws: [
               %Snow.Game.Draw{
                 cubes: [
                   %Snow.Game.Cube{color: :blue, number: 1},
                   %Snow.Game.Cube{color: :red, number: 2},
                   %Snow.Game.Cube{color: :green, number: 3}
                 ]
               },
               %Snow.Game.Draw{
                 cubes: [
                   %Snow.Game.Cube{color: :green, number: 3}
                 ]
               },
               %Snow.Game.Draw{
                 cubes: [
                   %Snow.Game.Cube{color: :blue, number: 1},
                   %Snow.Game.Cube{color: :red, number: 2},
                   %Snow.Game.Cube{color: :green, number: 3}
                 ]
               },
               %Snow.Game.Draw{
                 cubes: [
                   %Snow.Game.Cube{color: :green, number: 1}
                 ]
               }
             ]
           }) ==
             %Snow.Game.Bag{blue: 1, green: 3, red: 2}
  end
end
