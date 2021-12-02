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

  def count_increases_by_three([a | [b | [c | [d | _]]] = tail]) do
    count = if b + c + d > a + b + c, do: 1, else: 0
    count + count_increases_by_three(tail)
  end

  def count_increases_by_three(list) when length(list) < 4, do: 0
end

depths =
  File.read!("input.txt")
  |> String.split("\n")
  |> Enum.map(&String.to_integer(&1))

test1 = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
test2 = [10, 9, 8, 7]

IO.inspect("--- Part 01 ---")
[a | b] = test1
IO.inspect(Day01.count_increases(a, b) == 7, label: "Test1")
[a | b] = test2
IO.inspect(Day01.count_increases(a, b) == 0, label: "Test2")

[a | b] = depths
IO.inspect(Day01.count_increases(a, b), label: "Day01 - Part1")

IO.inspect("--- Part 02 ---")

IO.inspect(Day01.count_increases_by_three(test1) == 5, label: "Test1")
IO.inspect(Day01.count_increases_by_three(test2) == 0, label: "Test2")

IO.inspect(Day01.count_increases_by_three(depths), label: "Day01 - Part2")
