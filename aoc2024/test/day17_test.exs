defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  test "day17 sample big" do
    assert Day17.solve("data/day17_sample.txt") == "4,6,3,5,6,3,5,2,1,0"
  end

  test "day17 sample1" do
    [_, regB, _, _, _] = Day17.solve(0, 0, 9, [2, 6], true)
    assert regB == 1
  end

  test "day17 sample2" do
    [_, _, _, _, output] = Day17.solve(10, 0, 0, [5, 0, 5, 1, 5, 4], true)
    assert output == "0,1,2"
  end

  test "day17 sample3" do
    [regA, _, _, _, output] = Day17.solve(2024, 0, 0, [0, 1, 5, 4, 3, 0], true)
    assert regA == 0
    assert output == "4,2,5,6,7,7,7,7,3,1,0"
  end

  test "day17 sample4" do
    [_, regB, _, _, _] = Day17.solve(0, 29, 0, [1, 7], true)
    assert regB == 26
  end

  test "day17 sample5" do
    [_, regB, _, _, _] = Day17.solve(0, 2024, 43690, [4, 0], true)
    assert regB == 44354
  end

  test "Day17" do
    Day17.solve("data/day17.txt") |> IO.inspect(label: "part1: ")
    # Day17.solve("data/day17.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
