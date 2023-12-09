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
  defp ends_in_z("FTZ"), do: true
  defp ends_in_z("GGZ"), do: true
  defp ends_in_z("KTZ"), do: true
  defp ends_in_z("MCZ"), do: true
  defp ends_in_z("TPZ"), do: true
  defp ends_in_z("ZZZ"), do: true
  defp ends_in_z("11Z"), do: true
  defp ends_in_z("22Z"), do: true
  defp ends_in_z(_), do: false

  def stops_for(instructions, position, {left, right}) do
    {_iterations, _end_at, stops} =
      instructions
      |> Enum.reduce({0, position, []}, fn instruction, {i, pos, stops} ->
        if rem(i, 100_0000) == 0 and i > 0 do
          IO.inspect(i, label: "Progress for #{position}")
        end

        pos =
          case instruction do
            :left -> left[pos]
            :right -> right[pos]
          end

        stops =
          if ends_in_z(pos) do
            [i | stops]
          else
            stops
          end

        {i + 1, pos, stops}
      end)

    MapSet.new(stops)
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

  # def path_multi(i, [], original_instructions, positions, network) do
  #   path_multi(i, original_instructions, original_instructions, positions, network)
  # end

  # def path_multi(
  #       i,
  #       [instr | rest_instructions],
  #       original_instructions,
  #       positions,
  #       {left_network, right_network} = network
  #     ) do
  #   # if rem(i, 100_0000) == 0, do: IO.puts(i)

  #   new_positions = step(instr, positions, network)

  #   if Enum.all?(new_positions, &String.ends_with?(&1, "Z")) do
  #     i
  #   else
  #     path_multi(
  #       i + 1,
  #       rest_instructions,
  #       original_instructions,
  #       new_positions,
  #       {left_network, right_network}
  #     )
  #   end
  # end

  def step(:left, positions, {branch, _}), do: Enum.map(positions, &branch[&1])
  def step(:right, positions, {_, branch}), do: Enum.map(positions, &branch[&1])
end
