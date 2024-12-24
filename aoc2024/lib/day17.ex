defmodule Day17 do
  def part2(_filename) do
    # from input, chunked into pairs
    # [(2, 4), (1, 7), (7, 5), (0, 3), (4, 0), (1, 7), (5, 5), (3, 0)]
    # the only jump is at the end and goes back to the start
    # prints only occur with combo operand 5 (reg B)
    # i.e. every time it reaches the pair (5,5), reg B must contain the current element

    # there are 16 elements to be printed
    # so the range [(2, 4) .. (1,7)] must print the correct value 16 times,
    # then regA must be 0 on the 17th run
  end

  def solve(filename) do
    file = File.read!(filename)

    input = parse(file)

    [regA, regB, regC | prog] = input

    solve(regA, regB, regC, prog)
  end

  def solve(regA, regB, regC, prog, debug \\ false) do
    prog_map =
      prog
      |> Enum.with_index()
      |> Enum.into(%{}, fn {e, i} -> {i, e} end)

    prog_size = map_size(prog_map)

    [regA, regB, regC, pos, result] = run(regA, regB, regC, prog_map, prog_size, 0, [])

    output =
      result
      |> Enum.reverse()
      |> Enum.join(",")

    if debug do
      [regA, regB, regC, pos, output]
    else
      output
    end
  end

  defp run(regA, regB, regC, _prog_map, prog_size, pos, result) when pos >= prog_size - 1 do
    [regA, regB, regC, pos, result]
  end

  defp run(regA, regB, regC, prog_map, prog_size, pos, result) do
    opcode = Map.get(prog_map, pos)
    operand = Map.get(prog_map, pos + 1)

    {regA, regB, regC, pos, result} =
      match_opcode(opcode).(operand, regA, regB, regC, pos, result)

    run(regA, regB, regC, prog_map, prog_size, pos, result)
  end

  defp adv(operand, regA, regB, regC, pos, result) do
    num = regA
    den = 2 ** match_operand(operand, regA, regB, regC)
    regA = trunc(num / den)
    {regA, regB, regC, pos + 2, result}
  end

  defp bxl(operand, regA, regB, regC, pos, result) do
    regB = Bitwise.bxor(regB, operand)
    {regA, regB, regC, pos + 2, result}
  end

  defp bst(operand, regA, regB, regC, pos, result) do
    combo = match_operand(operand, regA, regB, regC)
    regB = rem(combo, 8)
    {regA, regB, regC, pos + 2, result}
  end

  defp jnz(operand, regA, regB, regC, pos, result) do
    if regA == 0 do
      {regA, regB, regC, pos + 2, result}
    else
      {regA, regB, regC, operand, result}
    end
  end

  defp bxc(_operand, regA, regB, regC, pos, result) do
    regB = Bitwise.bxor(regB, regC)
    {regA, regB, regC, pos + 2, result}
  end

  defp out(operand, regA, regB, regC, pos, result) do
    combo = match_operand(operand, regA, regB, regC)
    combo = rem(combo, 8)

    {regA, regB, regC, pos + 2, [combo | result]}
  end

  defp bdv(operand, regA, regB, regC, pos, result) do
    num = regA
    den = 2 ** match_operand(operand, regA, regB, regC)
    regB = trunc(num / den)
    {regA, regB, regC, pos + 2, result}
  end

  defp cdv(operand, regA, regB, regC, pos, result) do
    num = regA
    den = 2 ** match_operand(operand, regA, regB, regC)
    regC = trunc(num / den)
    {regA, regB, regC, pos + 2, result}
  end

  defp parse(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn s ->
      Regex.scan(~r/\d+/, s)
    end)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  defp match_operand(num, regA, regB, regC) do
    case num do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> regA
      5 -> regB
      6 -> regC
      7 -> raise "Invalid combo operand 7"
      _ -> raise "Invalid combo operand"
    end
  end

  defp match_opcode(num) do
    case num do
      0 -> &adv/6
      1 -> &bxl/6
      2 -> &bst/6
      3 -> &jnz/6
      4 -> &bxc/6
      5 -> &out/6
      6 -> &bdv/6
      7 -> &cdv/6
      _ -> raise "Invalid opcode"
    end
  end
end
