(* used arrays instead of lists here because not sure if transpose list will stack overflow
 * also don't think rotating is that necessary if I can just iterate over columns*)

let rotate_clockwise grid =
  let transpose arr =
    let rows = Array.length arr in
    let cols = Array.length arr.(0) in
    Array.init cols (fun i -> Array.init rows (fun j -> arr.(j).(i)))
  in

  let reverse row =
    let n = Array.length row in
    let copy = Array.init n (fun i -> row.(i)) in

    let reverse_in_place array =
      let len = Array.length array in
      for i = 0 to (len / 2) - 1 do
        let temp = array.(i) in
        array.(i) <- array.(len - i - 1);
        array.(len - i - 1) <- temp
      done
    in
    reverse_in_place copy;
    copy
  in

  grid |> transpose |> Array.map reverse

let calc_extra row =
  let sums = ref 0 in
  let last_index = ref 0 in
  let found = ref false in
  Array.iteri
    (fun idx ele ->
      (* Printf.printf "%d %b %c %d \n" idx !found ele !sums; *)
      if !found then
        match ele with
        | 'O' -> ()
        | '#' -> found := false
        | '.' ->
            sums := !sums + (idx - !last_index);
            last_index := !last_index + 1
        | _ -> failwith "Unknown char"
      else
        match ele with
        | 'O' ->
            last_index := idx;
            found := true
        | '#' | '.' -> ()
        | _ -> failwith "Unknown char")
    row;
  (* Printf.printf "%d " !sums; *)
  !sums

let original_cost row =
  let ans =
    Array.mapi (fun idx ele -> if ele = 'O' then idx + 1 else 0) row
    |> Array.fold_left ( + ) 0
  in
  (* let _ = Printf.printf "%d " ans in *)
  ans

let solve grid =
  rotate_clockwise grid
  |> Array.map (fun row -> calc_extra row + original_cost row)
  |> Array.fold_left ( + ) 0

let read_lines file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter (fun line -> line <> "")
  |> List.map (fun line -> Array.of_seq (String.to_seq line))
  |> Array.of_list

let print_2d_array arr =
  Array.iter
    (fun row ->
      Array.iter (fun elem -> print_char elem) row;
      print_newline ())
    arr

let () = read_lines "input.txt" |> solve |> print_int
