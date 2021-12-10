Code.require_file("../input_helpers.exs")

# TODO: Need to cache the fish by fish and number of days

defmodule Day06 do
  def age_fish(num) when num == 0, do: {:spawn, 6}
  def age_fish(num), do: {:ok, num - 1}

  def age_by_day(fishes) do
    # age the fishes
    {fishes, spawned} =
      Enum.map_reduce(fishes, 0, fn fish, spawned ->
        case age_fish(fish) do
          {:ok, num} ->
            {num, spawned}

          {:spawn, num} ->
            {num, spawned + 1}
        end
      end)

    # append spawned fishes to tail
    fishes ++ List.duplicate(8, spawned)
  end

  def age_fishes(fishes, 0), do: fishes

  def age_fishes(fishes, num) do
    fishes
    |> age_by_day()
    |> age_fishes(num - 1)
  end

  def solve_part_one(fishes, days) do
    fishes
    |> age_fishes(days)
    |> length()
  end

  def count_lifetime_spawn(fish, days) do
    solve_part_one([fish], days)
  end

  def solve_part_two(fishes, days, cache \\ %{})

  def solve_part_two([fish | fishes], days, cache) do
    # IO.inspect(cache, label: "cache")

    case Map.get(cache, fish, nil) do
      nil ->
        # IO.inspect("Miss #{fish}")
        spawn_count = count_lifetime_spawn(fish, days)
        spawn_count + solve_part_two(fishes, days, Map.put(cache, fish, spawn_count))

      spawn_count ->
        # IO.inspect("Hit #{fish}")
        spawn_count + solve_part_two(fishes, days, cache)
    end
  end

  def solve_part_two([], _, _), do: 0
end

test = [3, 4, 3, 1, 2]

input =
  InputHelpers.input_to_list("input.txt", ",")
  |> Enum.map(&String.to_integer/1)

IO.inspect(Day06.solve_part_one(test, 18) == 26, label: "Age 18 days")
IO.inspect(Day06.solve_part_one(test, 80) == 5934, label: "Age 80 days")

IO.inspect(Day06.solve_part_two(input, 80), label: "Part1")
IO.inspect(Day06.solve_part_two([6], 256), label: "Part2")

# IO.inspect(Day06.solve_part_two(test, 80))
