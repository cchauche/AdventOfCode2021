Code.require_file("../input_helpers.exs")

defmodule Day04 do
  def check(input) when is_list(input), do: Enum.all?(input, fn {_, x} -> x == 1 end)
  def check(input) when is_tuple(input), do: Tuple.to_list(input) |> check()
  def check(_), do: false

  def check_rows(board) do
    board
    |> Enum.chunk_every(5)
    |> Enum.any?(&check/1)
  end

  def check_cols(board) do
    board
    |> Enum.chunk_every(5)
    |> List.zip()
    |> Enum.any?(&check/1)
  end

  def update_boards(boards, num) do
    update =
      Enum.map_reduce(boards, nil, fn
        board, nil ->
          board =
            Enum.map(board, fn
              {el, _x} when el == num -> {el, 1}
              el -> el
            end)

          acc =
            case check_rows(board) || check_cols(board) do
              true ->
                board

              _ ->
                nil
            end

          {board, acc}

        board, acc ->
          {board, acc}
      end)

    case update do
      {boards, nil} ->
        {:nowin, boards}

      {_, board} ->
        {:win, board}
    end
  end

  def find_winning_board(boards, [num | nums]) do
    case update_boards(boards, num) do
      {:win, board} ->
        {board, String.to_integer(num)}

      {_, boards} ->
        find_winning_board(boards, nums)
    end
  end

  def find_last_winning_board([board], [num | nums]) do
    board =
      Enum.map(board, fn
        {el, _x} when el == num -> {el, 1}
        el -> el
      end)

    case check_rows(board) || check_cols(board) do
      true ->
        {board, String.to_integer(num)}

      _ ->
        find_last_winning_board([board], nums)
    end
  end

  def find_last_winning_board(boards, [num | nums]) do
    # Reduce boards keeping only losers
    boards
    |> Enum.reduce([], fn board, acc ->
      board =
        Enum.map(board, fn
          {el, _x} when el == num -> {el, 1}
          el -> el
        end)

      case check_rows(board) || check_cols(board) do
        true ->
          acc

        _ ->
          acc ++ [board]
      end
    end)
    |> find_last_winning_board(nums)
  end

  def update_remove_winners([board | []], num) do
    board =
      Enum.map(board, fn
        {el, _x} when el == num -> {el, 1}
        el -> el
      end)

    [board]
  end

  def update_remove_winners([board | boards], num) do
    board =
      Enum.map(board, fn
        {el, _x} when el == num -> {el, 1}
        el -> el
      end)

    case check_rows(board) || check_cols(board) do
      true ->
        IO.inspect(Enum.chunk_every(board, 5), label: "Tossing")
        update_remove_winners(boards, num)

      _ ->
        [board | update_remove_winners(boards, num)]
    end
  end

  def calc_result(board, num) do
    sum =
      board
      |> Enum.reduce(0, fn
        {num, 0}, acc ->
          String.to_integer(num) + acc

        _el, acc ->
          acc
      end)

    sum * num
  end
end

test_nums = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"

test_boards = """
22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""

test_boards = File.read!("boards.txt")
test_nums = File.read!("numbers.txt")

test_boards =
  test_boards
  |> String.replace(~r/\s+/, ",")
  # |> String.replace("\n", " ")
  |> String.split(",", trim: true)
  |> Enum.map(fn el -> {el, 0} end)
  |> Enum.chunk_every(25)

# |> IO.inspect(label: "Boards", limit: :infinity, printable_limit: :infinity)

test_nums =
  test_nums
  |> String.split(",", trim: true)

# |> IO.inspect(label: "Nums")

{board, num} = Day04.find_winning_board(test_boards, test_nums)
{last_board, last_num} = Day04.find_last_winning_board(test_boards, test_nums)

IO.inspect(Enum.chunk_every(last_board, 5), label: "last_board")
IO.inspect(last_num, label: "last_num")

IO.inspect(Day04.calc_result(board, num), label: "Part 1 Result")
IO.inspect(Day04.calc_result(last_board, last_num), label: "Part 2 Result")
