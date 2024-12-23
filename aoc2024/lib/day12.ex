defmodule Day12 do
  @directions [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def solve(filename, part \\ 1) do
    input = File.read!(filename)
    {grid, nrows, ncols} = AocUtil.parse_grid(input)

    grid
    |> Enum.reduce({MapSet.new(), 0}, fn {coord, _val}, acc ->
      {visited, total} = acc

      if MapSet.member?(visited, coord) do
        acc
      else
        case part do
          1 ->
            {visited, area, peri} = dfs(grid, coord, nrows, ncols, visited, 0, 0)
            # IO.inspect({area, peri, coord, Map.fetch!(grid, coord)})
            {visited, total + area * peri}

          2 ->
            {visited, area, corners} = dfs2(grid, coord, nrows, ncols, visited, 0, 0)
            # IO.inspect({area, corners, coord, Map.fetch!(grid, coord)})
            {visited, total + area * corners}
        end
      end
    end)
    |> elem(1)
  end

  ### Impt thing to realise here is that the number of sides is equal to the number of corners
  defp dfs2(grid, coord, nrows, ncols, visited, area, corners) do
    if not Util.valid_coord?(coord, nrows, ncols) or MapSet.member?(visited, coord) do
      {visited, area, corners}
    else
      area = area + 1
      visited = MapSet.put(visited, coord)
      {i, j} = coord

      corners = corners + calc_corners(grid, coord)

      @directions
      |> Enum.reduce({visited, area, corners}, fn {di, dj}, {visited, area, corners} ->
        coord2 = {i + di, j + dj}

        if Util.valid_coord?(coord2, nrows, ncols) and same_region?(grid, coord, coord2) do
          dfs2(grid, coord2, nrows, ncols, visited, area, corners)
        else
          {visited, area, corners}
        end
      end)
    end
  end

  defp calc_corners(grid, coord) do
    {i, j} = coord
    up_coord = {i - 1, j}
    down_coord = {i + 1, j}
    left_coord = {i, j - 1}
    right_coord = {i, j + 1}
    up_right_coord = {i - 1, j + 1}
    up_left_coord = {i - 1, j - 1}
    down_right_coord = {i + 1, j + 1}
    down_left_coord = {i + 1, j - 1}

    num_corners =
      [
        convex(grid, coord, up_coord, left_coord),
        convex(grid, coord, up_coord, right_coord),
        convex(grid, coord, down_coord, left_coord),
        convex(grid, coord, down_coord, right_coord),
        concave(grid, coord, up_coord, up_right_coord, right_coord),
        concave(grid, coord, up_coord, up_left_coord, left_coord),
        concave(grid, coord, down_coord, down_right_coord, right_coord),
        concave(grid, coord, down_coord, down_left_coord, left_coord)
      ]
      |> Enum.sum()

    num_corners
  end

  # b _
  # a c
  defp convex(grid, a, b, c) do
    # if coord not in map, returns nil, which is handled accordingly
    cond = grid[a] != grid[b] and grid[a] != grid[c]
    (cond && 1) || 0
  end

  # b c    # must be   a b
  # a d                a a
  defp concave(grid, a, b, c, d) do
    cond = grid[a] == grid[b] and grid[a] == grid[d] and grid[a] != grid[c]
    (cond && 1) || 0
  end

  defp dfs(grid, coord, nrows, ncols, visited, area, perimeter) do
    area = area + 1
    visited = MapSet.put(visited, coord)
    {i, j} = coord

    @directions
    |> Enum.reduce({visited, area, perimeter}, fn {di, dj}, acc ->
      {visited, area, perimeter} = acc
      coord2 = {i + di, j + dj}

      valid? = fn -> Util.valid_coord?(coord2, nrows, ncols) end
      same_region? = fn -> same_region?(grid, coord, coord2) end
      visited? = fn -> MapSet.member?(visited, coord2) end

      cond do
        not valid?.() or not same_region?.() ->
          {visited, area, perimeter + 1}

        valid?.() and same_region?.() and not visited?.() ->
          dfs(grid, coord2, nrows, ncols, visited, area, perimeter)

        true ->
          acc
      end
    end)
  end

  defp same_region?(grid, coord1, coord2) do
    Map.fetch!(grid, coord1) == Map.fetch!(grid, coord2)
  end
end
