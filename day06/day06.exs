Code.require_file("../input_helpers.exs")

# TODO: Need to cache the fish by fish and number of days

defmodule Day06 do
  def age_fishes(fishes, 0) do
    fishes
  end

  def age_fishes(fishes, days) do
    spawned = fishes[1]

    for i <- 2..8, k <- 1..7 do
      fishes = Map.put(fishes, k, i)
    end

    fishes = %{fishes | 8 => spawned, 6 => fishes[6] + spawned}
    age_fishes(fishes, days - 1)
  end
end

test = [3, 4, 3, 1, 2]

input =
  InputHelpers.input_to_list("input.txt", ",")
  |> Enum.map(&String.to_integer/1)

input = test

fishes =
  input
  |> Enum.frequencies()
  |> Enum.into(%{1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, 6 => 0, 7 => 0, 8 => 0})

# IO.inspect(Day06.solve_part_two(input, 80), label: "Part1")
# IO.inspect(Day06.solve_part_two([6], 256), label: "Part2")

# IO.inspect(Day06.solve_part_two(test, 80))

fishes =
  Day06.age_fishes(fishes, 18)
  |> Enum.reduce(0, fn {_k, v}, sum -> v + sum end)

IO.inspect(fishes)
