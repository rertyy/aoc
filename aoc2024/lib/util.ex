defmodule Util do
  def valid_coord?(coord, nrows, ncols) do
    {i, j} = coord
    i >= 0 and i < nrows and j >= 0 and j < ncols
  end

  @spec pairwise_unique(list(any()), (any(), any() -> any())) :: list(any())
  def pairwise_unique(list, func \\ &{&1, &2}) do
    list
    |> Enum.with_index()
    |> Enum.flat_map(fn {a, i} ->
      list
      # i is 0-based
      # don't drop if doing cartesian product
      |> Enum.drop(i + 1)
      |> Enum.map(fn b -> func.(a, b) end)
    end)
  end

  def pairwise_unique_for(list, func \\ &{&1, &2}) do
    # note that elixir for loops always construct lists
    indexed = Enum.with_index(list)
    for {a, i} <- indexed, {b, j} <- indexed, i < j, do: func.(a, b)
  end

  def cache(func) do
    # note this won't work for recursive functions which call themselves

    cache = %{}

    fn arg ->
      case Map.get(cache, arg) do
        nil ->
          result = func.(arg)
          Map.put(cache, arg, result)
          result

        result ->
          result
      end
    end
  end
end
