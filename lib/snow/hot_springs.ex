defmodule Snow.HotSprings do
  use Nebulex.Caching

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, groups] = String.split(line, " ")
      groups = String.split(groups, ",") |> Enum.map(&String.to_integer/1)
      {springs, groups}
    end)
  end

  @spec condition_match(pattern :: String.t(), springs :: String.t()) :: boolean()
  def condition_match("", ""), do: true

  def condition_match(<<a::binary-size(1)>> <> pattern, <<a::binary-size(1)>> <> springs),
    do: condition_match(pattern, springs)

  def condition_match("?" <> pattern, <<_::binary-size(1)>> <> springs),
    do: condition_match(pattern, springs)

  def condition_match(_, _), do: false

  @doc """
  Matches a string to a list of groups.

  ### Examples

  iex> import Snow.HotSprings
  iex> group_match([1,1,3], ".#.#.###")
  true
  """
  @spec group_match(pattern :: list(integer()), springs :: String.t()) :: boolean()
  def group_match(pattern, springs) do
    actual_groups = String.split(springs, ".", trim: true) |> Enum.map(&String.length/1)
    # IO.inspect(actual_groups, label: "actual groups for #{inspect(springs)}")
    pattern == actual_groups
  end

  @doc """
  Returns all combos of length n of items.

  ### Examples
  iex> import Snow.HotSprings
  iex> combos(1)
  ["#", "."]
  iex> combos(2)
  ["##", "#.", ".#", ".."]
  """
  @decorate cacheable(cache: Snow.Cache, key: {:combos, n})
  def combos(n) do
    combos_l(n) |> Enum.map(&Enum.join/1)
  end

  def combos_l(0) do
    [[]]
  end

  def combos_l(n) do
    # IO.inspect("You can do anything with zombocombos #{n}")
    # for x <- list, y <- shuffle(list, i-1), do: [x|y]

    for s <- ["#", "."], t <- combos_l(n - 1), do: [s | t]
  end
end
