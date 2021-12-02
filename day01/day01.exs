defmodule Day01 do
  def count_increases(depth, [next | depths]) do
    increase_count = count_increases(next, depths)

    cond do
      next > depth ->
        increase_count + 1

      true ->
        increase_count
    end
  end

  def count_increases(_depth, []), do: 0
end

depths =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer(&1))

test1 = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
test2 = [10, 9, 8, 7]

[a | b] = test1
IO.inspect(Day01.count_increases(a, b) == 7, label: "Test1")
[a | b] = test2
IO.inspect(Day01.count_increases(a, b) == 0, label: "Test2")

[a | b] = depths
IO.inspect(Day01.count_increases(a, b), label: "Day01 - Part1")
