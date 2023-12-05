defmodule Snow.Almanac do
  def location_for_seed(almanac, seed_range, debug \\ false) do
    seed_range
    |> get("seed-to-soil", almanac, debug)
    |> get("soil-to-fertilizer", almanac, debug)
    |> get("fertilizer-to-water", almanac, debug)
    |> get("water-to-light", almanac, debug)
    |> get("light-to-temperature", almanac, debug)
    |> get("temperature-to-humidity", almanac, debug)
    |> get("humidity-to-location", almanac, debug)
  end

  def get(range, map_name, almanac, debug \\ false) do
    if debug, do: IO.puts("Looking for #{inspect(range)} in #{map_name}")

    Map.get(almanac, map_name)
    |> Enum.find_value(range, fn {src, dst} ->
      if debug, do: IO.puts("#{map_name}: #{inspect(src)} -> #{inspect(dst)}")

      map_range(range, src, dst, debug)
    end)
    |> tap(fn result ->
      if debug,
        do: IO.puts("Result: Mapping #{map_name} for #{inspect(range)} -> #{inspect(result)}")
    end)
  end

  defp map_range(range, src, dst, debug) do
    if !Range.disjoint?(range, src) do
      if debug, do: IO.puts("Found #{inspect(range)} in it")
      diff = hd(Enum.take(dst, 1)) - hd(Enum.take(src, 1))
      Range.shift(range, diff)
    else
      if debug, do: IO.puts("Not found #{inspect(range)} here - defaulting")
      false
    end
  end
end
