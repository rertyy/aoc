defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  test "day15 sample" do
    assert Day15.solve("data/day15_sample_small.txt") == 2028
    assert Day15.solve("data/day15_sample_large.txt") == 10092
  end

  test "day15 part 2 resized example" do
    Day15.part2("data/day15_sample_p2.txt")
  end

  test "day15 part 2 sample" do
    assert Day15.part2("data/day15_sample_large.txt") == 9021
    assert Day15.part2("data/day15_sample_small.txt") == 105
  end

  test "Day15" do
    Day15.solve("data/day15.txt") |> IO.inspect(label: "part1: ")
    Day15.part2("data/day15.txt") |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
