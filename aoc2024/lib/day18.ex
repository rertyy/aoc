defmodule Day18 do
  @wall "#"
  @empty "."

  @down {1, 0}
  @up {-1, 0}
  @right {0, 1}
  @left {0, -1}
  @dirs [@up, @down, @left, @right]

  def solve(filename, nrows, ncols, bytes) do
    file = File.read!(filename)

    input =
      parse(file, bytes)
      |> input_to_map()

    grid = generate_grid(nrows, ncols)
    grid = AocUtil.plot_map_on_grid(input, grid)
    # AocUtil.inspect_grid(plot, nrows, ncols)
    run_astar(grid, nrows, ncols)
  end

  def run_astar(grid, nrows, ncols) do
    start = {0, 0}
    fin = {nrows - 1, ncols - 1}

    init = manhattan(start, fin)

    pq = Heap.new()
    pq = Heap.push(pq, {init, start})
    dists = Map.put(%{}, start, 0)

    dists = astar(grid, pq, dists, fin)

    dists[fin]
  end

  def part2(filename, nrows, ncols) do
    # i think this is a bsearch problem, but needing to do Enum.take(n) is quite bad
    # storing the full input list then dropping from full (for need more) or dropping from mid (need less) might be possible but complicated and still bad
    # anyway only 3450 rows

    # Note: not catching the edge cases where the full list succeeds or the empty list (no walls) still fails; assuming input never lands on start or end

    file = File.read!(filename)
    grid = generate_grid(nrows, ncols)

    full_input = parse(file, 999_999)

    input_map =
      full_input
      |> input_to_map()

    grid = AocUtil.plot_map_on_grid(input_map, grid)
    rev = Enum.reverse(full_input)
    iterate(grid, nrows, ncols, rev)
  end

  def iterate(grid, nrows, ncols, input) do
    [head | tail] = input
    # remove the last element that caused the failure
    # if this removal makes it succeed, then this is the last byte needed to fail
    grid = %{grid | head => @empty}
    res = run_astar(grid, nrows, ncols)

    if res != nil do
      {y, x} = head
      {x, y}
    else
      iterate(grid, nrows, ncols, tail)
    end
  end

  defp astar(grid, pq, dists, fin) do
    if Heap.empty?(pq) do
      dists
    else
      {_, u} = Heap.root(pq)
      pq = Heap.pop(pq)

      if u == fin do
        dists
      else
        {pq, dists} =
          @dirs
          |> Enum.reduce({pq, dists}, fn du, acc ->
            {pq, dists} = acc

            v = add(u, du)
            dist = dists[u] + 1
            stored_dist = dists[v]

            cond do
              grid[v] == @wall or grid[v] == nil ->
                acc

              stored_dist == nil or dist < stored_dist ->
                heur = manhattan(v, fin)

                dists = Map.put(dists, v, dist)
                pq = Heap.push(pq, {dist + heur, v})
                {pq, dists}

              true ->
                acc
            end
          end)

        astar(grid, pq, dists, fin)
      end
    end
  end

  defp add({i, j}, {di, dj}) do
    {i + di, j + dj}
  end

  defp manhattan({i1, j1}, {i2, j2}) do
    abs(i1 - i2) + abs(j1 - j2)
  end

  defp generate_grid(nrows, ncols) do
    # grid =
    #   for(i <- 0..(nrows - 1), j <- 0..(ncols - 1), do: {{i, j}, @wall})
    #   |> Enum.into(%{})

    grid =
      Enum.reduce(0..(nrows - 1), %{}, fn i, acc ->
        Enum.reduce(0..(ncols - 1), acc, fn j, acc ->
          Map.put(acc, {i, j}, @empty)
        end)
      end)

    grid
  end

  defp input_to_map(input) do
    Enum.map(input, fn coord -> {coord, @wall} end)
    |> Enum.into(%{})
  end

  defp parse(file, bytes) do
    file
    |> String.split("\n", trim: true)
    |> Enum.take(bytes)
    |> Enum.map(fn s ->
      String.split(s, ",", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [x, y] -> {y, x} end)
  end
end
