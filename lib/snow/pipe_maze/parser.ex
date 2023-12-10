defmodule Snow.PipeMaze.Parser do
  import NimbleParsec

  defparsec(
    :diagram,
    times(
      wrap(
        times(
          ascii_char([?|, ?-, ?L, ?J, ?7, ?F, ?., ?S]),
          min: 1
        )
      )
      |> ignore(string("\n")),
      min: 1
    )
    |> eos()
  )
end
