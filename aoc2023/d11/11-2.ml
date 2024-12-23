module IntSet = Set.Make (Int)

type coord = { x : int; y : int }

let get_coordinates y line =
  String.to_seq line |> List.of_seq
  |> List.fold_left
       (fun (x, acc) ele -> (x + 1, if ele = '#' then { x; y } :: acc else acc))
       (0, [])
  |> snd

let num_elements_between set a b =
  IntSet.filter (fun x -> (x > a && x < b) || (x > b && x < a)) set
  |> IntSet.cardinal

let manhattan_distance p1 p2 void_rows void_cols =
  abs (p1.x - p2.x)
  + abs (p1.y - p2.y)
  + (1000000 - 1) * num_elements_between void_rows p1.y p2.y
  + (1000000 - 1) * num_elements_between void_cols p1.x p2.x

let solve lines =
  let coords =
    lines |> List.mapi get_coordinates |> List.flatten
  in
  let line_length = List.hd lines |> String.length in

  let num_lines = List.length lines in

  let row_set = List.init num_lines (fun x -> x) |> IntSet.of_list in
  let col_set = List.init line_length (fun x -> x) |> IntSet.of_list in

  let x_vals = coords |> List.map (fun coord -> coord.x) |> IntSet.of_list in
  let y_vals = coords |> List.map (fun coord -> coord.y) |> IntSet.of_list in

  let void_rows = IntSet.diff row_set y_vals in
  let void_cols = IntSet.diff col_set x_vals in


  let doublecount =
    List.fold_left
      (fun acc p1 ->
        acc
        + List.fold_left
            (fun sum p2 -> sum + manhattan_distance p1 p2 void_rows void_cols)
            0 coords)
      0 coords
  in
  doublecount / 2

let read_lines file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter (fun line -> line <> "")

let () = read_lines "input.txt" |> solve |> print_int
