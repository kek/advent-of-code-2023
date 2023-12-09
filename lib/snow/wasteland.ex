defmodule Snow.Wasteland do
  def path([], original_instructions, from, to, network) do
    path(original_instructions, original_instructions, from, to, network)
  end

  def path([:right | rest_instructions], original_instructions, from, to, network) do
    case network[from] do
      {_, ^to} -> [to]
      {_, other} -> [other | path(rest_instructions, original_instructions, other, to, network)]
    end
  end

  def path([:left | rest_instructions], original_instructions, from, to, network) do
    case network[from] do
      {^to, _} -> [to]
      {other, _} -> [other | path(rest_instructions, original_instructions, other, to, network)]
    end
  end

  # stop_poses = Map.keys(left) |> Enum.filter(&String.ends_with?(&1, "Z")) |> MapSet.new()

  # Compile time detect of ending in Z. Read from the data file perhaps
  defp ends_in_z(pos) do
    case pos do
      "FTZ" -> true
      "GGZ" -> true
      "KTZ" -> true
      "MCZ" -> true
      "TPZ" -> true
      "ZZZ" -> true
      "11Z" -> true
      "22Z" -> true
      _ -> false
    end
  end

  def stops_for(instructions, max_steps, position, {left, right}, consumer \\ nil) do
    {:ok, keeper} = Agent.start_link(fn -> [] end)

    instructions
    |> Enum.reduce_while({0, position}, fn instruction, {i, pos} ->
      if rem(i, 100_000_000) == 0 and i > 0 do
        # IO.inspect(div(i, 1_000_000), label: "Progress for #{position} (millions)")

        if consumer do
          Agent.cast(keeper, fn stops ->
            send(consumer, {i, MapSet.new(stops)})
            stops
          end)
        end
      end

      pos =
        case instruction do
          :left -> left[pos]
          :right -> right[pos]
        end

      if i < max_steps do
        i = i + 1

        if ends_in_z(pos) do
          Agent.update(keeper, fn stops -> [i | stops] end)
        end

        {:cont, {i, pos}}
      else
        if consumer do
          Agent.cast(keeper, fn stops ->
            send(consumer, {i, MapSet.new(stops)})
            stops
          end)
        end

        {:halt, "No solution was found"}
      end
    end)

    stops = Agent.get(keeper, fn stops -> MapSet.new(stops) end, :infinity)
    stops
  end

  def path_multi(instructions, positions, network) do
    Stream.cycle(instructions)
    |> Enum.reduce_while({0, positions}, fn instruction, {i, positions} ->
      # if rem(i, 100_0000) == 0 do
      #   IO.puts(i)
      # end

      if Enum.all?(positions, &String.ends_with?(&1, "Z")) do
        {:halt, i}
      else
        {:cont, {i + 1, step(instruction, positions, network)}}
      end
    end)
  end

  def step(:left, positions, {branch, _}), do: Enum.map(positions, &branch[&1])
  def step(:right, positions, {_, branch}), do: Enum.map(positions, &branch[&1])

  def consume(state, how_many) do
    receive do
      {i, set} ->
        state =
          case Map.get(state, i) do
            nil ->
              Map.put(state, i, [set])

            items when length(items) == how_many - 1 ->
              sets = [set | items]

              # Enum.reduce(sets, &MapSet.intersection/2)
              # |> Enum.sort()
              # |> Enum.take(1)
              # |> case do
              #   [] -> nil
              #   [n] -> IO.puts("The solution is #{n}")
              # end

              state =
                Enum.reduce(state, 0..(i - 1), fn elem, acc ->
                  Map.delete(acc, elem)
                end)

              Map.put(state, i, sets)

            items ->
              Map.put(state, i, [set | items])
          end

        consume(state, how_many)
    end
  end

  def try_to_find_solution(data, max_steps \\ 100_000) do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(data)

    instructions = Stream.cycle(instructions)

    entrypoints =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    consumer = spawn(fn -> consume(%{}, Enum.count(entrypoints)) end)

    stops_sets =
      Enum.map(entrypoints, fn pos ->
        Task.async(fn ->
          Snow.Wasteland.stops_for(instructions, max_steps, pos, network, consumer)
        end)
      end)
      |> Enum.map(&Task.await(&1, :infinity))

    common_stops_sets = Enum.reduce(stops_sets, &MapSet.intersection/2)

    common_stops_sets
    |> Enum.sort()
    |> Enum.take(1)
    |> case do
      [] -> {:error, "No solution found"}
      [n] -> {:ok, n}
    end
  end

  def solution_by_ring_length(data) do
    {instructions, network} = Snow.Wasteland.ParserMulti.read(data)
    instructions = Stream.cycle(instructions)

    entrypoints =
      Map.keys(elem(network, 0))
      |> Enum.filter(&String.ends_with?(&1, "A"))

    Enum.map(entrypoints, fn pos ->
      Task.async(fn ->
        Snow.Wasteland.stops_for(instructions, 100_000, pos, network)
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(&Enum.take(&1, 2))
    |> Enum.map(fn [first, second] ->
      {first, second - first}
    end)
    |> Enum.map(&elem(&1, 1))
    |> lcm()
  end

  @doc """
  Find the lowest number which has all of items in the list as factors.
  Thanks Microsoft

  ### Examples

  iex> import Snow.Wasteland
  iex> lcm([2,3])
  6
  iex> lcm([2,3,6])
  6
  """
  def lcm(numbers) do
    lcm(numbers, 1)
  end

  defp lcm([], acc), do: acc

  defp lcm([head | tail], acc) do
    lcm(tail, lcm(head, acc))
  end

  defp lcm(a, b) do
    div(a * b, gcd(a, b))
  end

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end
