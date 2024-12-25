defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  test "day19 sample" do
    assert Day19.solve("data/day19_sample.txt") == 6
  end

  test "Day19" do
    Day19.solve("data/day19.txt") |> IO.inspect(label: "part1: ")
    # Day19.solve("data/day19.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
