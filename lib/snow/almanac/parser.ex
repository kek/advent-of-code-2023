defmodule Snow.Almanac.Parser do
  import NimbleParsec

  map =
    times(
      integer(min: 1)
      |> optional(ignore(string(" "))),
      min: 1
    )
    |> tag(:map)
    |> ignore(string("\n"))

  defparsec(
    :almanac,
    ignore(string("seeds: "))
    |> concat(map)
    |> tag(:seeds)
    |> ignore(string("\n"))
    |> times(
      tag(utf8_string([?a..?z, ?-], min: 1) |> ignore(string(" map:\n")), :label)
      |> repeat(map)
      |> ignore(optional(string("\n"))),
      min: 1
    )
  )
end
