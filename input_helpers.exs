defmodule InputHelpers do
  def input_to_list(filename \\ "input.txt", split_on \\ "\n") do
    File.read!(filename)
    |> String.split(split_on, trim: true)
  end
end
