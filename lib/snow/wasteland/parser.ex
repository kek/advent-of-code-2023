defmodule Snow.Wasteland.Parser do
  import NimbleParsec

  def transform_instructions([]), do: []
  def transform_instructions(["L" | t]), do: [:left | transform_instructions(t)]
  def transform_instructions(["R" | t]), do: [:right | transform_instructions(t)]
  def transform_node([node, left, right]), do: %{node => {left, right}}

  def collect_network(nodes) do
    nodes
    |> Enum.reduce(&Map.merge/2)
  end

  defparsec(
    :roadmap,
    empty()
    |> map(
      wrap(
        choice([
          string("R"),
          string("L")
        ])
        |> times(min: 1)
      ),
      :transform_instructions
    )
    |> ignore(string("\n\n"))
    |> map(
      wrap(
        times(
          wrap(
            utf8_string([?A..?Z, ?0..?9], 3)
            |> ignore(string(" = "))
            |> ignore(string("("))
            |> utf8_string([?A..?Z, ?0..?9], 3)
            |> ignore(string(", "))
            |> utf8_string([?A..?Z, ?0..?9], 3)
            |> ignore(string(")"))
            |> ignore(string("\n"))
          )
          |> map(:transform_node),
          min: 1
        )
      ),
      :collect_network
    )
  )

  def read(input) do
    {:ok, [instructions, network], _, _, _, _} = roadmap(input)
    {instructions, network}
  end
end
