defmodule Snow.Almanac do
  def location_for_seed(almanac, seed) do
    seed
    |> get("seed-to-soil", almanac)
    |> get("soil-to-fertilizer", almanac)
    |> get("fertilizer-to-water", almanac)
    |> get("water-to-light", almanac)
    |> get("light-to-temperature", almanac)
    |> get("temperature-to-humidity", almanac)
    |> get("humidity-to-location", almanac)
  end

  def get(source, map_name, almanac) do
    map = Map.get(almanac, map_name)

    case Map.get(map, source) do
      nil ->
        # IO.puts("No mapping from #{source} in #{map_name}")
        source

      destination ->
        destination
    end
  end
end
