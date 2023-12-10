defmodule Snow.Days.Day10Test do
  use ExUnit.Case

  import Snow.PipeMaze.Diagram

  def solution(diagram) do
    starting_point = starting_point(diagram)
    the_loop = find_the_loop(diagram, starting_point)
    div(Enum.count(the_loop), 2)
  end

  test "examples" do
    assert solution(first_example()) == 4
    assert solution(first_example_with_junk()) == 4
    assert solution(more_complex_example()) == 8
  end

  test "real" do
    assert solution(day10()) == 6800
  end
end
