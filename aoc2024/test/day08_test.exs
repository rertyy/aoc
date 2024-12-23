defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "day8 sample" do
    assert Day8.day8("data/day08_sample.txt") == 14
    assert Day8.day8("data/day08_sample.txt", 2) == 34
  end

  test "day8" do
    Day8.day8("data/day08.txt") |> IO.inspect(label: "part1: ")
    Day8.day8("data/day08.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
