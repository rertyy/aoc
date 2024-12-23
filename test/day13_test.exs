defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "day13 sample" do
    assert Day13.solve("data/day13_sample.txt") == 480
  end

  test "day13 part2 sample" do
  end

  test "Day13" do
    Day13.solve("data/day13.txt") |> IO.inspect(label: "part1: ")
    Day13.part2("data/day13.txt") |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
