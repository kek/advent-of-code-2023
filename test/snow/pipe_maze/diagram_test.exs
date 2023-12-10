defmodule Snow.PipeMaze.DiagramTest do
  use ExUnit.Case
  import Snow.PipeMaze.Diagram

  test "connections" do
    diagram = first_example()
    starting_point = starting_point(diagram)
    assert connections(diagram, starting_point) == [{:e, {2, 1}}, {:s, {1, 2}}]
  end

  test "connections for diagram with noise" do
    diagram = first_example_with_junk()
    starting_point = starting_point(diagram)
    assert connections(diagram, starting_point) == [{:e, {2, 1}}, {:s, {1, 2}}]
  end
end
