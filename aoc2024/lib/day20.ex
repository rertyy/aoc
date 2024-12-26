defmodule Day20 do
  @start "S"
  @fin "E"
  @wall "#"
  @empty "."

  def solve(filename, filter) do
    file = File.read!(filename)
    {grid, nrows, ncols} = AocUtil.parse_grid(file)
    start = AocUtil.find_coord(grid, @start)
    fin = AocUtil.find_coord(grid, @fin)

    no_cheats = find_min_path(grid, start, fin)

    potential_cheats =
      grid
      |> Enum.filter(fn {_, v} -> v == @wall end)
      |> Enum.reject(fn {{i, j}, _} -> i == 0 or i == nrows - 1 or j == 0 or j == ncols - 1 end)
      |> Enum.map(fn {coord, _} -> coord end)

    # IO.inspect(potential_cheats |> Enum.count(), label: "num potential cheats: ")

    # surprisingly enough the naive method does not timeout for part1 (20s)
    potential_cheats
    |> Task.async_stream(
      fn coord ->
        grid = Map.put(grid, coord, @empty)
        fastest = find_min_path(grid, start, fin)
        no_cheats - fastest
      end,
      ordered: false
    )
    |> Enum.map(fn {:ok, x} -> x end)
    |> Enum.filter(filter)
    |> Enum.count()

    # potential_cheats
    # |> Enum.map(fn coord ->
    #   grid = Map.put(grid, coord, @empty)
    #   fastest = find_min_path(grid, start, fin)
    #   no_cheats - fastest
    # end)
    # |> Enum.filter(filter)
    # |> Enum.count()
  end

  def find_min_path(grid, start, fin) do
    init = AocUtil.manhattan(start, fin)

    pq = Heap.new()
    pq = Heap.push(pq, {init, start})
    dists = Map.put(%{}, start, 0)

    dists = Day18.astar(grid, pq, dists, fin)

    dists[fin]
  end
end
