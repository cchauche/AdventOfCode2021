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

IO.inspect(fuel_costs, label: "fuel_costs", charlists: :as_lists)

part1 =
  fuel_costs
  |> Enum.min_by(fn {_pos, fuel} -> fuel end)
  |> IO.inspect(label: "part1")
