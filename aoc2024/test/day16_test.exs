defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "day16 sample" do
    assert Day16.solve("data/day16_sample.txt") == 7036
    assert Day16.solve("data/day16_sample2.txt") == 11048
  end

  test "day16 part2 sample" do
    assert Day16.solve("data/day16_sample.txt", 2) == 45
    assert Day16.solve("data/day16_sample2.txt", 2) == 64
  end

  test "Day16" do
    Day16.solve("data/day16.txt") |> IO.inspect(label: "part1: ")
    Day16.solve("data/day16.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
