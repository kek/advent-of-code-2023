defmodule Snow.Days.Day8Test do
  use ExUnit.Case
  doctest Snow.Wasteland

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

  test "Common lowest stop for all items in example" do
    assert Snow.Wasteland.try_to_find_solution(@example3, 99999) == {:ok, 6}
  end

  test "Common lowest stop for all items in example - new algorithm" do
    assert Snow.Wasteland.solution_by_ring_length(@example3) == 6
  end

  test "Common lowest stop for all items in real data - new algorithm" do
    assert Snow.Wasteland.solution_by_ring_length(@real_input) == 11_678_319_315_857
  end

  test "Stops for a particular item" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@example3)
    instructions = Stream.cycle(instructions)

    assert Snow.Wasteland.stops_for(instructions, 10, "11A", network) ==
             MapSet.new([2, 4, 6, 8, 10])

    assert Snow.Wasteland.stops_for(instructions, 10, "22A", network) ==
             MapSet.new([3, 6, 9])
  end

  test "Stops for all items in real data" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@real_input)

    instructions = Stream.cycle(instructions)
    max_steps = 100_000

    assert Snow.Wasteland.stops_for(instructions, max_steps, "VNA", network) ==
             MapSet.new([15871, 31742, 47613, 63484, 79355, 95226])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "QJA", network) ==
             MapSet.new([14257, 28514, 42771, 57028, 71285, 85542, 99799])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "JPA", network) ==
             MapSet.new([11567, 23134, 34701, 46268, 57835, 69402, 80969, 92536])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "AAA", network) ==
             MapSet.new([21251, 42502, 63753, 85004])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "DPA", network) ==
             MapSet.new([16409, 32818, 49227, 65636, 82045, 98454])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "DBA", network) ==
             MapSet.new([18023, 36046, 54069, 72092, 90115])
  end

  test "Common lowest stop for all items in real data - try to find by brute force" do
    assert Snow.Wasteland.try_to_find_solution(@real_input, 200_000) ==
             {:error, "No solution found"}
  end
end
