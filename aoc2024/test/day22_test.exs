defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  test "day22 test" do
    secret = 123
    assert Day22.calculate_secret(secret, 10) == 5_908_254
  end

  test "day 22 sample" do
    assert Day22.solve("data/day22_sample.txt") == 37_327_623
  end

  test "day22 part1" do
    Day22.solve("data/day22.txt") |> IO.inspect(label: "part1")
  end

  IO.puts("Testing done")
end
