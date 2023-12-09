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

  test "Read the file - multi - part two" do
    assert Snow.Wasteland.ParserMulti.read(@example) ==
             {[:right, :left],
              {%{
                 "AAA" => "BBB",
                 "BBB" => "DDD",
                 "CCC" => "ZZZ",
                 "DDD" => "DDD",
                 "EEE" => "EEE",
                 "GGG" => "GGG",
                 "ZZZ" => "ZZZ"
               },
               %{
                 "AAA" => "CCC",
                 "BBB" => "EEE",
                 "CCC" => "GGG",
                 "DDD" => "DDD",
                 "EEE" => "EEE",
                 "GGG" => "GGG",
                 "ZZZ" => "ZZZ"
               }}}
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

  @example3 """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """

  test "Find the number of steps from ??A to ??Z for part 2 example" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@example3)

    from =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    assert Snow.Wasteland.path_multi(
             instructions,
             from,
             network
           ) ==
             6
  end

  test "Stops for a particular item" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@example3)

    IO.inspect(network)
    assert Snow.Wasteland.stops_for(instructions, "11A", network) == :"???"
  end

  test "Stops for all items in example" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@example3)

    positions =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    positions
    |> Enum.each(fn position ->
      IO.inspect(Snow.Wasteland.stops_for(instructions, position, network),
        label: "Stops for example item #{position}"
      )
    end)
  end

  test "Stops for all items in real data" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@real_input)

    positions =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    positions
    |> Enum.each(fn position ->
      IO.inspect(Snow.Wasteland.stops_for(instructions, position, network),
        label: "Stops for #{position}"
      )
    end)
  end

  @tag timeout: :infinity
  @tag :skip
  test "Find the number of steps from ??A to ??Z for part 2 real data" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@real_input)

    from =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    assert Snow.Wasteland.path_multi(instructions, from, network) ==
             -1
  end
end
