defmodule Snow.Almanac do
  def location_for_seed(almanac, seed_range) do
    seed_range
    |> get("seed-to-soil", almanac)
    |> get("soil-to-fertilizer", almanac)
    |> get("fertilizer-to-water", almanac)
    |> get("water-to-light", almanac)
    |> get("light-to-temperature", almanac)
    |> get("temperature-to-humidity", almanac)
    |> get("humidity-to-location", almanac)
  end

  def get(range_to_find, map_name, almanac) do
    IO.puts("Looking for #{inspect(range_to_find)} in #{map_name}")

    Map.get(almanac, map_name)
    |> Enum.find_value(range_to_find, fn {src, dst} ->
      IO.puts("#{map_name}: #{inspect(src)} -> #{inspect(dst)}")

      if !Range.disjoint?(range_to_find, src) do
        IO.puts("Found #{inspect(range_to_find)} in it")
        dst
      else
        IO.puts("Not found #{inspect(range_to_find)} here - defaulting")
        false
      end
    end)
    |> tap(fn result ->
      IO.puts("Result: Mapping #{map_name} for #{inspect(range_to_find)} -> #{inspect(result)}")
    end)
  end
end
