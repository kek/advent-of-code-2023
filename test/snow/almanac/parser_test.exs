defmodule Snow.Almanac.ParserTest do
  use ExUnit.Case, async: true

  @example """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  test "Parsing the almanac" do
    assert Snow.Almanac.Parser.text(@example) == {
             :ok,
             [
               seeds: [map: [79, 14, 55, 13]],
               category: [
                 {:label, ["seed-to-soil"]},
                 {:map, [50, 98, 2]},
                 {:map, ~c"420"}
               ],
               category: [
                 {:label, ["soil-to-fertilizer"]},
                 {:map, [0, 15, 37]},
                 {:map, [37, 52, 2]},
                 {:map, [39, 0, 15]}
               ],
               category: [
                 {:label, ["fertilizer-to-water"]},
                 {:map, ~c"15\b"},
                 {:map, [0, 11, 42]},
                 {:map, [42, 0, 7]},
                 {:map, [57, 7, 4]}
               ],
               category: [
                 {:label, ["water-to-light"]},
                 {:map, [88, 18, 7]},
                 {:map, [18, 25, 70]}
               ],
               category: [
                 {:label, ["light-to-temperature"]},
                 {:map, [45, 77, 23]},
                 {:map, [81, 45, 19]},
                 {:map, ~c"D@\r"}
               ],
               category: [
                 {:label, ["temperature-to-humidity"]},
                 {:map, [0, 69, 1]},
                 {:map, [1, 0, 69]}
               ],
               category: [
                 {:label, ["humidity-to-location"]},
                 {:map, ~c"<8%"},
                 {:map, [56, 93, 4]}
               ]
             ],
             "",
             %{},
             {34, 340},
             340
           }
  end

  test "transform" do
    {:ok, parsed, _, _, _, _} = Snow.Almanac.Parser.text(@example)

    assert {[79, 14, 55, 13],
            %{
              "fertilizer-to-water" => _,
              "humidity-to-location" => _,
              "light-to-temperature" => _,
              "seed-to-soil" => _,
              "soil-to-fertilizer" => _,
              "temperature-to-humidity" => _,
              "water-to-light" => _
            }} = Snow.Almanac.Parser.transform(parsed)
  end
end
