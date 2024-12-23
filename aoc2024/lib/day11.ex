defmodule Day11 do
  def solve(filename, blinks \\ 25, preserve_stones \\ false) do
    file = File.read!(filename)

    stones =
      file
      |> String.split()
      |> process(blinks)

    if preserve_stones do
      stones |> Enum.join(" ")
    else
      Enum.count(stones)
    end
  end

  @spec process(list(String.t()), integer()) :: list(String.t())
  defp process(stones, blinks) do
    Enum.reduce(1..blinks, stones, fn _, acc ->
      acc
      |> Enum.flat_map(&apply_rules/1)
    end)
  end

  @spec apply_rules(integer()) :: list(String.t())
  defp apply_rules(stone) do
    cond do
      stone == "0" ->
        ["1"]

      is_even_digits?(stone) ->
        process_even(stone)

      true ->
        [
          (String.to_integer(stone) * 2024)
          |> Integer.to_string()
        ]
    end
  end

  @spec is_even_digits?(String.t()) :: boolean()
  defp is_even_digits?(stone), do: rem(byte_size(stone), 2) == 0

  @spec process_even(String.t()) :: list(String.t())
  defp process_even(stone) do
    size = byte_size(stone)
    half = div(size, 2)

    # using pattern matching  
    <<head::binary-size(half), tail::binary>> = stone
    tail = String.replace_leading(tail, "0", "")
    tail = if tail == "", do: "0", else: tail

    # stringlist = String.codepoints(stone)
    # head = Enum.slice(stringlist, 0, half) |> Enum.join()
    #
    # tail =
    #   Enum.slice(stringlist, half, size)
    #   |> Enum.drop_while(&(&1 == "0"))
    #   |> Enum.join()
    #   |> (fn x -> if x == "", do: "0", else: x end).()

    [
      head,
      tail
    ]
  end

  def part2(filename, blinks \\ 75) do
    file = File.read!(filename)

    # start_cache()

    file
    |> String.split()
    |> Enum.frequencies()
    |> enumerate_blinks(blinks)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  ### Use a Counter to avoid enumerating list!
  @spec enumerate_blinks(%{}, integer()) :: integer()
  def enumerate_blinks(stones, blinks) do
    Enum.reduce(1..blinks, {stones, %{}}, fn _, {stones, apply_cache} ->
      Enum.reduce(stones, {%{}, apply_cache}, fn entry, acc ->
        {stone, count} = entry
        {new_stones, apply_cache} = acc

        {new_stone, apply_cache} = process_stone(stone, apply_cache)

        new_stones =
          case new_stone do
            [a, b | []] ->
              new_stones = Map.update(new_stones, a, count, &(&1 + count))
              new_stones = Map.update(new_stones, b, count, &(&1 + count))
              new_stones

            [a] ->
              new_stones = Map.update(new_stones, a, count, &(&1 + count))
              new_stones
          end

        {new_stones, apply_cache}
      end)
    end)
    |> elem(0)
  end

  defp process_stone(stone, apply_cache) do
    case Map.fetch(apply_cache, stone) do
      {:ok, new_stone} ->
        {new_stone, apply_cache}

      :error ->
        new_stone = apply_rules(stone)
        apply_cache = Map.put(apply_cache, stone, new_stone)
        {new_stone, apply_cache}
    end
  end

  #   # using ets and list (too slow)
  #   defp process_ets(stones, 0), do: stones
  #   defp process_ets([], _blinks), do: []
  #
  #   defp process_ets(stones, blinks) do
  #     Enum.reduce(1..blinks, stones, fn _, acc ->
  #       acc
  #       |> Task.async_stream(&ets_stone/1, ordered: false)
  #       |> Enum.flat_map(fn {:ok, new_stone} -> new_stone end)
  #     end)
  #   end
  #
  #   defp start_cache do
  #     case :ets.whereis(:stones) do
  #       :undefined ->
  #         :ets.new(:stones, [
  #           :set,
  #           :public,
  #           :named_table,
  #           read_concurrency: true,
  #           write_concurrency: true
  #         ])
  #
  #       pid ->
  #         pid
  #     end
  #   end
  #
  #   defp ets_stone(stone) do
  #     case :ets.lookup(:stones, stone) do
  #       [] ->
  #         new_stone = apply_rules(stone)
  #         :ets.insert(:stones, {stone, new_stone})
  #         new_stone
  #
  #       [{^stone, result}] ->
  #         result
  #     end
  #   end
  # end
end
