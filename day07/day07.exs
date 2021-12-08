input = File.read!("input.txt")
# input = "16,1,2,0,4,2,7,1,2,14"

frequencies =
  input
  |> String.split(",", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.frequencies()
  |> IO.inspect()

fuel_costs =
  for {k, _v} <- frequencies, into: [] do
    fuel_to_pos =
      Enum.reduce(frequencies, 0, fn {pos, count}, acc ->
        acc + abs(k - pos) * count
      end)

    {k, fuel_to_pos}
  end

part1 =
  fuel_costs
  |> Enum.min_by(fn {_pos, fuel} -> fuel end)
  |> IO.inspect(label: "part1")

{{min, _}, {max, _}} = Enum.min_max_by(frequencies, fn {k, _} -> k end)

fuel_costs =
  for k <- min..max, into: [] do
    fuel_to_pos =
      Enum.reduce(frequencies, 0, fn {pos, count}, acc ->
        n = abs(k - pos)
        (:math.pow(n, 2) + n) / 2 * count + acc
      end)

    {k, fuel_to_pos}
  end

part2 =
  fuel_costs
  |> Enum.min_by(fn {_pos, fuel} -> fuel end)
  |> IO.inspect(label: "part2")
