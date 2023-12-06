defmodule Snow.Days.Day6Test do
  use ExUnit.Case

  @my_input [{57, 291}, {72, 1172}, {69, 1176}, {92, 2026}]

  test "part one example" do
    distance = fn hold_time, race_duration ->
      travel_time = race_duration - hold_time
      speed = hold_time
      distance = speed * travel_time
      distance
    end

    ways_to_win = fn {race_duration, record_distance} ->
      0..race_duration
      |> Enum.count(fn hold_time ->
        distance.(hold_time, race_duration) > record_distance
      end)
    end

    # Time, record_distance
    races = [{7, 9}, {15, 40}, {30, 200}]
    assert races |> Enum.map(ways_to_win) |> Enum.reduce(&Kernel.*/2) == 288
  end

  test "part one real data" do
    distance = fn hold_time, race_duration ->
      travel_time = race_duration - hold_time
      speed = hold_time
      distance = speed * travel_time
      distance
    end

    ways_to_win = fn {race_duration, record_distance} ->
      0..race_duration
      |> Enum.count(fn hold_time ->
        distance.(hold_time, race_duration) > record_distance
      end)
    end

    # Time, record_distance
    races = @my_input
    assert races |> Enum.map(ways_to_win) |> Enum.reduce(&Kernel.*/2) == 160_816
  end
end
