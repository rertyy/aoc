defmodule Day10 do
  def solve(filename) do
    file = File.read!(filename)
    {grid, nrows, ncols} = AocUtil.parse_grid(file, &String.to_integer/1)

    grid
    |> Enum.filter(fn {_coord, val} -> val == 0 end)
    |> Enum.into(%{})
    |> Enum.map(fn {coord, val} ->
      dfs(coord, val, grid, nrows, ncols)
      |> List.flatten()
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp is_valid?({i, j}, nrows, ncols) do
    i >= 0 and i < nrows and j >= 0 and j < ncols
  end

  defp dfs({i, j}, val, grid, nrows, ncols) do
    if val == 9 do
      {i, j}
    else
      [{-1, 0}, {1, 0}, {0, 1}, {0, -1}]
      |> Enum.reduce([], fn {di, dj}, acc ->
        next = {i + di, j + dj}

        if is_valid?(next, nrows, ncols) and Map.fetch!(grid, next) == val + 1 do
          [dfs(next, val + 1, grid, nrows, ncols) | acc]
        else
          acc
        end
      end)
    end
  end

  def part2(filename) do
    file = File.read!(filename)
    {grid, _nrows, _ncols} = AocUtil.parse_grid(file, &String.to_integer/1)

    grid
    |> get_count()
    |> Map.fetch!(0)
    |> Enum.map(fn {_coord, {_ele, count}} -> count end)
    |> Enum.sum()
  end

  defp get_count(grid) do
    # groups is a %{ele => %{coord => ele}}
    groups =
      Enum.group_by(grid, fn {_coord, ele} -> ele end)
      # group_by returns a %{ele => {coord, ele}}
      |> Enum.reduce(%{}, fn {ele, coords}, acc ->
        coord_map = Enum.into(coords, %{})
        Map.put(acc, ele, coord_map)
      end)

    # all 9s have 1 way to reach from the 1
    # nine_counts is %{coord => {ele, count}}
    nine_counts =
      Map.fetch!(groups, 9)
      |> Enum.map(fn {coord, ele} -> {coord, {ele, 1}} end)
      |> Enum.into(%{})

    # grid_counts is %{ele => %{coord => {ele, count}}}
    grid_counts = %{9 => nine_counts}

    # dp number of ways to reach each number 
    # from the higher number (+1), starting from 8
    8..0//-1
    |> Enum.reduce(grid_counts, fn i, acc ->
      # prev_group is %{coord => {ele, count}}
      prev_group = Map.fetch!(acc, i + 1)

      # this_group is %{coord => ele}
      this_group = Map.fetch!(groups, i)

      # %{coord => {ele, count}}
      this_grp_w_count =
        Enum.reduce(this_group, %{}, fn {coord, ele}, acc ->
          count =
            prev_group
            |> Enum.filter(fn {prev_coord, _v} ->
              is_adjacent?(coord, prev_coord)
            end)
            |> Enum.map(fn {_prev_coord, {_prev_ele, prev_count}} ->
              prev_count
            end)
            |> Enum.sum()

          Map.put(acc, coord, {ele, count})
        end)

      Map.put(acc, i, this_grp_w_count)
    end)
  end

  defp is_adjacent?(coord, prev_coord) do
    {a, b} = prev_coord

    is_above? = coord == {a - 1, b}
    is_below? = coord == {a + 1, b}
    is_left? = coord == {a, b - 1}
    is_right? = coord == {a, b + 1}

    is_above? or is_below? or is_left? or is_right?
  end
end
