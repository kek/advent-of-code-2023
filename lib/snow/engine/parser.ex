defmodule Snow.Engine.Parser do
  import NimbleParsec

  part_number =
    integer(min: 1)
    |> tag(:part)
    |> post_traverse(:decorate)

  symbol =
    empty()
    |> ascii_char()
    |> tag(:symbol)
    |> post_traverse(:decorate)

  defparsec(
    :schematic,
    choice([
      ignore(string("\n")),
      ignore(string("\r")),
      ignore(string(".")),
      part_number,
      symbol
    ])
    |> repeat()
  )

  defp decorate(rest, args, context, line, offset) do
    item = to_item(line, offset, args)
    {rest, item |> List.wrap(), context}
  end

  defp to_item({row, col}, offset, data) do
    {row, col, offset, data}
  end
end
