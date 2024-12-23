defmodule UtilTest do
  use ExUnit.Case
  doctest Util

  test "pairwise" do
    ls = [1, 2, 3, 4]

    tuples = [
      {1, 2},
      {1, 3},
      {1, 4},
      {2, 3},
      {2, 4},
      {3, 4}
    ]

    assert Util.pairwise_unique(ls) == tuples
    assert Util.pairwise_unique(ls, &{&1, &2}) == tuples
    assert Util.pairwise_unique(ls, &(&1 + &2)) == [3, 4, 5, 5, 6, 7]
    assert Util.pairwise_unique(ls, &(&1 * &2)) == [2, 3, 4, 6, 8, 12]
    assert Util.pairwise_unique([], &(&1 * &2)) == []
    assert Util.pairwise_unique([1], &(&1 * &2)) == []
  end

  IO.puts("Testing done")
end
