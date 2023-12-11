defmodule Snow.PipeMazeTest do
  use ExUnit.Case

  test "is_cell_white?" do
    diagram = Snow.PipeMaze.Diagram.first_example()

    visualization =
      diagram
      |> SnowWeb.PipeMazeController.image(:white)

    {:ok, {flooded, _}} = Image.Draw.flood(visualization, 0, 0, color: :blue, equal: true)
    Image.write(flooded, "test.png")
    assert SnowWeb.PipeMazeController.is_cell_white?(flooded, 2, 2)
  end
end
