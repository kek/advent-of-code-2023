defmodule Snow.PipeMaze.Diagram do
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
  )

  def parse(data) do
    {:ok, result, _, _, _, _} = data |> diagram
    result
  end

  def day10 do
    File.read!("priv/input/Day 10 input.txt") |> parse
  end
end
