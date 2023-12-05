defmodule Snow.Almanac.RangeMap do
  @doc """
  Given a range and a map of ranges to ranges, find the range in the map that
  contains the given range, and return the mapped range.

  If the given range is not contained in any of the ranges in the map, return
  nil.

    ### Examples

    iex> get(1..1, {1..1, 2..2})
    2..2
    iex> get(1..1, {2..2, 3..3})
    nil
    iex> get(1..2, {1..3, 2..4})
    2..3
    iex> get(2..2, {1..3, 2..4})
    3..3
    iex> get(1..2, {2..4, 1..3})
    1..1
  """
  @spec get(Range.t(), {Range.t(), Range.t()}) :: Range.t()
  def get(range, {src, dst}) do
    if !Range.disjoint?(range, src) do
      range = intersection(range, src)
      {dst, _} = Range.split(dst, Range.size(range))
      diff = hd(Enum.take(range, 1)) - hd(Enum.take(src, 1))
      # IO.puts(diff)
      dst = Range.shift(dst, diff)

      dst
    end
  end

  @doc """
  Calculate the intersection between two ranges.
  Crop left range so that it fits inside right range.

    ### Examples

    iex> intersection(1..1, 1..1) # Same range
    1..1
    iex> intersection(1..1, 2..2) # Disjoint ranges
    :error
    iex> intersection(1..2, 1..3) # Left range fits inside right range
    1..2
    iex> intersection(1..2, 2..2) # Right range fits in left range
    2..2
    iex> intersection(1..2, 1..1) # Left range is bigger than right range
    1..1
    iex> intersection(1..2, 2..3) # Ranges have an intersection
    2..2
    # When they have intersection and are different sizes, crop to the junction
  """
  def intersection(left, right) do
    # diff = abs(hd(Enum.take(left, 1)) - hd(Enum.take(right, 1)))
    # IO.inspect(diff, label: "diff between #{inspect(left)} and #{inspect(right)}")
    # left
    if Range.disjoint?(left, right) do
      :error
    else
      left_begin = hd(Enum.take(left, 1))
      left_finish = left_begin + Range.size(left) - 1
      right_begin = hd(Enum.take(right, 1))
      right_finish = right_begin + Range.size(right) - 1
      begin = max(left_begin, right_begin)
      finish = min(left_finish, right_finish)
      begin..finish
    end
  end
end
