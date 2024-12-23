defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "day14 sample" do
    assert Day14.solve("data/day14_sample.txt", 11, 7, 100) == 12
    # assert Day14.part2("data/day14_sample.txt") == 81
  end

  test "Day14" do
    Day14.solve("data/day14.txt") |> IO.inspect(label: "part1: ")
    # Day14.part2("data/day14.txt") |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
