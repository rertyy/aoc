defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "day11 sample" do
    stone1 = "1 2024 1 0 9 9 2021976"
    assert Day11.solve("data/day11_sample.txt", 1, true) == stone1

    stone2 = "2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2"
    assert Day11.solve("data/day11_sample1.txt", 6, true) == stone2
    assert Day11.solve("data/day11_sample1.txt", 6, false) == 22
  end

  test "day11 part 2 sample" do
    assert Day11.part2("data/day11_sample.txt", 1) == 7
    assert Day11.part2("data/day11_sample1.txt", 6) == 22
    assert Day11.part2("data/day11_sample1.txt", 25) == 55312
  end

  test "day11" do
    Day11.solve("data/day11.txt") |> IO.inspect(label: "part1: ")
  end

  test "day11 part 2" do
    # Day11.part2("data/day11.txt", 25) |> IO.inspect(label: "part1: ")
    Day11.part2("data/day11.txt", 75) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
