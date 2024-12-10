defmodule AocUtil do
  @spec parse_grid(String.t()) :: {%{{integer(), integer()} => any()}, integer(), integer()}
  def parse_grid(input) do
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
          {{i, j}, x}
        end)
      end)
      |> Map.new()

    {grid, nrows, ncols}
  end
end
