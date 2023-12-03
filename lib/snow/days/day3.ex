defmodule Snow.Days.Day3 do
  def part_one(input) do
    if System.get_env("DEBUG") == "true", do: IO.puts("\n" <> input)
    schematic = Snow.Engine.build(input)

    {symbols, part_numbers} =
      Snow.Engine.split_schematic(schematic)

    part_numbers
    |> Enum.filter(fn part_number ->
      adjacents = Snow.Engine.PartNumber.adjacent(part_number, symbols)

      (adjacents != [])
      |> tap(fn b ->
        if System.get_env("DEBUG") == "true" && b do
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
