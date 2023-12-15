defmodule Snow.Days.Day12Test do
  use ExUnit.Case

  doctest Snow.HotSprings
  import Snow.HotSprings

  @condition_records """
                     ???.### 1,1,3
                     .??..??...?##. 1,1,3
                     ?#?#?#?#?#?#?#? 1,3,1,6
                     ????.#...#... 4,1,1
                     ????.######..#####. 1,6,5
                     ?###???????? 3,2,1
                     """
                     |> parse()

  test "patterns" do
    assert condition_match("???.###", "###.###")
    refute condition_match("???.###", ".......")
    refute condition_match(".??.###", "#??.###")
  end

  test "groups" do
    assert group_match([1, 1, 3], "#.#.###")
    refute group_match([1, 1, 3], "###.###")
  end

  def count(springs_pattern, springs_groups) do
    # |> IO.inspect(label: "length for #{springs_pattern}")
    length = String.length(springs_pattern)
    permutations = combos(length)
    # IO.inspect(Enum.count(permutations), label: "num combos for #{springs_pattern}")
    assert Enum.count(permutations) == :math.pow(2, length)

    Enum.filter(permutations, fn candidate ->
      gm = group_match(springs_groups, candidate)
      cm = condition_match(springs_pattern, candidate)

      # if gm do
      #   IO.puts("Group match for #{candidate} on #{springs_groups}")
      # end

      # if cm do
      #   IO.puts("Springs match for #{candidate} on #{springs_pattern}")
      # end

      gm && cm
    end)
    |> Enum.count()
  end

  test "just this one" do
    assert count(".??..??...?##.", [1, 1, 3]) == 4
  end

  @tag :skip
  test "permutations" do
    springs_pattern = "???.###"
    springs_groups = [1, 1, 3]
    assert count(springs_pattern, springs_groups) == 1

    assert @condition_records
           |> Enum.map(fn {springs, groups} ->
             count(springs, groups)
           end) == [1, 4, 1, 1, 4, 10]
  end

  @tag timeout: :infinity
  @tag :skip
  test "real" do
    data = parse(File.read!("priv/input/Day 12 input.txt"))
    {:ok, counter} = Agent.start(fn -> 0 end)
    # :observer.start()

    # max_parallellism = div(Enum.count(data), 3)

    batches =
      data
      |> Enum.chunk_every(250)

    assert batches
           |> Enum.map(fn batch ->
             Task.async(fn ->
               batch
               |> Enum.map(fn {springs, groups} ->
                 Agent.update(counter, fn x ->
                   #  IO.puts("round #{x}/#{Enum.count(data)}")
                   x + 1
                 end)

                 count(springs, groups)
               end)
             end)
           end)
           |> Enum.flat_map(&Task.await(&1, :infinity))
           |> Enum.sum() ==
             6827

    # assert data
    #        |> Enum.map(fn {springs, groups} ->
    #          Agent.update(counter, fn x ->
    #            IO.puts("round #{x}/#{Enum.count(data)}")
    #            x + 1
    #          end)

    #          count(springs, groups)
    #        end)
    #        |> Enum.sum() == 0
  end
end
