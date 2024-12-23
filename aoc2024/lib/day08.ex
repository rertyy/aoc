defmodule Day8 do
  def day8(filename, part \\ 1) do
    input = File.read!(filename)
    {grid, nrows, ncols} = AocUtil.parse_grid(input)

    grid
    |> Enum.reject(fn {{_i, _j}, x} -> x == "." end)
    |> Enum.group_by(
      fn {{_i, _j}, x} -> x end,
      fn {{i, j}, _x} -> {i, j} end
    )
    |> Enum.flat_map(fn {_k, v} ->
      Util.pairwise_unique(v, fn p1, p2 ->
        case part do
          1 -> generate_antipoints(p1, p2)
          2 -> generate_antipoints2(p1, p2, nrows, ncols)
        end
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.filter(fn x -> within_grid?(x, nrows, ncols) end)
    |> Enum.count()
  end

  defp generate_antipoints({a, b}, {i, j}) do
    diff_i = i - a
    diff_j = j - b

    [{a - diff_i, b - diff_j}, {i + diff_i, j + diff_j}]
  end

  defp within_grid?({i, j}, nrows, ncols) do
    i >= 0 and i < nrows and j >= 0 and j < ncols
  end

  defp generate_antipoints2({a, b}, {i, j}, nrows, ncols) do
    diff_i = i - a
    diff_j = j - b
    most_diffs_i = div(nrows, abs(diff_i))
    most_diffs_j = div(ncols, abs(diff_j))
    most_diffs = min(most_diffs_i, most_diffs_j)

    Enum.reduce(-most_diffs..most_diffs, [], fn i, acc ->
      new_i = a + i * diff_i
      new_j = b + i * diff_j
      [{new_i, new_j} | acc]
    end)
  end
end

#### Only do x * (diff_i, diff_j), not independently
#  Enum.reduce(-most_diffs_i..most_diffs_i, [], fn i, acc ->
#    [
#      Enum.reduce(-most_diffs_j..most_diffs_j, [], fn j, j_acc ->
#        new_i = a + i * diff_i
#        new_j = b + j * diff_j
#        [{new_i, new_j} | j_acc]
#      end)
#      | acc
#    ]
#  end)
# end
