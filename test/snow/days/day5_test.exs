defmodule Snow.Days.Day5Test do
  use ExUnit.Case, async: true

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

  test "The example" do
    {:ok, parsed, _, _, _, _} = Snow.Almanac.Parser.text(@example)
    almanac = Snow.Almanac.Parser.transform(parsed)

    assert lowest(almanac) == 35
  end

  test "The real data" do
    IO.puts("Gotta")
    {:ok, parsed, _, _, _, _} = Snow.Almanac.Parser.text(@real_input)
    almanac = Snow.Almanac.Parser.transform(parsed)
    IO.puts("Go fast")
    assert lowest(almanac) == 35
  end

  defp lowest(almanac) do
    seeds = almanac["seeds"]

    max_parallellism = div(Enum.count(seeds), 3)
    chunky = fn seed -> rem(seed, max_parallellism) end

    batches =
      seeds
      |> Enum.sort_by(chunky)
      |> Enum.chunk_by(chunky)

    batches
    |> Enum.map(fn batch ->
      Task.async(fn ->
        batch
        |> Enum.map(&Snow.Almanac.location_for_seed(almanac, &1))
      end)
    end)
    |> Enum.flat_map(&Task.await(&1, 60000))
    |> Enum.sort()
    |> hd
  end
end
