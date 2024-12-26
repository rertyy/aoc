defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  def test_fastest(filename) do
    file = File.read!(filename)
    {grid, _, _} = AocUtil.parse_grid(file)
    start = AocUtil.find_coord(grid, "S")
    fin = AocUtil.find_coord(grid, "E")
    fastest = Day20.find_min_path(grid, start, fin)
    fastest
  end

  test "day20 sample fastest" do
    assert test_fastest("data/day20_sample.txt") == 84
  end

  def filter(f), do: fn y -> fn x -> f.(x, y) end end

  def assert_eq(x, y) do
    equals = filter(&==/2)
    assert Day20.solve("data/day20_sample.txt", equals.(x)) == y
  end

  test "day20 sample" do
    assert_eq(2, 14)
    assert_eq(4, 14)
    assert_eq(6, 2)
    assert_eq(8, 4)
    assert_eq(10, 2)
    assert_eq(12, 3)
    assert_eq(20, 1)
    assert_eq(36, 1)
    assert_eq(38, 1)
  end

  test "Day20" do
    gte100 = filter(&>=/2).(100)
    Day20.solve("data/day20.txt", gte100) |> IO.inspect(label: "part1: ")
    # Day20.solve("data/day20.txt", 2) |> IO.inspect(label: "part2: ")
  end

  IO.puts("Testing done")
end
