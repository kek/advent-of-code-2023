defmodule Snow.CamelCards.Parser do
  import NimbleParsec

  def card_value(?T), do: 10
  def card_value(?J), do: 11
  def card_value(?Q), do: 12
  def card_value(?K), do: 13
  def card_value(?A), do: 14
  def card_value(number) when number in 1..9, do: number

  defparsec(
    :hands_list,
    empty()
    |> times(
      tag(
        tag(
          times(
            choice([
              integer(1),
              utf8_char([?T]),
              utf8_char([?J]),
              utf8_char([?Q]),
              utf8_char([?K]),
              utf8_char([?A])
            ])
            |> map(:card_value),
            min: 1
          ),
          :hand
        )
        |> ignore(string(" "))
        |> tag(integer(min: 1), :bid)
        |> ignore(string("\n")),
        :round
      ),
      min: 1
    )
  )
end
