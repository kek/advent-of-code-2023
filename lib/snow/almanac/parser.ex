defmodule Snow.Almanac.Parser do
  import NimbleParsec

  map =
    times(
      integer(min: 1)
      |> optional(ignore(string(" "))),
      # Maybe specify exactly 3
      min: 1
    )
    |> tag(:map)
    |> ignore(string("\n"))

  defparsec(
    :text,
    ignore(string("seeds: "))
    # The seed list is not really a map in semantics but can be parsed as one.
    |> concat(map)
    |> tag(:seeds)
    |> ignore(string("\n"))
    |> times(
      tag(
        utf8_string([?a..?z, ?-], min: 1)
        |> tag(:label)
        |> ignore(string(" map:\n"))
        |> repeat(map)
        |> ignore(optional(string("\n"))),
        :category
      ),
      min: 1
    )
  )

  def transform([{:seeds, [{:map, seeds}]} | maps]) do
    %{"seeds" => seeds} |> Map.merge(understand(maps))
  end

  defp understand([]), do: %{}

  defp understand([
         {:category, [{:label, [label]} | maps]} | rest
       ]) do
    %{label => understand_maps(maps)}
    |> Map.merge(understand(rest))
  end

  defp understand_maps([]) do
    []
  end

  defp understand_maps([{:map, [dst, src, length]} | rest]) do
    [{src..(src + length - 1), dst..(dst + length - 1)} | understand_maps(rest)]
  end
end
