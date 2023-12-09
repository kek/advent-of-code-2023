defmodule Snow.Oasis do
  import Enum

  def spacings([a | [b | _] = r]) do
    [b - a | spacings(r)]
  end

  def spacings(_) do
    []
  end

  def next(line) do
    if all?(line, &(&1 == 0)) do
      0
    else
      below = line |> spacings()
      (line |> reverse() |> hd()) + next(below)
    end
  end

  def solution(lines) do
    lines
    |> map(&next/1)
    |> sum()
  end
end
