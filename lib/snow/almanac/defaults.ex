defmodule Snow.Almanac.Defaults do
  def decorate(ranges, [], defaults) do
    union(ranges, defaults)
  end

  def decorate(ranges, sources, [default]) do
    if subset?(sources, [default]) do
      union(ranges, difference(sources, default))
    end
  end

  def start(ranges) when is_list(ranges) do
    ranges
    |> Enum.map(& &1.first)
    |> Enum.min()
  end

  def start(range), do: range.first

  def stop(ranges) when is_list(ranges) do
    ranges
    |> Enum.map(& &1.last)
    |> Enum.min()
  end

  def stop(range), do: range.last

  @doc """
  Given two lists of ranges, return a list of ranges that is the union of the two lists.

    ### Examples

    iex> union([1..2], [3..4])
    [1..2, 3..4]
  """
  def union(ranges, defaults) do
    ranges ++ defaults
  end

  def subset?(left, right) do
    Enum.member?(left, hd(right))
  end

  @doc """
  Given two lists of ranges, return a list of ranges that is the difference of the two lists.

    ### Examples

    iex> difference([1..3], [])
    [1..3]
    iex> difference([], [1..3])
    [1..3]
    iex> difference([1..3], [2..2])
    [1..1, 3..3]
  """
  def difference(left, []), do: left
  def difference([], right), do: right

  def difference(left, right) do
    # for each item in right, remove elements from the left that are in the intersection.
    # do the reverse for the left.
    # the sum of these two is the difference.
    intersection =
      intersection(left, right)
      |> IO.inspect(label: "intersection of #{inspect(left)} and #{inspect(right)}}")

    left = left |> Enum.flat_map(&shrink_to_avoid(intersection, [&1]))
    right = right |> Enum.flat_map(&shrink_to_avoid(intersection, [&1]))
    union(left, right)
  end

  @doc """
  Intersection of two range sets.

  For everything in left, remove it if it doesn't exist in right.
  The result is the intersection.

    ### Examples

    iex> intersection([1..2], [2..2])
    [2..2]
  """
  def intersection(left, right) do
    left |> Enum.flat_map(&shrink_to_fit(right, &1))
  end

  @doc """
  Shrink the range to fit in a range set.

  Return empty list if not possible.

  Helper to intersection/2

    ### Examples

    iex> shrink_to_fit([1..2], 1..1)
    [1..1]
    iex> shrink_to_fit([1..2], 3..3)
    []
    iex> shrink_to_fit([1..2, 4..5], 3..3)
    []
    iex> shrink_to_fit([1..2, 4..5], 3..4)
    [4..4]
  """
  def shrink_to_fit(set, shrinkable) do
    if Enum.any?(set, fn member ->
         !Range.disjoint?(member, shrinkable)
       end) do
      shrink_to_fit!(set, shrinkable)
    else
      []
    end
  end

  defp shrink_to_fit!([], shrinkable), do: [shrinkable]

  defp shrink_to_fit!([obj | set], shrinkable) do
    if obj.first > shrinkable.last || obj.last < shrinkable.first do
      shrink_to_fit!(set, shrinkable)
    else
      shrink_to_fit!(set, max(obj.first, shrinkable.first)..min(obj.last, shrinkable.last))
    end
  end

  @doc """
  Shrink the set to avoid a range set.

    ### Examples

    iex> shrink_to_avoid([1..2], [3..3])
    [3..3]
    iex> shrink_to_avoid([1..1,3..3], [1..3])
    [2..2]
    iex> shrink_to_avoid([1..5], [2..4])
    []
  """

  def shrink_to_avoid([], me), do: me

  def shrink_to_avoid([other | set], we) when is_list(we) do
    we =
      we
      |> Enum.flat_map(fn me ->
        if Range.disjoint?(me, other) do
          [me]
        else
          cond do
            me.first >= other.first && me.last <= other.last ->
              []

            me.first < other.first && me.last > other.last ->
              [me.first..(other.first - 1), (other.last + 1)..me.last]

            true ->
              [max(other.last + 1, me.first)..min(other.first + 1, me.last)]
          end
        end
      end)

    shrink_to_avoid(set, we)
  end
end
