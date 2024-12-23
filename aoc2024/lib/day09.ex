defmodule Day9 do
  def solve(filename, part \\ 1) do
    input = File.read!(filename)

    uncompacted =
      input
      |> String.trim()
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)

    total_length =
      uncompacted
      # note: take_every takes starting from first, while drop_every drops starting from first
      |> Enum.take_every(2)
      |> Enum.sum()

    blocks =
      uncompacted
      |> Enum.with_index()
      |> Enum.map(fn {x, i} ->
        if rem(i, 2) == 0 do
          # block index
          {x, div(i, 2)}
        else
          # empty space
          {x, -1}
        end
      end)

    rev = Enum.reverse(blocks)

    case part do
      1 -> defrag(blocks, rev, [], total_length, 0) |> checksum
      2 -> defrag2(blocks, rev) |> checksum_rle
    end
  end

  defp defrag(blocks, rev, newlist, total_length, curr_len) do
    blocks = Enum.drop_while(blocks, fn {count, _blk_idx} -> count == 0 end)
    [{count, blk_idx} | blk_tl] = blocks

    rev = Enum.drop_while(rev, fn {count, blk_idx} -> blk_idx == -1 or count == 0 end)
    [{rev_count, rev_idx} | rev_tl] = rev

    cond do
      curr_len >= total_length ->
        newlist
        |> Enum.drop(curr_len - total_length)
        |> Enum.reverse()

      blk_idx != -1 ->
        newlist = List.duplicate(blk_idx, count) ++ newlist
        defrag(blk_tl, rev, newlist, total_length, curr_len + count)

      blk_idx == -1 ->
        cond do
          count == rev_count ->
            newlist = List.duplicate(rev_idx, count) ++ newlist
            defrag(blk_tl, rev_tl, newlist, total_length, curr_len + count)

          count < rev_count ->
            new_revs = [{rev_count - count, rev_idx} | rev_tl]
            newlist = List.duplicate(rev_idx, count) ++ newlist
            defrag(blk_tl, new_revs, newlist, total_length, curr_len + count)

          count > rev_count ->
            blocks = [{count - rev_count, -1} | blk_tl]
            newlist = List.duplicate(rev_idx, rev_count) ++ newlist
            defrag(blocks, rev_tl, newlist, total_length, curr_len + rev_count)
        end
    end
  end

  defp defrag2(blocks, []), do: blocks

  defp defrag2(blocks, rev) do
    # if you move block 9 to the front, it might take up a space
    # and block8 may no longer fit
    rev = Enum.drop_while(rev, fn {count, blk_idx} -> blk_idx == -1 or count == 0 end)
    [new_elem | rev_tl] = rev
    # not sure how to get an early terminate flag from find_and_replace...
    replaced = find_and_replace(blocks, new_elem)
    defrag2(replaced, rev_tl)
  end

  defp find_and_replace([], _new), do: []

  defp find_and_replace([head | tail], new) do
    {blk_count, blk_idx} = head
    {new_count, _new_idx} = new

    cond do
      #### This is not correct because the larger indexes are moved in front first
      # blk_idx >= new_idx ->
      #   [head | tail]

      # stop elements from moving behind
      head == new ->
        [head | tail]

      blk_idx == -1 and blk_count == new_count ->
        [new | replace_elem(tail, new)]

      blk_idx == -1 and blk_count > new_count ->
        [new, {blk_count - new_count, -1} | replace_elem(tail, new)]

      true ->
        [head | find_and_replace(tail, new)]
    end
  end

  defp replace_elem([], _elem), do: []

  defp replace_elem([head | tail], elem) do
    {count, _index} = elem

    if head == elem do
      [{count, -1} | tail]
    else
      [head | replace_elem(tail, elem)]
    end
  end

  defp checksum(ls) do
    ls
    |> Enum.with_index()
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end

  defp checksum_rle(ls) do
    psums =
      Enum.scan(ls, 0, fn {count, _idx}, acc ->
        acc + count
      end)

    offsets = [0 | Enum.drop(psums, -1)]

    ls
    |> Enum.zip(offsets)
    |> Enum.map(fn {{count, idx}, offset} ->
      if idx == -1 do
        0
      else
        fst = offset
        last = offset + count - 1
        total = idx * div(count * (fst + last), 2)
        total
      end
    end)
    |> Enum.sum()
  end
end
