defmodule AocUtil do
  @type coord() :: {i :: non_neg_integer(), j :: non_neg_integer()}
  @type grid() :: %{coord() => any()}

  @spec parse_grid(String.t(), (String.t() -> any())) ::
          {grid(), non_neg_integer(), non_neg_integer()}

  # Note that grid coordinates is 0,0 at top left, and
  # (0, 1) to the right
  # (1, 0) to the bottom
  def parse_grid(input, transform \\ & &1) do
    rows = String.split(input, "\n", trim: true)
    nrows = length(rows)
    ncols = hd(rows) |> String.codepoints() |> length()

    grid =
      rows
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, i} ->
        line
        |> String.codepoints()
        |> Enum.with_index()
        |> Enum.map(fn {x, j} ->
          {{i, j}, transform.(x)}
        end)
      end)
      |> Map.new()

    {grid, nrows, ncols}
  end

  def print_grid(grid, nrows, ncols) do
    Enum.reduce((nrows - 1)..0//-1, [], fn i, racc ->
      row =
        Enum.reduce((ncols - 1)..0//-1, [], fn j, cacc ->
          ele = grid[{i, j}]
          [ele | cacc]
        end)

      [row | racc]
    end)
    |> IO.inspect()
  end
end
