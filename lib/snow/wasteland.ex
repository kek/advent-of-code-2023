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

  def path_multi(i, [], original_instructions, positions, network) do
    path_multi(i, original_instructions, original_instructions, positions, network)
  end

  def path_multi(i, [instr | rest_instructions], original_instructions, positions, network) do
    if rem(i, 100_0000) == 0 do
      IO.puts(i)
    end

    # IO.puts("#{Enum.count(positions)} positions now")

    new_positions =
      Enum.map(positions, fn position ->
        {left, right} =
          network[position]

        # |> IO.inspect()

        case instr do
          :left -> left
          :right -> right
        end

        # |> IO.inspect(label: "Going #{inspect(instr)} to")
      end)

    # |> IO.inspect(label: "new_positions!!!!")

    # IO.puts("#{Enum.count(new_positions)} new positions now")

    if Enum.all?(new_positions, &String.ends_with?(&1, "Z")) do
      i
    else
      path_multi(i + 1, rest_instructions, original_instructions, new_positions, network)
    end

    # |> IO.inspect(label: "New pos")
    # |> tap(fn x ->
    #   IO.puts(Enum.count(x))
    # end)
  end
end
