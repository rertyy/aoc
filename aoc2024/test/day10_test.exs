defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "day10 sample" do
    assert Day10.solve("data/day10_sample.txt") == 36
    assert Day10.part2("data/day10_sample.txt") == 81
  end

  test "Day10" do
    Day10.solve("data/day10.txt") |> IO.inspect(label: "part1: ")
    Day10.part2("data/day10.txt") |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
