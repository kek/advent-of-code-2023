defmodule Snow.Almanac do
  def location_for_seed(almanac, seed_ranges) do
    seed_ranges
    |> fetch_with_default("seed-to-soil", almanac)
    |> fetch_with_default("soil-to-fertilizer", almanac)
    |> fetch_with_default("fertilizer-to-water", almanac)
    |> fetch_with_default("water-to-light", almanac)
    |> fetch_with_default("light-to-temperature", almanac)
    |> fetch_with_default("temperature-to-humidity", almanac)
    |> fetch_with_default("humidity-to-location", almanac)
  end

  def fetch_with_default(ranges, map_name, almanac) do
    fetch(ranges, map_name, almanac)
    |> decorate_with_defaults(ranges, map_name, almanac)
  end

  @doc """
  Given ranges, a map name and an almanac, fill out defaults in the ranges where there was no mapping found in the almanac.

    ### Examples

    iex> decorate_with_defaults([1..1, 2..2], [3..3], "seed-to-soil", %{"seed-to-soil" => [{1..1, 2..2}]})
    [1..1, 2..2, 3..3]
    iex> decorate_with_defaults([2..2], [1..1], "seed-to-soil", %{"seed-to-soil" => [{1..1, 2..2}]})
    [2..2]
  """
  def decorate_with_defaults(ranges, defaults, map_name, almanac) do
    mappings = almanac[map_name]
    sources = Enum.map(mappings, fn {src, _dst} -> src end)
    unmappable_defaults = Snow.Almanac.RangeSet.subtract(defaults, sources)
    ranges ++ unmappable_defaults
  end

  def fetch([], _, _), do: []

  def fetch([range | rest], map_name, almanac) do
    maps = Map.get(almanac, map_name)
    targets = Enum.flat_map(maps, &Snow.Almanac.RangeMap.get_list(range, &1))
    targets ++ fetch(rest, map_name, almanac)
  end
end
