defmodule AocUtil do
  @type dir() :: {integer(), integer()}
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

  @spec inspect_grid(grid(), non_neg_integer(), non_neg_integer()) :: any()
  def inspect_grid(grid, nrows, ncols) do
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

  def plot_map_on_grid(map, grid) do
    map
    |> Enum.reduce(grid, fn {coord, ele}, acc ->
      %{acc | coord => ele}
    end)
  end

  @spec plot_on_grid(MapSet.t(), grid(), any()) :: any()
  def plot_on_grid(visited, grid, ele \\ "O") do
    visited
    |> Enum.reduce(grid, fn coord, acc ->
      %{acc | coord => ele}
    end)
  end

  @spec find_coord(grid(), any()) :: coord()
  def find_coord(grid, ele) do
    Enum.find_value(grid, fn {coord, e} -> if e == ele, do: coord end)
  end

  @spec add(dir(), dir()) :: dir()
  def add({i, j}, {di, dj}) do
    {i + di, j + dj}
  end

  @spec manhattan(coord(), coord()) :: non_neg_integer()
  def manhattan({i1, j1}, {i2, j2}) do
    abs(i1 - i2) + abs(j1 - j2)
  end

  @spec generate_grid(non_neg_integer(), non_neg_integer()) :: grid()
  def generate_grid(nrows, ncols, val \\ ".") do
    # grid =
    #   for(i <- 0..(nrows - 1), j <- 0..(ncols - 1), do: {{i, j}, @wall})
    #   |> Enum.into(%{})

    grid =
      Enum.reduce(0..(nrows - 1), %{}, fn i, acc ->
        Enum.reduce(0..(ncols - 1), acc, fn j, acc ->
          Map.put(acc, {i, j}, val)
        end)
      end)

    grid
  end
end
