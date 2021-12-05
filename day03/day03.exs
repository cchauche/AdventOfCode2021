Code.require_file("../input_helpers.exs")

defmodule Day03 do
  def count_bit_frequency(readings) do
    reading_length = List.first(readings) |> String.length()

    readings
    |> Enum.map(fn el ->
      el |> String.split("", trim: true) |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.reduce(List.duplicate(0, reading_length), fn el, acc ->
      Enum.zip_with(acc, el, fn x, y -> x + y end)
    end)
  end

  def generate_gamma(bit_freq, length) do
    half = length / 2

    bit_freq
    |> Enum.map(fn el ->
      cond do
        el >= half -> 1
        true -> 0
      end
    end)
  end

  def flip_bit(1), do: 0
  def flip_bit(0), do: 1

  def to_int(bit_list) do
    bit_list
    |> Enum.join()
    |> String.to_integer(2)
  end

  def generate_epsilon(gamma) do
    epsilon = Enum.map(gamma, &Day03.flip_bit/1)
  end

  def bit_criteria_fun(bit_criteria, i) do
    bit_criteria = Enum.join(bit_criteria)

    fn reading ->
      # IO.inspect(reading)
      String.at(reading, i) == String.at(bit_criteria, i)
    end
  end

  def find_rating([rating], _, _, _), do: rating
  def find_rating([], _, _, _), do: nil

  def find_rating(readings, bit_criteria, i \\ 0, opt \\ :ox) do
    criteria_fun = Day03.bit_criteria_fun(bit_criteria, i)
    # IO.inspect(readings, label: "readings")
    # IO.inspect(bit_criteria, label: "bit_criteria")
    # IO.inspect(i, label: "i")

    readings = Enum.filter(readings, criteria_fun)

    bit_criteria =
      readings
      |> Day03.count_bit_frequency()
      |> Day03.generate_gamma(length(readings))

    bit_criteria = if opt == :co2, do: Day03.generate_epsilon(bit_criteria), else: bit_criteria

    Day03.find_rating(readings, bit_criteria, i + 1, opt)
  end
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

# test = String.split(test, "\n", trim: true)

input = InputHelpers.input_to_list()
# input = String.split(test, "\n", trim: true)
reading_length = List.first(input) |> String.length()
input_half = div(length(input), 2) |> IO.inspect(label: "Half")

count =
  input
  |> Day03.count_bit_frequency()
  |> IO.inspect(label: "Count")

gamma =
  count
  |> Day03.generate_gamma(length(input))
  |> IO.inspect(label: "Gamma")

epsilon =
  Day03.generate_epsilon(gamma)
  |> IO.inspect(label: "Epsilon")

IO.inspect(Day03.to_int(gamma) * Day03.to_int(epsilon), label: "Part 1 Answer")

oxygen = Day03.find_rating(input, gamma) |> IO.inspect(label: "Oxygen Rating")

co2 = Day03.find_rating(input, epsilon, 0, :co2) |> IO.inspect(label: "CO2 Rating")

IO.inspect(String.to_integer(oxygen, 2) * String.to_integer(co2, 2),
  label: "Part 2 Answer"
)
