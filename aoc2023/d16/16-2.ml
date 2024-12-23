let energise result x y = result.(y).(x) <- 1

let next_loc grid result x y dir =
  let memo_table = Hashtbl.create 256 in
  let n_cols = Array.length grid.(0) in
  let n_rows = Array.length grid in

  let rec mem_next_loc x y dir =
    match Hashtbl.find_opt memo_table (x, y, dir) with
    | Some z -> z
    | None -> (
        Hashtbl.add memo_table (x, y, dir) ();
        if x < 0 || y < 0 || x >= n_cols || y >= n_rows then ()
        else
          let () = energise result x y in
          match dir with
          | 'U' -> (
              match grid.(y).(x) with
              | '\\' -> mem_next_loc (x - 1) y 'L'
              | '/' -> mem_next_loc (x + 1) y 'R'
              | '-' ->
                  mem_next_loc (x - 1) y 'L';
                  mem_next_loc (x + 1) y 'R'
              | '|' | '.' -> mem_next_loc x (y - 1) 'U'
              | _ -> failwith "Invalid cell")
          | 'D' -> (
              match grid.(y).(x) with
              | '\\' -> mem_next_loc (x + 1) y 'R'
              | '/' -> mem_next_loc (x - 1) y 'L'
              | '-' ->
                  mem_next_loc (x - 1) y 'L';
                  mem_next_loc (x + 1) y 'R'
              | '|' | '.' -> mem_next_loc x (y + 1) 'D'
              | _ -> failwith "Invalid cell")
          | 'L' -> (
              match grid.(y).(x) with
              | '\\' -> mem_next_loc x (y - 1) 'U'
              | '/' -> mem_next_loc x (y + 1) 'D'
              | '-' | '.' -> mem_next_loc (x - 1) y 'L'
              | '|' ->
                  mem_next_loc x (y - 1) 'U';
                  mem_next_loc x (y + 1) 'D'
              | _ -> failwith "Invalid cell")
          | 'R' -> (
              match grid.(y).(x) with
              | '\\' -> mem_next_loc x (y + 1) 'D'
              | '/' -> mem_next_loc x (y - 1) 'U'
              | '-' | '.' -> mem_next_loc (x + 1) y 'R'
              | '|' ->
                  mem_next_loc x (y - 1) 'U';
                  mem_next_loc x (y + 1) 'D'
              | _ -> failwith "Invalid cell")
          | _ -> failwith "Invalid direction")
  in
  mem_next_loc x y dir

let energised_grid grid =
  let rows = Array.length grid in
  let cols = Array.length grid.(0) in
  Array.init rows (fun _ -> Array.init cols (fun _ -> 0))

let count_ones grid =
  Array.fold_left ( + ) 0 (Array.map (Array.fold_left ( + ) 0) grid)

let solve_one grid x y dir =
  let result = energised_grid grid in
  let () = next_loc grid result x y dir in
  count_ones result

let solve grid =
  let n_rows = Array.length grid in
  let n_cols = Array.length grid.(0) in

  let col_indices = List.init (n_cols - 1) Fun.id in
  let row_indices = List.init (n_rows - 1) Fun.id in

  let max_up =
    List.map (fun x -> solve_one grid x (n_rows - 1) 'U') col_indices
    |> List.fold_left max 0
  in
  let max_down =
    List.map (fun x -> solve_one grid x 0 'D') col_indices
    |> List.fold_left max 0
  in
  let max_left =
    List.map (fun y -> solve_one grid (n_cols - 1) y 'L') row_indices
    |> List.fold_left max 0
  in
  let max_right =
    List.map (fun y -> solve_one grid 0 y 'R') row_indices
    |> List.fold_left max 0
  in

  [ max_left; max_right; max_up; max_down ] |> List.fold_left max 0

let read_lines file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter (fun line -> line <> "")
  |> List.map (fun line -> Array.of_seq (String.to_seq line))
  |> Array.of_list

(* let print_2d_array arr =
   Array.iter
     (fun row ->
       Array.iter (fun elem -> print_char elem) row;
       print_newline ())
     arr *)

let () = read_lines "input.txt" |> solve |> print_int
