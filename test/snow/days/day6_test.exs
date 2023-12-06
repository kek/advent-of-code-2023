defmodule Snow.Days.Day6Test do
  use ExUnit.Case

  test "part one" do
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

    # Time:      7  15   30
    # Distance:  9  40  200
    example = [{7, 9}, {15, 40}, {30, 200}]
    # Time:        57     72     69     92
    # Distance:   291   1172   1176   2026
    real = [{57, 291}, {72, 1172}, {69, 1176}, {92, 2026}]

    assert example |> Enum.map(ways_to_win) |> Enum.reduce(&Kernel.*/2) == 288
    assert real |> Enum.map(ways_to_win) |> Enum.reduce(&Kernel.*/2) == 160_816
  end

  test "part two" do
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

    example = [{71530, 940_200}]

    real = [{57_726_992, 291_117_211_762_026}]

    assert example |> Enum.map(ways_to_win) |> Enum.reduce(&Kernel.*/2) == 71503
    assert real |> Enum.map(ways_to_win) |> Enum.reduce(&Kernel.*/2) == 46_561_107
  end
end
