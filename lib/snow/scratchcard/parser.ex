defmodule Snow.Scratchcard.Parser do
  import NimbleParsec

  defparsec(
    :scratchcard,
    choice([
      ignore(string("\n")),
      ignore(string("\r")),
      ignore(string(" "))
    ])
    |> repeat()
  )
end
