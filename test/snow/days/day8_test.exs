defmodule Snow.Days.Day8Test do
  use ExUnit.Case

  @example """
  RL

  AAA = (BBB, CCC)
  BBB = (DDD, EEE)
  CCC = (ZZZ, GGG)
  DDD = (DDD, DDD)
  EEE = (EEE, EEE)
  GGG = (GGG, GGG)
  ZZZ = (ZZZ, ZZZ)
  """

  @example2 """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

  @real_input File.read!("priv/input/Day 8 input.txt")

  test "Read the file" do
    assert Snow.Wasteland.Parser.read(@example) ==
             {[:right, :left],
              %{
                "AAA" => {"BBB", "CCC"},
                "BBB" => {"DDD", "EEE"},
                "CCC" => {"ZZZ", "GGG"},
                "DDD" => {"DDD", "DDD"},
                "EEE" => {"EEE", "EEE"},
                "GGG" => {"GGG", "GGG"},
                "ZZZ" => {"ZZZ", "ZZZ"}
              }}
  end

  test "Path" do
    assert Snow.Wasteland.path([:right], [:right], "AAA", "ZZZ", %{"AAA" => {"BBB", "ZZZ"}}) == [
             "ZZZ"
           ]

    assert Snow.Wasteland.path([:right], [:right], "AAA", "ZZZ", %{
             "AAA" => {"BBB", "CCC"},
             "CCC" => {"AAA", "ZZZ"}
           }) == [
             "CCC",
             "ZZZ"
           ]
  end

  test "Find the number of steps from AAA to ZZZ for example" do
    {instructions, network} = Snow.Wasteland.Parser.read(@example)

    assert Snow.Wasteland.path(instructions, instructions, "AAA", "ZZZ", network) == [
             "CCC",
             "ZZZ"
           ]
  end

  test "Find the number of steps from AAA to ZZZ for example 2" do
    {instructions, network} = Snow.Wasteland.Parser.read(@example2)

    assert Snow.Wasteland.path(instructions, instructions, "AAA", "ZZZ", network) == [
             "BBB",
             "AAA",
             "BBB",
             "AAA",
             "BBB",
             "ZZZ"
           ]
  end

  test "Find the number of steps from AAA to ZZZ for real input" do
    {instructions, network} = Snow.Wasteland.Parser.read(@real_input)

    assert Enum.count(Snow.Wasteland.path(instructions, instructions, "AAA", "ZZZ", network)) ==
             21251
  end
end
