defmodule Snow.Days.Day3 do
  def part_one(input) do
    IO.puts("\n" <> input)
    schematic = Snow.Engine.build(input)

    {symbols, part_numbers} =
      Enum.split_with(schematic, fn item ->
        item.__struct__ == Snow.Engine.Symbol
      end)

    part_numbers
    |> Enum.filter(fn part_number ->
      IO.inspect(part_number, label: "part_number")
      adjacents = Snow.Engine.PartNumber.adjacent(part_number, symbols)
      IO.inspect(adjacents, label: "adjacents")
      adjacents != []
    end)
    |> Enum.map(fn part_number ->
      part_number.id
    end)
    |> Enum.sum()
  end
end
