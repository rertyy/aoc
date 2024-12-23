defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "day12 sample" do
    assert Day12.solve("data/day12_sample_large.txt") == 1930
    assert Day12.solve("data/day12_sample_small.txt") == 140
    assert Day12.solve("data/day12_sample_xo.txt") == 772
  end

  test "day12 part2 sample" do
    assert Day12.solve("data/day12_sample_small.txt", 2) == 80
    assert Day12.solve("data/day12_sample_xo.txt", 2) == 436
    assert Day12.solve("data/day12_sample_e.txt", 2) == 236
    assert Day12.solve("data/day12_sample_medium.txt", 2) == 368
    assert Day12.solve("data/day12_sample_large.txt", 2) == 1206
  end

  test "Day12" do
    Day12.solve("data/day12.txt") |> IO.inspect(label: "part1: ")
    Day12.solve("data/day12.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
