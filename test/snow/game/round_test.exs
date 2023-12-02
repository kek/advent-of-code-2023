defmodule Snow.Game.RoundTest do
  use ExUnit.Case

  test "create round" do
    assert Snow.Game.Round.new("1 blue, 2 red; 3 green") == %Snow.Game.Round{
             draws: [
               %Snow.Game.Draw{
                 cubes: [
                   %Snow.Game.Cube{color: :blue, number: 1},
                   %Snow.Game.Cube{color: :red, number: 2}
                 ]
               },
               %Snow.Game.Draw{cubes: [%Snow.Game.Cube{color: :green, number: 3}]}
             ]
           }
  end
end
