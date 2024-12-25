defmodule Day19 do
  def solve(filename) do
    file = File.read!(filename)
    {towels, patterns} = parse(file)

    part1(towels, patterns)
  end

  def part1(towels, patterns) do
    trie = construct_trie(towels)

    # |> IO.inspect(label: "final trie")

    start_cache()

    patterns
    |> Enum.map(&String.codepoints/1)
    |> Task.async_stream(
      fn pattern ->
        is_possible?(trie, trie, pattern)
      end,
      ordered: false
    )
    |> Enum.filter(&match?({:ok, true}, &1))
    |> Enum.count()
  end

  defp start_cache do
    # this function has side effects
    case :ets.whereis(:cache) do
      :undefined ->
        :ets.new(:cache, [
          :set,
          :public,
          :named_table,
          read_concurrency: true,
          write_concurrency: true
        ])

      pid ->
        pid
    end
  end

  defp construct_trie(towels) do
    root = %{}

    Enum.reduce(towels, root, fn towel, trie ->
      chars = String.codepoints(towel)

      insert_trie(trie, chars)
    end)
  end

  defp insert_trie(trie, []), do: trie

  defp insert_trie(trie, [c]) do
    updated_node =
      trie
      |> Map.get(c, %{})
      |> Map.put(:end, true)

    Map.put(trie, c, updated_node)
  end

  defp insert_trie(trie, [c | rest]) do
    updated_node =
      trie
      |> Map.get(c, %{})
      |> insert_trie(rest)

    Map.put(trie, c, updated_node)
  end

  #### NOTE: This doesnt move to the child trie, that's the problem

  # defp insert_trie(trie, chars) do
  #   [c | rest] = chars
  #
  #   case rest do
  #     [] ->
  #       Map.update(trie, c, %{:end => true}, fn existing ->
  #         Map.put(existing, :end, true)
  #       end)
  #
  #     _ ->
  #       Map.update(trie, c, %{}, fn existing ->
  #         insert_trie(existing, rest)
  #       end)
  #   end
  # end

  defp is_possible?(full_trie, trie, pattern) do
    case :ets.lookup(:cache, {trie, pattern}) do
      [] ->
        result = is_possible_impl?(full_trie, trie, pattern)
        :ets.insert(:cache, {{trie, pattern}, result})
        result

      [{_, result}] ->
        result
    end
  end

  # NOTE: must do Map.has_key?() to ensure the trie is at a valid endpoint
  defp is_possible_impl?(_full_trie, trie, []) do
    Map.has_key?(trie, :end)
  end

  defp is_possible_impl?(full_trie, trie, pattern) do
    [c | rest] = pattern

    case trie[c] do
      nil ->
        false

      curr ->
        continue = is_possible?(full_trie, curr, rest)
        restart = Map.has_key?(curr, :end) and is_possible?(full_trie, full_trie, rest)
        continue or restart
    end
  end

  defp parse(file) do
    [towels_str, designs_str] = String.split(file, "\n\n", trim: true)
    towels = String.split(towels_str, ", ", trim: true)
    patterns = String.split(designs_str, "\n", trim: true)
    {towels, patterns}
  end
end
