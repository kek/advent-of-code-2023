defmodule Snow.Engine do
  @doc """
  Engine schematic symbol is anything except number or dot.

  ## Examples

      iex> String.match?("a", Snow.Engine.schematic_symbol)
      true
      iex> String.match?("1", Snow.Engine.schematic_symbol)
      false
      iex> String.match?(".", Snow.Engine.schematic_symbol)
      false
  """
  def schematic_symbol, do: ~r/[^\.0-9]/

  @doc """
  Engine part number is a number.

  ## Examples

      iex> String.match?("1", Snow.Engine.part_number)
      true
      iex> String.match?("123", Snow.Engine.part_number)
      true
      iex> String.match?(".", Snow.Engine.part_number)
      false
      iex> Regex.split(Snow.Engine.part_number, "...1...", include_capture: true)
      ["...", "1", "..."]
  """
  def part_number, do: ~r/[0-9]+/
end
