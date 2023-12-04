defmodule Snow.Scratchcard.Parser do
  import NimbleParsec

  defparsec(
    :scratchcard,
    tag(
      string("Card")
      |> ignore()
      |> ignore(repeat(string(" ")))
      |> concat(integer(min: 1) |> tag(:id))
      |> ignore(string(":"))
      |> ignore(repeat(string(" ")))
      |> tag(repeat(integer(min: 1) |> repeat(string(" ") |> ignore())), :left)
      |> ignore(string("|"))
      |> ignore(repeat(string(" ")))
      |> tag(repeat(integer(min: 1) |> repeat(string(" ") |> ignore())), :right)
      |> ignore(optional(string("\r")))
      |> ignore(string("\n")),
      :card
    )
    |> repeat()
  )
end
