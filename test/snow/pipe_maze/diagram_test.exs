defmodule Snow.PipeMaze.DiagramTest do
  use ExUnit.Case
  import Snow.PipeMaze.Diagram

  test "connections" do
    diagram = first_example()
    starting_point = starting_point(diagram)
    assert connections(diagram, starting_point) == [{1, 2}, {2, 1}]
  end
end
