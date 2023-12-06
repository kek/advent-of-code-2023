defmodule Snow.Days.Day5Test do
  use ExUnit.Case, async: false

  @example """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  @real_input File.read!("priv/input/Day 5 input.txt")

  defp lowest(almanac, seed_ranges) do
    Snow.Almanac.location_for_seed(almanac, seed_ranges)
    |> Enum.sort()
    |> hd
  end

  defp as_seed_ranges(seeds) do
    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [begin, length] -> begin..(begin + length - 1) end)
    |> List.flatten()
  end

  defp as_single_seeds(seeds) do
    Enum.map(seeds, &(&1..&1))
  end

  defp parse(input) do
    {:ok, parsed, _, _, _, _} = Snow.Almanac.Parser.text(input)
    parsed
  end

  defp part_one(input) do
    {seeds, almanac} =
      input
      |> parse()
      |> Snow.Almanac.Parser.transform()

    lowest(almanac, as_single_seeds(seeds))
  end

  defp part_two(input) do
    {seeds, almanac} =
      input
      |> parse()
      |> Snow.Almanac.Parser.transform()

    lowest(almanac, as_seed_ranges(seeds))
  end

  test "The example" do
    assert part_one(@example) == 35..35
  end

  test "The example part 2" do
    # Fel - ska vara 46..x
    assert part_two(@example) == 56..59
  end

  test "The real data" do
    assert part_one(@real_input) == 389_056_265..389_056_265
    assert part_two(@real_input) == 137_516_820..170_926_000
  end
end
