(*
   0   3   6   9  12  15
     3   3   3   3   3
       0   0   0   0

   What to do if 3 4 and the last sequence is just 1 though
*)

let extrapolate last_vals = List.fold_left ( + ) 0 last_vals

let rec solve_line line last_vals =
  let tail = match line with [] -> [] | _ :: t -> t in
  let diffs, prev, only_zeroes =
    List.fold_left
      (fun (lst, prev, only_zeroes) x ->
        ((x - prev) :: lst, x, x = 0 && only_zeroes))
      ([], List.hd line, true)
      tail
  in
  (* let _ = Printf.printf "Last_vals \n" in
     let _ = List.iter (Printf.printf "%d ") last_vals in
     let _ = Printf.printf "\n" in
     let _ = Printf.printf "Diffs \n" in
     let _ = List.iter (Printf.printf "%d ") diffs in
     let _ = Printf.printf "\n" in *)
  if only_zeroes = true then extrapolate last_vals
  else solve_line (List.rev diffs) (prev :: last_vals)
(*
   List.rev diffs |> List.iter (fun x -> Printf.printf "%d " x);
   Printf.printf "\n";
   List.rev diffs *)

let solve lines =
  List.map
    (fun line -> String.split_on_char ' ' line |> List.map int_of_string)
    lines
  |> List.map (fun line -> solve_line line [])
  |> List.fold_left ( + ) 0

let read_lines file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter (fun line -> line <> "")

let () = read_lines "input.txt" |> solve |> Printf.printf "%d\n"
