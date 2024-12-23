type node_dest = { left : string; right : string }

let directions lines = List.hd lines |> String.to_seq |> List.of_seq

let process_nodes lines =
  let nodes = List.tl lines in
  let node_map = Hashtbl.create (List.length nodes) in
  let source s = String.sub s 0 3 in
  let left_dst s = String.sub s 7 3 in
  let right_dst s = String.sub s 12 3 in
  List.iter
    (fun line ->
      Hashtbl.add node_map (source line)
        { left = left_dst line; right = right_dst line })
    nodes;
  node_map

let get_sum node_map directions =
  let rec get_next_node curr_node dir =
    let dst = Hashtbl.find node_map curr_node in
    match dir with
    | 'L' -> dst.left
    | 'R' -> dst.right
    | _ -> get_next_node curr_node (List.hd directions)
  in

  let rec helper curr_node sum cut_directions =
    let cut_directions =
      match cut_directions with [] -> directions | _ -> cut_directions
    in

    match curr_node with
    | "ZZZ" -> sum
    | _ ->
        let dir = List.hd cut_directions in
        let next_node = get_next_node curr_node dir in
        helper next_node (sum + 1) (List.tl cut_directions)
  in
  helper "AAA" 0 directions

let read_lines file =
  In_channel.with_open_text file In_channel.input_all
  |> String.split_on_char '\n'
  |> List.filter (fun line -> line <> "")

let () =
  let lines = read_lines "input.txt" in
  let map = process_nodes lines in
  let dirs = directions lines in
  let sum = get_sum map dirs in
  Printf.printf "%d\n" sum
