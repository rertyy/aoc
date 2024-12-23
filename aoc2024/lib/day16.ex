defmodule Day16 do
  @start "S"
  @fin "E"
  @wall "#"

  @down {1, 0}
  @up {-1, 0}
  @right {0, 1}
  @left {0, -1}

  @type prevs_t :: %{optional(AocUtil.coord()) => [AocUtil.coord()]}
  @type state_t :: {AocUtil.coord(), AocUtil.coord()}
  @type prev_state_t :: %{optional(state_t()) => [state_t()]}
  @type visited_t :: MapSet.t(AocUtil.coord())
  @type dists_t :: %{optional(AocUtil.coord()) => integer()}
  @type dists_state_t :: %{optional(state_t()) => integer()}

  # Note: Don't forget to include the direction in the state
  # Why are you forgetting all your algorithms...
  # Part 1 is still correct because it takes just one best path,
  # and because any path guarantees at least 2 turns (unless a straight path), the ans will be same
  #
  # Case 1
  # #..OE
  # #.#O#
  # SOOO#
  #
  # Case 2
  # #OOOE
  # #O#.#
  # SO..#
  #
  # In case 2, if you ignore direction, then reaching the last step before E is cheaper
  # because it reaches there without turning, but both paths end up with the same cost

  def solve(filename, part \\ 1) do
    input = File.read!(filename)
    {grid, _nrows, _ncols} = AocUtil.parse_grid(input)
    start = find_coord(grid, @start)
    fin = find_coord(grid, @fin)
    queue = Heap.new() |> Heap.push({0, start, @right})

    case part do
      1 ->
        dists = %{start => 0}
        dists = dijkstra(grid, queue, dists)
        dists[fin]

      2 ->
        dists = %{{start, @right} => 0}
        prevs = %{}
        {dists, prevs} = dijkstra2(grid, queue, dists, prevs)

        end_states =
          dists
          |> Enum.filter(fn {{coord, _}, _} -> coord == fin end)

        min_dist =
          Enum.min_by(end_states, fn {_state, dist} -> dist end)
          |> elem(1)

        fin_states =
          end_states
          |> Enum.filter(fn {_state, dist} -> dist == min_dist end)
          |> Enum.map(&elem(&1, 0))

        visited_cells =
          process_prevs(MapSet.new(), prevs, fin_states)

        # visited_cells
        # |> AocUtil.plot_on_grid(grid)
        # |> AocUtil.inspect_grid(_nrows, _ncols)

        visited_cells |> Enum.count()

        # all_best_paths =
        #   Enum.flat_map(fin_states, fn {state, _dist} ->
        #     reconstruct_paths(state, prevs)
        #   end)
        # Enum.count(all_best_paths)
    end
  end

  defp find_coord(grid, ele) do
    Enum.find_value(grid, fn {coord, e} -> if e == ele, do: coord end)
  end

  defp get_new_dirs(dir) do
    # there is never a case you need to make a 180 degree turn
    case dir do
      @up -> [@up, @left, @right]
      @down -> [@down, @left, @right]
      @left -> [@left, @up, @down]
      @right -> [@right, @up, @down]
    end
  end

  defp add({i, j}, {x, y}), do: {i + x, j + y}

  @spec dijkstra(
          AocUtil.grid(),
          Heap.t(),
          dists_t()
        ) :: dists_t()
  defp dijkstra(grid, queue, dists) do
    if Heap.empty?(queue) do
      dists
    else
      {min_dist, u, dir} = Heap.root(queue)
      queue = Heap.pop(queue)

      dirs = get_new_dirs(dir)

      {dists, queue} =
        Enum.reduce(dirs, {dists, queue}, fn du, acc ->
          {dists, queue} = acc
          v = add(u, du)

          if grid[v] == nil or grid[v] == @wall do
            acc
          else
            weight = if du == dir, do: 1, else: 1001
            alt = min_dist + weight
            stored_dist = dists[v]

            cond do
              stored_dist == nil or alt < stored_dist ->
                dists = Map.put(dists, v, alt)
                queue = Heap.push(queue, {alt, v, du})
                {dists, queue}

              true ->
                acc
            end
          end
        end)

      dijkstra(grid, queue, dists)
    end
  end

  @spec dijkstra2(
          AocUtil.grid(),
          Heap.t(),
          dists_state_t(),
          prev_state_t()
        ) :: {dists_state_t(), prev_state_t()}
  defp dijkstra2(grid, queue, dists, prevs) do
    if Heap.empty?(queue) do
      {dists, prevs}
    else
      {min_dist, u, dir} = Heap.root(queue)
      queue = Heap.pop(queue)
      current_state = {u, dir}

      dirs = get_new_dirs(dir)

      {dists, queue, prevs} =
        Enum.reduce(dirs, {dists, queue, prevs}, fn du, acc ->
          {dists, queue, prevs} = acc
          v = add(u, du)

          if grid[v] == nil or grid[v] == @wall do
            acc
          else
            weight = if du == dir, do: 1, else: 1001
            alt = min_dist + weight
            next_state = {v, du}
            stored_dist = dists[next_state]

            cond do
              stored_dist == nil or alt < stored_dist ->
                dists = Map.put(dists, next_state, alt)
                queue = Heap.push(queue, {alt, v, du})

                prevs =
                  Map.put(prevs, next_state, [current_state])

                {dists, queue, prevs}

              stored_dist == alt ->
                prevs =
                  Map.update(prevs, next_state, [current_state], fn existing ->
                    [current_state | existing]
                  end)

                {dists, queue, prevs}

              true ->
                acc
            end
          end
        end)

      dijkstra2(grid, queue, dists, prevs)
    end
  end

  # defp reconstruct_paths(state, prevs) do
  #   case Map.get(prevs, state) do
  #     nil ->
  #       [[state]]
  #
  #     preds ->
  #       Enum.flat_map(preds, fn pred ->
  #         for path <- reconstruct_paths(pred, prevs) do
  #           path ++ [state]
  #         end
  #       end)
  #   end
  # end

  @spec process_prevs(
          visited_t(),
          prev_state_t(),
          [state_t()]
        ) :: visited_t()
  defp process_prevs(visited, _prevs, []), do: visited

  defp process_prevs(visited, prevs, states) do
    [current_state | other] = states
    {current_coord, _dir} = current_state
    visited = MapSet.put(visited, current_coord)

    next_states = Map.get(prevs, current_state, [])
    visited = process_prevs(visited, prevs, next_states)
    process_prevs(visited, prevs, other)
  end
end
