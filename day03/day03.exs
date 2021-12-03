Code.require_file("../input_helpers.exs")

defmodule Day03 do
end

test = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
"""

input = InputHelpers.input_to_list()
# input = String.split(test, "\n", trim: true)
reading_length = List.first(input) |> String.length()
input_half = div(length(input), 2) |> IO.inspect(label: "Half")

gamma =
  input
  |> Enum.map(fn el ->
    el |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
  end)
  |> Enum.reduce(List.duplicate(0, reading_length), fn el, acc ->
    Enum.zip_with(acc, el, fn x, y -> x + y end)
  end)
  |> IO.inspect(label: "Count")
  |> Enum.map(fn el ->
    cond do
      el > input_half -> 1
      true -> 0
    end
  end)
  |> IO.inspect(label: "Gamma")

flip_bit = fn
  1 -> 0
  0 -> 1
end

list_to_int = fn list ->
  list
  |> Enum.join()
  |> String.to_integer(2)
end

epsilon =
  Enum.map(gamma, &flip_bit.(&1))
  |> IO.inspect(label: "Epsilon")

IO.inspect(list_to_int.(gamma) * list_to_int.(epsilon))
