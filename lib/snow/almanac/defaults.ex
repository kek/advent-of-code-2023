defmodule Snow.Almanac.Defaults do
  alias Snow.Almanac.RangeSet

  def decorate(ranges, [], defaults) do
    RangeSet.union(ranges, defaults)
  end

  def decorate(ranges, sources, [default]) do
    if RangeSet.subset?(sources, [default]) do
      RangeSet.union(ranges, RangeSet.difference(sources, default))
    end
  end
end
