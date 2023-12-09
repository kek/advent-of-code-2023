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

    assert Snow.Wasteland.stops_for(instructions, 10, "11A", network) ==
             MapSet.new([1, 3, 5, 7, 9])

    assert Snow.Wasteland.stops_for(instructions, 10, "22A", network) ==
             MapSet.new([2, 5, 8])
  end

  test "Stops for all items in real data" do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(@real_input)

    instructions = Stream.cycle(instructions)
    max_steps = 100_000

    assert Snow.Wasteland.stops_for(instructions, max_steps, "VNA", network) ==
             MapSet.new([15870, 31741, 47612, 63483, 79354, 95225])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "QJA", network) ==
             MapSet.new([14256, 28513, 42770, 57027, 71284, 85541, 99798])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "JPA", network) ==
             MapSet.new([11566, 23133, 34700, 46267, 57834, 69401, 80968, 92535])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "AAA", network) ==
             MapSet.new([21250, 42501, 63752, 85003])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "DPA", network) ==
             MapSet.new([16408, 32817, 49226, 65635, 82044, 98453])

    assert Snow.Wasteland.stops_for(instructions, max_steps, "DBA", network) ==
             MapSet.new([18022, 36045, 54068, 72091, 90114])
  end

  def consume(state, how_many) do
    receive do
      {i, set} ->
        state =
          case Map.get(state, i) do
            nil ->
              # IO.puts("Got first item for #{i}")
              Map.put(state, i, [set])

            items when length(items) == how_many - 1 ->
              # IO.puts("Got all items for #{i}")
              sets = [set | items]
              common_stops_sets = Enum.reduce(sets, &MapSet.intersection/2)

              # IO.puts("Sorting")

              common_stops_sets
              |> Enum.sort()
              |> Enum.take(1)
              |> case do
                [] -> IO.puts("No solution found for #{i}")
                [n] -> IO.puts("The solution is #{n + 1}")
              end

              Map.put(state, i, sets)

            items ->
              # IO.puts(
              #   "Got another item for #{i}, in addition to #{Enum.count(items)} previous items"
              # )

              Map.put(state, i, [set | items])
          end

        consume(state, how_many)
    end
  end

  def try_to_find_solution(data, max_steps \\ 100_000) do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(data)

    instructions = Stream.cycle(instructions)
    IO.puts("Taking first #{max_steps} instructions")

    entrypoints =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    IO.puts("Calculating stops sets")

    consumer = spawn(fn -> consume(%{}, Enum.count(entrypoints)) end)

    stops_sets =
      Enum.map(entrypoints, fn pos ->
        Task.async(fn ->
          Snow.Wasteland.stops_for(instructions, max_steps, pos, network, consumer)
        end)
      end)
      |> Enum.map(&Task.await(&1, :infinity))

    IO.puts("Calculating intersections")
    common_stops_sets = Enum.reduce(stops_sets, &MapSet.intersection/2)

    IO.puts("Sorting")

    common_stops_sets
    |> Enum.sort()
    |> Enum.take(1)
    |> case do
      [] -> {:error, "No solution found"}
      [n] -> {:ok, n + 1}
    end
  end

  test "Common lowest stop for all items in example" do
    assert try_to_find_solution(@example3) == {:ok, 6}
  end

  @tag timeout: :infinity
  test "Common lowest stop for all items in real data" do
    assert try_to_find_solution(@real_input, 10_000_000_000_000) == {:ok, 0}
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
