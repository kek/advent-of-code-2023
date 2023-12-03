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
      adjacents = Snow.Engine.PartNumber.adjacent(part_number, symbols)

      (adjacents != [])
      |> tap(fn b ->
        if b do
          IO.puts("Part #{part_number.id} is adjacent to #{inspect(adjacents)}")
        end
      end)
    end)
    |> Enum.map(fn part_number ->
      part_number.id
    end)
    |> Enum.sum()
  end
end
