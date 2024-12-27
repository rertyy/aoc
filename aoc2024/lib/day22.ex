defmodule Day22 do
  def solve(filename) do
    file = File.read!(filename)

    input = parse(file)

    input
    |> Enum.map(&calculate_secret(&1, 2000))
    |> Enum.sum()
  end

  defp parse(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_secret(num, rounds) do
    Enum.reduce(1..rounds, num, fn _, acc ->
      one_round(acc)
    end)
  end

  defp one_round(num) do
    num = (num * 64) |> mix(num) |> prune()
    num = div(num, 32) |> mix(num) |> prune()
    num = (num * 2048) |> mix(num) |> prune()
    num
  end

  defp mix(value, secret) do
    Bitwise.bxor(value, secret)
  end

  defp prune(secret) do
    rem(secret, 16_777_216)
  end
end
