Code.require_file("../input_helpers.exs")

defmodule Day02 do
  def solve(start_position, input) do
    input
    |> Enum.reduce(start_position, fn command, position ->
      Day02.move_sub(position, Day02.parse_command(command))
    end)
    |> Day02.multiply_position()
  end

  def move_sub({x, y}, {"forward", n}), do: {x + n, y}
  def move_sub({x, y}, {"down", n}), do: {x, y + n}
  def move_sub({x, y}, {"up", n}), do: {x, max(y - n, 0)}

  def move_sub({x, y, a}, {"forward", n}), do: {x + n, y + a * n, a}
  def move_sub({x, y, a}, {"down", n}), do: {x, y, a + n}
  def move_sub({x, y, a}, {"up", n}), do: {x, y, a - n}

  def multiply_position({x, y}), do: x * y
  def multiply_position({x, y, _a}), do: x * y

  def parse_command(str) do
    [command | [dist | []]] = String.split(str, " ")

    {command, String.to_integer(dist)}
  end
end

test = [
  "forward 5",
  "down 2",
  "forward 9",
  "down 2",
  "forward 5",
  "up 3",
  "forward 2"
]

test2 = [
  "forward 5",
  "down 5",
  "forward 8",
  "up 3",
  "down 8",
  "forward 2"
]

IO.inspect(Day02.solve({0, 0}, test) == 21, label: "Part1 Test Passed")
IO.inspect(Day02.solve({0, 0}, InputHelpers.input_to_list()), label: "Part1 Result")

IO.inspect(Day02.solve({0, 0, 0}, test2) == 900, label: "Part2 Test Passed")
IO.inspect(Day02.solve({0, 0, 0}, InputHelpers.input_to_list()), label: "Part2 Result")
