defmodule Day15 do
  @up "^"
  @left "<"
  @right ">"
  @down "v"

  @box "O"
  @wall "#"
  @robot "@"
  @empty "."
  @box_left "["
  @box_right "]"

  def solve(filename) do
    input = File.read!(filename)
    {grid, nrows, ncols, moves} = parse(input)
    start = find_robot(grid)
    # AocUtil.inspect_grid(grid, nrows, ncols)
    {final_grid, _} = move_robot(grid, nrows, ncols, moves, start)
    calc_grid(final_grid)
  end

  defp get_space(grid, robot, iter, get_new) do
    {i, j} = robot

    Enum.reduce_while(iter, {0, robot, 0}, fn dc, acc ->
      {num_boxes, last_box_space, _} = acc
      new_coord = get_new.(i, j, dc)

      ele = grid[new_coord]

      case ele do
        @wall -> {:halt, {num_boxes, last_box_space, dc - 1}}
        @empty -> {:halt, {num_boxes, new_coord, dc}}
        @box -> {:cont, {num_boxes + 1, new_coord, dc}}
        @box_left -> {:cont, {num_boxes + 1, new_coord, dc}}
        @box_right -> {:cont, {num_boxes, new_coord, dc}}
      end
    end)
  end

  # robot moves to empty
  # robot fails due to box next to wall
  # robot fails due to next to wall
  # robot pushes box(es) to empty
  defp move_boxes(grid, num_boxes, dist, avail, robot, get_new) do
    {i, j} = robot

    if dist == num_boxes do
      # no need to move any boxes, or robot next to wall
      {grid, robot}
    else
      grid = %{grid | robot => @empty}
      new_robot = get_new.(i, j, 1)
      # overwriting handles case where new_robot == avail i.e. robot moves to empty
      grid = %{grid | avail => @box}
      grid = %{grid | new_robot => @robot}

      {grid, new_robot}
    end
  end

  defp move_robot(grid, _nrows, _ncols, [], robot), do: {grid, robot}

  defp move_robot(grid, nrows, ncols, moves, robot) do
    move = hd(moves)
    fup = fn i, j, dc -> {i - dc, j} end
    fdown = fn i, j, dc -> {i + dc, j} end
    fleft = fn i, j, dc -> {i, j - dc} end
    fright = fn i, j, dc -> {i, j + dc} end

    # iterator, dir to move in, opposite dir 
    {iter, get_new} =
      case move do
        @up -> {1..nrows, fup}
        @down -> {1..nrows, fdown}
        @left -> {1..ncols, fleft}
        @right -> {1..ncols, fright}
      end

    # find next wall or empty space in dir robot is moving
    # update grid for boxes
    {num_boxes, next_avail, dist} = get_space(grid, robot, iter, get_new)
    {grid, robot} = move_boxes(grid, num_boxes, dist, next_avail, robot, get_new)
    # AocUtil.inspect_grid(grid, nrows, ncols)
    move_robot(grid, nrows, ncols, tl(moves), robot)
  end

  defp parse(input) do
    [input_grid, moves_split | []] = String.split(input, "\n\n", trim: true)
    {grid, nrows, ncols} = AocUtil.parse_grid(input_grid)

    moves =
      String.replace(moves_split, "\n", "")
      |> String.codepoints()

    {grid, nrows, ncols, moves}
  end

  def calc_grid(grid, ele \\ @box) do
    grid
    |> Enum.filter(fn {_coord, val} -> val == ele end)
    |> Enum.map(fn {{i, j}, _val} -> 100 * i + j end)
    |> Enum.sum()
  end

  defp find_robot(grid) do
    Enum.reduce_while(grid, {0, 0}, fn {coord, ele}, _acc ->
      if ele == @robot do
        {:halt, coord}
      else
        {:cont, coord}
      end
    end)
  end

  def part2(filename) do
    input = File.read!(filename)
    {grid, nrows, ncols, moves} = parse(input)
    grid = resize_grid(grid)
    ncols = ncols * 2
    AocUtil.inspect_grid(grid, nrows, ncols)

    start = find_robot(grid)
    final_grid = move_robot2(grid, nrows, ncols, moves, start)
    calc_grid(final_grid, @box_left)
  end

  # robot moves to empty
  # robot fails due to at least one box next to wall
  # robot fails due to next to wall
  # robot pushes box(es) to empty
  defp move_robot2(grid, nrows, ncols, moves, robot) do
    fup = fn i, j, dc -> {i - dc, j} end
    fdown = fn i, j, dc -> {i + dc, j} end
    fleft = fn i, j, dc -> {i, j - dc} end
    fright = fn i, j, dc -> {i, j + dc} end

    {final_grid, _robot} =
      Enum.reduce(moves, {grid, robot}, fn move, {grid, robot} ->
        # iterator, dir to move in, opposite dir 
        {iter, get_new} =
          case move do
            @up -> {1..nrows, fup}
            @down -> {1..nrows, fdown}
            @left -> {1..ncols, fleft}
            @right -> {1..ncols, fright}
          end

        check_move(grid, robot, iter, get_new)
      end)

    final_grid
  end

  defp check_move(grid, robot, iter, get_new) do
    {i, j} = robot
    {num_boxes, coord, dist} = get_space(grid, robot, iter, get_new)

    cond do
      # no need to move any boxes, or robot next to wall
      dist == num_boxes * 2 ->
        {grid, robot}

      num_boxes == 0 ->
        # move robot 1 square
        new_robot = get_new.(i, j, 1)

        grid = %{grid | robot => @empty}
        grid = %{grid | new_robot => @robot}
        {grid, new_robot}

      true ->
        {grid, robot} =
          Enum.reduce(1..num_boxes, {grid, robot, @box_right}, fn dc, acc ->
            {grid, coord, last_box_side} = acc
            last_box_side = (last_box_side == @box_left && @box_right) || @box_left

            new_coord = get_new.(i, j, 1 + dc)

            {grid, new_coord, last_box_side}
          end)

        {grid, robot}
    end
  end

  defp resize_grid(grid) do
    grid
    |> Enum.reduce(%{}, fn {{i, j}, val}, acc ->
      case val do
        @wall ->
          acc = Map.put(acc, {i, 2 * j}, @wall)
          acc = Map.put(acc, {i, 2 * j + 1}, @wall)
          acc

        @empty ->
          acc = Map.put(acc, {i, 2 * j}, @empty)
          acc = Map.put(acc, {i, 2 * j + 1}, @empty)
          acc

        @box ->
          acc = Map.put(acc, {i, 2 * j}, @box_left)
          acc = Map.put(acc, {i, 2 * j + 1}, @box_right)
          acc

        @robot ->
          acc = Map.put(acc, {i, 2 * j}, @robot)
          acc = Map.put(acc, {i, 2 * j + 1}, @empty)
          acc
      end
    end)
  end
end
