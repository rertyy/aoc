defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "day9 sample" do
    assert Day9.solve("data/day09_sample.txt") == 1928
    assert Day9.solve("data/day09_sample.txt", 2) == 2858
  end

  test "day9" do
    Day9.solve("data/day09.txt") |> IO.inspect(label: "part1: ")
    Day9.solve("data/day09.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
