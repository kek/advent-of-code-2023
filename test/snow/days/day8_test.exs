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
    instructions = Stream.cycle(instructions)
    first_instructions = Enum.take(instructions, 10)

    assert Snow.Wasteland.stops_for(first_instructions, "11A", network) ==
             MapSet.new([1, 3, 5, 7, 9])

    assert Snow.Wasteland.stops_for(first_instructions, "22A", network) == MapSet.new([2, 5, 8])
  end

  # test "Stops for all items in example" do
  #   {instructions, network} = Snow.Wasteland.ParserMulti.read(@example3)

  #   instructions = Stream.cycle(instructions)
  #   first_instructions = Enum.take(instructions, 10)

  #   positions =
  #     Map.keys(elem(network, 0))
  #     |> Enum.filter(&String.ends_with?(&1, "A"))

  #   positions
  #   |> Enum.each(fn position ->
  #     IO.inspect(Snow.Wasteland.stops_for(first_instructions, position, network),
  #       label: "Stops for example item #{position}"
  #     )
  #   end)
  # end

  test "Stops for all items in real data" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@real_input)

    instructions = Stream.cycle(instructions)
    first_instructions = Enum.take(instructions, 100_000)

    assert Snow.Wasteland.stops_for(first_instructions, "VNA", network) ==
             MapSet.new([15870, 31741, 47612, 63483, 79354, 95225])

    assert Snow.Wasteland.stops_for(first_instructions, "QJA", network) ==
             MapSet.new([14256, 28513, 42770, 57027, 71284, 85541, 99798])

    assert Snow.Wasteland.stops_for(first_instructions, "JPA", network) ==
             MapSet.new([11566, 23133, 34700, 46267, 57834, 69401, 80968, 92535])

    assert Snow.Wasteland.stops_for(first_instructions, "AAA", network) ==
             MapSet.new([21250, 42501, 63752, 85003])

    assert Snow.Wasteland.stops_for(first_instructions, "DPA", network) ==
             MapSet.new([16408, 32817, 49226, 65635, 82044, 98453])

    assert Snow.Wasteland.stops_for(first_instructions, "DBA", network) ==
             MapSet.new([18022, 36045, 54068, 72091, 90114])
  end

  def solution(data, max_steps \\ 10_000_000) do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(data)

    instructions = Stream.cycle(instructions)
    first_instructions = Enum.take(instructions, max_steps)

    entrypoints =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    IO.puts("Calculating stops sets")

    stops_sets =
      Enum.map(entrypoints, &Snow.Wasteland.stops_for(first_instructions, &1, network))

    # IO.puts("Converting to sets")
    # stops_sets = Enum.map(stops_lists, &MapSet.new/1)
    IO.puts("Calculating intersections")
    common_stops_sets = Enum.reduce(stops_sets, &MapSet.intersection/2)

    IO.puts("Sorting")
    solution = (common_stops_sets |> Enum.sort() |> hd) + 1
    solution
  end

  test "Common lowest stop for all items in example" do
    assert solution(@example3) == 6
  end

  @tag timeout: :infinity
  @tag :skip
  test "Common lowest stop for all items in real data" do
    assert solution(@real_input) == -1
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
