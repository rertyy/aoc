defmodule Machine do
  defstruct [:ax, :ay, :bx, :by, :px, :py]
end

defmodule Day13 do
  def solve(filename) do
    file = File.read!(filename)

    file
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_machine/1)
    |> Enum.map(&calc_vals/1)
    |> Enum.sum()
  end

  def part2(filename) do
    file = File.read!(filename)

    file
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_machine2/1)
    |> Enum.map(&calc_vals/1)
    |> Enum.sum()
  end

  defp parse_machine(s) do
    [x1, y1, x2, y2, x3, y3] =
      String.split(s, "\n")
      |> Enum.map(fn s ->
        Regex.scan(~r/\d+/, s)
      end)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    # %Machine{ax: ax, ay: ay, bx: bx, by: by, px: px, py: py}
    [x1, y1, x2, y2, x3, y3]
  end

  defp parse_machine2(s) do
    diff = 10_000_000_000_000

    [x1, y1, x2, y2, x3, y3] =
      String.split(s, "\n")
      |> Enum.map(fn s ->
        Regex.scan(~r/\d+/, s)
      end)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    [x1, y1, x2, y2, x3 + diff, y3 + diff]
  end

  defp calc_vals(m) do
    [x1, y1, x2, y2, x3, y3] = m

    # seems like input has no +0, so no need to check

    # using some simultaneous equations
    # b = (x3 - x1 * a) / x2
    # b = (y3 - y1 * a) / y2
    # etc
    # also Cramer's rule exists

    a_num = x2 * y3 - x3 * y2
    a_den = x2 * y1 - x1 * y2
    a = a_num / a_den
    b = (x3 - x1 * a) / x2

    if trunc(a) == a and trunc(b) == b do
      3 * trunc(a) + trunc(b)
    else
      0
    end
  end
end
