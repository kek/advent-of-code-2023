defmodule Snow.Days.Day3 do
  require Logger

  def part_one(input) do
    schematic = Snow.Engine.build(input)

    {symbols, parts} =
      Snow.Engine.split_schematic(schematic)

    parts
    |> Enum.filter(fn part_number ->
      adjacents = Snow.Engine.PartNumber.adjacent(part_number, symbols)

      adjacents != []
    end)
    |> Enum.map(fn part_number ->
      part_number.id
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    schematic = Snow.Engine.build(input)

    {symbols, parts} =
      Snow.Engine.split_schematic(schematic)

    Snow.Engine.Symbol.gears(symbols)
    |> Enum.map(fn symbol ->
      adjacents = Snow.Engine.Symbol.adjacent(symbol, parts)

      if Enum.count(adjacents) == 2 do
        [first, second] = Enum.map(adjacents, & &1.id)
        first * second
      else
        Logger.debug("Not 2 adjacents for #{inspect(symbol)}: #{inspect(adjacents)}")
        0
      end
    end)
    |> Enum.sum()
  end
end
