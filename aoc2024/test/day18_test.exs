defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  test "day18 sample" do
    assert Day18.solve("data/day18_sample.txt", 7, 7, 12) == 22
  end

  test "Day18" do
    Day18.solve("data/day18.txt", 71, 71, 1024) |> IO.inspect(label: "part1: ")
  end

  test "Day 18 part 2 sample" do
    assert Day18.part2("data/day18_sample.txt", 7, 7) == {6, 1}
  end

  test "Day18 part 2" do
    Day18.part2("data/day18.txt", 71, 71) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
