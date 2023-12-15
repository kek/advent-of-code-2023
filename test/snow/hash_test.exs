defmodule Snow.HashTest do
  use ExUnit.Case
  doctest Snow.Hash
  import Snow.Hash

  test "hashing a list of stuff" do
    input = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7" |> String.split(",")

    assert Enum.map(input, &compute/1) |> Enum.sum() == 1320
  end

  test "solution" do
    input = File.read!("priv/input/Day 15 input.txt") |> String.trim() |> String.split(",")

    assert Enum.map(input, &compute/1) |> Enum.sum() == 504_449
  end
end
