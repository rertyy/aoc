defmodule Day14 do
  def solve(filename, width \\ 101, height \\ 103, nsecs \\ 100) do
    # reminder to not +1 here...
    mid_height = div(height, 2)
    mid_width = div(width, 2)

    # y < mid_height and x < mid_width
    cond = fn {f1, f2} ->
      fn {x, y} ->
        f1.(y, mid_height) and f2.(x, mid_width)
      end
    end

    positions =
      File.read!(filename)
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_machine/1)
      |> Enum.map(&do_iter(&1, nsecs, height, width))
      |> Enum.reject(fn {x, y} -> x == mid_width or y == mid_height end)

    conds =
      [{&</2, &</2}, {&</2, &>/2}, {&>/2, &</2}, {&>/2, &>/2}]
      |> Enum.map(fn ops -> cond.(ops) end)

    conds
    |> Enum.map(fn f ->
      positions
      |> Enum.filter(fn pos -> f.(pos) end)
      |> Enum.count()
    end)
    |> Enum.product()
  end

  defp parse_machine(s) do
    [x, y, dx, dy] =
      Regex.scan(~r/-?\d+/, s)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {{x, y}, {dx, dy}}
  end

  defp do_iter({{x, y}, {dx, dy}}, nsecs, height, width) do
    1..nsecs
    |> Enum.reduce({x, y}, fn _, {x, y} ->
      # add width to allow wrap around
      x = rem(x + dx + width, width)
      y = rem(y + dy + height, height)
      {x, y}
    end)
  end
end
