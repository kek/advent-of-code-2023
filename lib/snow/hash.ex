defmodule Snow.Hash do
  @moduledoc """
  Holiday ASCII String Helper algorithm
  """

  @doc """
  Compute the HASH of a string.

  ### Examples

  iex> import Snow.Hash
  iex> compute("H")
  200
  iex> compute("HA")
  153
  iex> compute("HAS")
  172
  iex> compute("HASH")
  52
  """
  def compute(s), do: compute(0, s)

  defp compute(n, ""), do: n

  defp compute(old, <<c::binary-size(1)>> <> tail) do
    [ascii] = String.to_charlist(c)
    current = ascii + old
    current = rem(current * 17, 256)
    compute(current, tail)
  end
end
